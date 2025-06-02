Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6C820F07C;
	Mon,  2 Jun 2025 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875241; cv=none; b=DBEN2mnTZ66TEWqWpgn6Jdm5miq94EA6wQrOhZW13h3wWifV5mOFZrLdkknXXrT5mr49W7PptntE7yFQZh+gG5NytnDvzbdLaPB6CPV1K7a6+SGVVCJgDLpcL/BCA+aPKJYKRLAO9HTBWEhZBihSkuRWVZ814GbHvqfSwRFg4g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875241; c=relaxed/simple;
	bh=MV1m3DCFnLcwJCYXZfU2NruJ620tj1gKvi+xdqTRLbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5kPrNv/CAQ+bEDGs6HgDXXP4YAYYksuNzCUYptq2UZnG+MoQO9e67Z8+ERzsOkbzer1Bs25rerOMmUVhbepvpj07ZDllNNpB+0irjmtYR+Ou1Zax5pS/ST5L1TC6TPeNAbk6waZvQMFpGYRoPRgF8iMRmGlu6LsR/NipQ06C+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yJi9L0V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yJi9L0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC36C4CEEB;
	Mon,  2 Jun 2025 14:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875241;
	bh=MV1m3DCFnLcwJCYXZfU2NruJ620tj1gKvi+xdqTRLbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yJi9L0VbFNJvBWLlARVlBqQMTolKB8URinH3YS+J4WwVlvDp8gZ3H7TqI+Ynk7nJ
	 CotCUytLvRsHOeE7SYJZoQVO800dxBWOfZGOs+1/5RkJqFDydLkR3/qyD0HX8Eg+bv
	 FVBaTWtpMEOrTw3sljL7MshYWUamYJjdtgAUr4gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 073/270] USB: usbtmc: use interruptible sleep in usbtmc_read
Date: Mon,  2 Jun 2025 15:45:58 +0200
Message-ID: <20250602134310.167231653@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


