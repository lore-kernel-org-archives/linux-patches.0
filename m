Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B307379960;
	Tue, 21 Jul 2026 23:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674824; cv=none; b=FssloGuHORcSIK6gyt8aLxcXkOi+D0+olvemXS1epISxw0HXtuFkvNfSTyrhDkGU/YNPoHdPoUZ3Ird9XnMOWi5bGR46eA8KO094/A3OXA1KkXPLDrVR+o/pUKFekUsDBIf2kFWLCOvVHoQBru1C48sq3bhoo8cl0nslQJgpBl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674824; c=relaxed/simple;
	bh=RlIr2iNCw1MNONO0gMFiECSWmou9sp8mww1oCiBZWGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WjvL1e6V1YiO7DI0KffHauv091Ytw0Arbc6vXZuFZNj5KgNpdSn4epnbsS2/Lg4l2eE9VN0E7gm56IRrEeO95LgYdQR9AokuiYFGXGjVED2M1DK3CBOJU9l0aoRUDNcYL3QZxNfvflZdIg8WabIzLV84tqP4cGJBXQaN3VAPOBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Luma8PFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Luma8PFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD5A1F00A3A;
	Tue, 21 Jul 2026 23:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674823;
	bh=AdFqGlo0Cez34PAS3YhpHgw+w/QTJLh0tlLJ91F+kNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Luma8PFOvi7lkWHuEjgfnJIpBlcJrNVWKFCR7qepcBFNxj9zY5Cw8UVP0CkM5/4Fi
	 0c05ObyFhhP93+STYBixpjDpqoaN/Ashcuy7PBeYhfEO6hIdvV+A3EunZwJhYESGrY
	 di0s6eh09m0gilMg85y3rZrPK6ymUulpWD/L38uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 679/699] usb: gadget: f_fs: Tie read_buffer lifetime to ffs_epfile
Date: Tue, 21 Jul 2026 17:27:18 +0200
Message-ID: <20260721152411.088695761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neill Kapron <nkapron@google.com>

[ Upstream commit 8bdcf96eb135aebacac319667f87db034fb38406 ]

Currently, ffs_epfile_release unconditionally frees the endpoint's
read_buffer when a file descriptor is closed. If userspace explicitly
opens the endpoint multiple times and closes one, the read_buffer is
destroyed. This can lead to silent data loss if other file descriptors
are still actively reading from the endpoint.

By tying the lifetime of the read_buffer to the ffs_epfile structure itself
(which is destroyed when the functionfs instance is torn down in
ffs_epfiles_destroy), we eliminate the brittle dependency on open/release
calls while correctly matching the conceptual lifetime of unread data on
the hardware endpoint.

Fixes: 9353afbbfa7b ("usb: gadget: f_fs: buffer data from ‘oversized’ OUT requests")
Cc: stable <stable@kernel.org>
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://patch.msgid.link/20260619040609.4010746-3-nkapron@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adjusted context in ffs_epfiles_destroy() since 6.12 lacks the simple_remove_by_name() rework and still uses dentry-based cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1279,7 +1279,6 @@ ffs_epfile_release(struct inode *inode,
 
 	ENTER();
 
-	__ffs_epfile_read_buffer_free(epfile);
 	ffs_data_closed(epfile->ffs);
 
 	return 0;
@@ -1945,6 +1944,7 @@ static void ffs_epfiles_destroy(struct f
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
+		__ffs_epfile_read_buffer_free(epfile);
 		if (epfile->dentry) {
 			d_delete(epfile->dentry);
 			dput(epfile->dentry);


