Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2823F9F2F;
	Fri,  4 Sep 2026 05:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498588; cv=none; b=CmQ7ZXKvOvyaiL2tNqZzaEpVzVMIHUswpmQ1LiTWe7+L4pVqagft0C6cfvfdoYE0F07ftOjeSsiwH19SvONVHewcZmdcPE92RodAFQDn2Kua+modRtJf731K6N23rSQcNB5+JF7wx6GkVQTvhfoOfgds2nyDI4y0aUjc7ZnGl9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498588; c=relaxed/simple;
	bh=syiuVh5kWp8lLqPHI2I7yw4TbT8DK5yIvz1DiEGONzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SiefNK97fIr6qOND4KMkp70+lOkLyCrPZs+xtQJ8EqpiUXKd2JLLiMOgGm6m/6gBmPsciWN+dhsrFk5koq4dc0sDhzDhpH3dfdy7f9Qk4rmlYV3XXEGwVhX8FOjEGXMucQZXEX+a96hrliLiSx4XWkF5oe6NzQ+admlhbGZRhxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aix+8ct5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aix+8ct5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83771F00A3D;
	Fri,  4 Sep 2026 05:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498587;
	bh=dZzLUt/f3QrwFh0+vBZ4rC/TvMAzg3UBVycK9c8ed70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aix+8ct5diIbmojABwoaNx+PaS5emYlu1/0Ofp66WztHVVYgSYE5Rve9B9dnZWjix
	 41ElhWe7bwNtmyy5dSfELUIie194Us9Ldp9SqgaXa70RW6H4uFtm4Ww8uP+azUUmx+
	 Mki8TtdsNVXdS2rYk+0Rw8zNIJ7yaitb6ivO4QXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8dcac923582c28505fd7@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 7.2 115/713] usb: gadget: uvc: Fix null pointer dereference in uvcg_video_init()
Date: Fri,  4 Sep 2026 06:51:23 +0200
Message-ID: <20260904045806.414829772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffin Philip <jeffinphilip14@gmail.com>

commit 5b1da38592efdc1a263d4c0353298cba19e9d6fc upstream.

In uvcg_video_init(), if kthread_run_worker() fails,
the error logged uses uvcg_err(), however, the pointer it uses:
video->uvc is not assigned at this point, triggering a null
pointer dereference. Fix this by directly using uvc->func which
is assigned already.

Reported-by: syzbot+8dcac923582c28505fd7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8dcac923582c28505fd7
Fixes: f0bbfbd16b3b ("usb: gadget: uvc: rework to enqueue in pump worker from encoded queue")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260804034338.7976-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -821,7 +821,7 @@ int uvcg_video_init(struct uvc_video *vi
 	/* Allocate a kthread for asynchronous hw submit handler. */
 	video->kworker = kthread_run_worker(0, "UVCG");
 	if (IS_ERR(video->kworker)) {
-		uvcg_err(&video->uvc->func, "failed to create UVCG kworker\n");
+		uvcg_err(&uvc->func, "failed to create UVCG kworker\n");
 		return PTR_ERR(video->kworker);
 	}
 


