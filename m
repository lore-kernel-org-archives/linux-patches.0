Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1AD51A08CA;
	Mon, 12 May 2025 17:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072510; cv=none; b=dzxMSwE0kfuiM3597qsSPuqs/wlT36dWL526tBmg2rTUfj1teFJgBjBQa7oB4YZi7sdHXuS4I+0jjcf+PaVmGANPukQdZ5tVvMkryFNE6vY1c6HXv299iCfMpxXhQ0GYIp494L8N+mlc2L9ihsQrwhNU6HT6fdohUWu8mqSDPfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072510; c=relaxed/simple;
	bh=zZDIVc1jRPyXh+o4Albut0Vuivg1ohqxvIyt1Ks04FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMgBI1/NvYc4KwvT0Ovc+MZWujeO7WZtDS2IlFV7OGN1FoviBCmrFR9Yw+Yr6ZY8lsOdn02AXeYEAAcpgc7a5G06eEmxoWQA2/N2MWUvn92byxEja5xH38fFD465P8EUxCh4p9I7+q4DtUvnmIIv2PVe0eJcBXCFJcnbj40pfLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgoTiqrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgoTiqrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380ABC4CEE7;
	Mon, 12 May 2025 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072510;
	bh=zZDIVc1jRPyXh+o4Albut0Vuivg1ohqxvIyt1Ks04FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgoTiqrrjV5nB53mqoH6UNH1iwmNYqE/AIrDHswBzpPcawxe3bVNvcxnKdvMpbyY5
	 An/xEgm3/C2gm0MfXh31DNEzx6EH/nfmi+Pjy6IAEnYfuWpdtYfAQobPBno1f5HukQ
	 cTlCcYVO1IlnwYp6twVrRQt2olE/PMWPLjFhQ+0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.1 56/92] USB: usbtmc: use interruptible sleep in usbtmc_read
Date: Mon, 12 May 2025 19:45:31 +0200
Message-ID: <20250512172025.398684882@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


