Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3668229A9F3;
	Mon, 12 May 2025 18:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073440; cv=none; b=SQEPqAshzdeYjztl4LIyTT48+Hk8jwsfC0qqgmgTdo9YL4AaQTwFyEEwolC8ejJCUyFF33m7LJPH44BCWJwfA2KIw3nFm/IaNNMQUquO1gm+D/eRpmtkqT8J51G+jCl01IxBT63ALI/DpkA4mOqj25z3Mu6dNlb0iGJgauDalVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073440; c=relaxed/simple;
	bh=Tc8F9oPPrTQyQekGDOCJtGvWyuBDOSlSUHiXpov9h4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cgy7KcTz99UdPTQ9ui0H0iUxBBrpgus+av6Sd7xjwxDACOz2q23dBPh7DmZGzaUtixQagEOP4hOiCmzFCe5wUl2p9gAojEne2Bny6AP+o7whOXTTBoG7lqdR/IUVTxz7Q/5geNri7NssLzub7GvKP7DGU9LDO8++lHnzxy0YoUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1abqgbaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1abqgbaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982CDC4CEE9;
	Mon, 12 May 2025 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073440;
	bh=Tc8F9oPPrTQyQekGDOCJtGvWyuBDOSlSUHiXpov9h4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1abqgbaBfY2UtPHxIQsbHpwGJZsf7Qr9QvR2G8sy7wwLb04rxtJhoDZKN+yVzsluA
	 jXRHzHSPO0zkBM/kXgteajttMA+cUiIkIb2pY6nPcyHPV1wBmJz3GOjOED6Jhp0JlR
	 3Duza46Mh4tXVvu6s0RWDJtYF5xSZmdOacQhDXtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.6 075/113] USB: usbtmc: use interruptible sleep in usbtmc_read
Date: Mon, 12 May 2025 19:46:04 +0200
Message-ID: <20250512172030.728377306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1380,7 +1380,10 @@ static ssize_t usbtmc_read(struct file *
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
@@ -1503,6 +1506,7 @@ static ssize_t usbtmc_read(struct file *
 
 exit:
 	mutex_unlock(&data->io_mutex);
+exit_nolock:
 	kfree(buffer);
 	return retval;
 }


