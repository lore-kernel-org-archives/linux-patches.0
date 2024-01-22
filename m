Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938EF745EF;
	Tue, 23 Jan 2024 02:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975461; cv=none; b=nGVQpcmcwqj0blLt9jIIjYAAf+JNswCDGJdnLEVye0Fg4K8FFKac/Vde33JyJpEhELEGPzF5D51tBcfkLaun2FZEYfFijHL+ojOg7xQ8pf5EZCUMJ2A1wX6IhdrMLHpYheW8ehIaG0UBL/RSHZzfwS4I6Tu4G+/pWqvEXr+k8k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975461; c=relaxed/simple;
	bh=7ZUTIbTkyKZozp4L8flRsZSYhZ7cJJgtsGSC5671vdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwvPDi4bXAWIoYNNCIk+jL3ow+hIYYO3956N4FrKwf6VgX/cVEnhKe4RnAWhnhkAaFD9kW3/uhKjIZMCgToNVZpGe8Aj2qY9Pfbt1ZIBC2WgMo1mnNQfHezDPTyy9wN3N7P46KSKa/fljhbCwMuAO3+0mnukkXn1sBwIOEqQu04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oEcBXHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oEcBXHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2C4C433C7;
	Tue, 23 Jan 2024 02:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975461;
	bh=7ZUTIbTkyKZozp4L8flRsZSYhZ7cJJgtsGSC5671vdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oEcBXHWqECBB0o4nrmZyXFiKCW1OlxS03ZZ8+yxQQLd1jJySucNQcXHbXF6ITZOq
	 UJO/ZCK6WpmEpHnvMmuUthjnxtnaylGPoHPPPzUhsD9XKBEslCKSFPTNiN8/qn+33M
	 BGx5iyfSSwdWxz5nvZ7lxBQ8jp48+TGppsN+Qpfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 393/583] fbdev: flush deferred IO before closing
Date: Mon, 22 Jan 2024 15:57:24 -0800
Message-ID: <20240122235824.006660297@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Nam Cao <namcao@linutronix.de>

commit 33cd6ea9c0673517cdb06ad5c915c6f22e9615fc upstream.

When framebuffer gets closed, the queued deferred IO gets cancelled. This
can cause some last display data to vanish. This is problematic for users
who send a still image to the framebuffer, then close the file: the image
may never appear.

To ensure none of display data get lost, flush the queued deferred IO
first before closing.

Another possible solution is to delete the cancel_delayed_work_sync()
instead. The difference is that the display may appear some time after
closing. However, the clearing of page mapping after this needs to be
removed too, because the page mapping is used by the deferred work. It is
not completely obvious whether it is okay to not clear the page mapping.
For a patch intended for stable trees, go with the simple and obvious
solution.

Fixes: 60b59beafba8 ("fbdev: mm: Deferred IO support")
Cc: stable@vger.kernel.org
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fb_defio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -313,7 +313,7 @@ static void fb_deferred_io_lastclose(str
 	struct page *page;
 	int i;
 
-	cancel_delayed_work_sync(&info->deferred_work);
+	flush_delayed_work(&info->deferred_work);
 
 	/* clear out the mapping that we setup */
 	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {


