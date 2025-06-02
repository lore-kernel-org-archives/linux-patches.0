Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3348922F15E;
	Mon,  2 Jun 2025 14:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874527; cv=none; b=SMVBhw6bID3v/M8L1biw9peOIM0Zu2Ewm19eGWXo0qV+DZZhOuMxhP7Bl2UJtNzxVR+7urfWcy7BBgp9aAcITYw/In4A5dh8qvy3ynmUts/wAZpt7QHEtxGC0orNaF5CBANLWqW+Qp9ChGQd0gDXrQxn15CDDIFL2iZ1eQzFny4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874527; c=relaxed/simple;
	bh=qKI0qulQqytaRgxYbPbLlsSRpqsyLfouXKax5kA2s78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyjJDBBPzmB09OaNB8ulZWiAtZyf4ln+PrLym/7rAj25TEUPUD7jWLbz49NWHYaWOSou6L31NN3QSQlmau9bJIqWHPyKsx8I8qq2cxRMzPzVdGjlaKQfSem094akCG82kCLpbLHTk2esEIR0wodPC5Vi3Z8jpP2mrEXOe5jEnn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+Dp5m0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+Dp5m0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D34C4CEEB;
	Mon,  2 Jun 2025 14:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874527;
	bh=qKI0qulQqytaRgxYbPbLlsSRpqsyLfouXKax5kA2s78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+Dp5m0EClx3VmEZ5W5mM7q0LpNGo8GoFpnfj7VbxOSUCj7ZFPW4PdavIaj9BgG3R
	 NaxA7iBHJonpzCaLCWAg9DtF8yTXkZIyGbtJe4OnKADBbhLdBDAfYLUjwHyumC+V+0
	 cYXnqMIj9ER5MGtx8BaTDj4JX//0MHABIahN2q2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.4 053/204] USB: usbtmc: use interruptible sleep in usbtmc_read
Date: Mon,  2 Jun 2025 15:46:26 +0200
Message-ID: <20250602134257.768272326@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 054c5145540e5ad5b80adf23a5e3e2fc281fb8aa upstream.

usbtmc_read() calls usbtmc_generic_read()
which uses interruptible sleep, but usbtmc_read()
itself uses uninterruptble sleep for mutual exclusion
between threads. That makes no sense.
Both should use interruptible sleep.

Fixes: 5b775f672cc99 ("USB: add USB test and measurement class driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250430134810.226015-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -1350,7 +1350,10 @@ static ssize_t usbtmc_read(struct file *
 	if (!buffer)
 		return -ENOMEM;
 
-	mutex_lock(&data->io_mutex);
+	retval = mutex_lock_interruptible(&data->io_mutex);
+	if (retval < 0)
+		goto exit_nolock;
+
 	if (data->zombie) {
 		retval = -ENODEV;
 		goto exit;
@@ -1473,6 +1476,7 @@ static ssize_t usbtmc_read(struct file *
 
 exit:
 	mutex_unlock(&data->io_mutex);
+exit_nolock:
 	kfree(buffer);
 	return retval;
 }


