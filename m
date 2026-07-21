Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A6C45A2B9;
	Tue, 21 Jul 2026 21:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667893; cv=none; b=Ytlcprpn5Kao8uNGg8/e/S5kxbSeVlQ79z05pxD68as/ZCY5Ym84/KRjEhNaylFPU+EKj3OGXdmbWLUkklyvGKXh6nNZl+m3XVVdsc3LppyrWZVtVaYc76UVomureya7UpddFrMc66WxNbpJr9u5Upa4Qoph3vZl4i2xM7vSVJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667893; c=relaxed/simple;
	bh=qRJ7NyFEh70S2G44XwSuIXmR35485DKlb/HiRVjfH7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lI1+pZZ7EQjjFir4FG1IQhUo+EV+e4bqo5fJ/vXvfhcpPubbi9zpgpYxgG/KtornRJYSrfi6hY02w3iDqhhlOD4VK3RY13Z/sN45H89g5w6p1prtRF3ejP3AW5Ucbirj2h17p7YweYsvyrz8Qqc4ig6oSUr5lRTTPfqh87lpQdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnrWJOVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnrWJOVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EED1F00A3A;
	Tue, 21 Jul 2026 21:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667890;
	bh=1OALOGFhiXw6KXpfYXQrrJ72SlGVTNpBUJ1DT8vr0n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nnrWJOVf5fKHOXrjEchtnxMdaYZ+xfTFHwD6xgl6sfOIgHfEKsGKK56l51kKT3PFi
	 47CyDgjRNbW0yTYr/mRK4Ys05tPzgCSYZJAJ7lB2aPOSRgrYxKLZkbbF6v8oBUFA9Y
	 MhM0PCx2/mBQeIQ4eIcdPuTnslKtyniIoePUvi5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Neill Kapron <nkapron@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1231/1266] usb: gadget: f_fs: Tie read_buffer lifetime to ffs_epfile
Date: Tue, 21 Jul 2026 17:27:48 +0200
Message-ID: <20260721152509.352573711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1269,7 +1269,6 @@ ffs_epfile_release(struct inode *inode,
 {
 	struct ffs_epfile *epfile = inode->i_private;
 
-	__ffs_epfile_read_buffer_free(epfile);
 	ffs_data_closed(epfile->ffs);
 
 	return 0;
@@ -1893,6 +1892,7 @@ static void ffs_epfiles_destroy(struct f
 
 	for (; count; --count, ++epfile) {
 		BUG_ON(mutex_is_locked(&epfile->mutex));
+		__ffs_epfile_read_buffer_free(epfile);
 		if (epfile->dentry) {
 			d_delete(epfile->dentry);
 			dput(epfile->dentry);


