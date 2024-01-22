Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E4815CD58;
	Tue, 23 Jan 2024 00:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969757; cv=none; b=QXSEh0TnUSO8naLMUDv1+2JE5nwEz4jJmY+g9cT5blIyRNQ8d8IL/TVSHNSGbzDvEjdPs6QMQ9E92bzaEuNrvDCj5Wkdwx8efGrtDXjpEvnk1jPWNyFRFeWEbW756+x+Psi4Hc9ibYE6SwPpv8LNvb7CLomXuEjUb9Lzf5iWKJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969757; c=relaxed/simple;
	bh=kDJx2ZUcPWmdx9yJ8HVzpKHo3i85HQmfuykPuC9rBo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S745jJ3PlFV5THv1ARW6NzwlQ9X0nKTqDUY+zK43F2ILPI5GS47J3Bp3NwHCZxsSBFw+Cn1qBgXgnw3gZBHQuSUJIqkIsSRb4iQwW8QqymjDIk7m6eQXiuhwegtH0tmLm7zhbu6a4o6DDWm9sbDelJ6ZyruYILb+VKg1KbjnVt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYrXbuQT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYrXbuQT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2AAC43390;
	Tue, 23 Jan 2024 00:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969757;
	bh=kDJx2ZUcPWmdx9yJ8HVzpKHo3i85HQmfuykPuC9rBo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYrXbuQTFOAJbaEgUisTIbuCU0JkEAYtDovPG6AJ7iYkcU7pZ/hKbm8xqku2+EsUT
	 m4CSXgPVhvJSTVcklfeQQjnqeDwrEwdk2LbfhxBsz97I2XL9bXm/Z/Ffq/GANj9jkH
	 z0uL6N+y1k+OWHngw5xevLvOA6LykFe5ntrkWjmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.7 432/641] fbdev: flush deferred IO before closing
Date: Mon, 22 Jan 2024 15:55:36 -0800
Message-ID: <20240122235831.508323854@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


