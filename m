Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2958A2FDC5E;
	Sat, 30 May 2026 17:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162094; cv=none; b=T6JunrAhgP0mWH0l/z/5yiyOoH8YVQDzq+5Pc6lj71wi72YXre9mVp34gC3y0N7NXCzIhCnuyYlw7U6gC2W7BGt7vGeEuEqx3Nr4neMjI46M7PkR2qvrAFoluEa4e5hsLevZnjxZGF8U1UMASCPy97xXRqKtdw1iY9X+K2aX4dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162094; c=relaxed/simple;
	bh=lUo2ihQwLRjQ6Z+vZ7g0Z50+Fq3sDAolrZiVQkmRChc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfRtkV31qOZyOeZnHmEj8Oa3daCHy3ga9SMLno93fHgKuyCzM3nzUcHhPHTmk8OFrJHa3yndHsxyTdtz9Vx13nXGBjZhXsAlpdITQvlyvkIrKs12gkR/j6AR9Gep13qdO3wYagm5cajl4iYobjpVNPalqKveeONv+qY2WhcWqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ONN88ULy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ONN88ULy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCCB1F00893;
	Sat, 30 May 2026 17:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162093;
	bh=mqFp6/7bBkmQRzkzOdJtHsyjYuUWenVV8b+eNMijMB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ONN88ULy54oCHmpK2NG9mXEvEZN0gnWPV5HzuQQ9mBBRpiRQhLXWIWr2KC3XyQpR/
	 tRbgw8dpPP/BFSOvg+Q4VkA+ITMS1h8qmiypJf8pqEMSI4ubSFbsttlg/VXgWWh53F
	 o3YIvnkGgiDNTAjl5wT1LuHjY0Vm0lcbOuTTuPgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.1 818/969] ceph: fix a buffer leak in __ceph_setxattr()
Date: Sat, 30 May 2026 18:05:42 +0200
Message-ID: <20260530160323.228349630@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

commit 5d3cc36b4e77a27ce7b686b7c59c7072bcb3fa8e upstream.

The old_blob in __ceph_setxattr() can store
ci->i_xattrs.prealloc_blob value during the retry.
However, it is never called the ceph_buffer_put()
for the old_blob object. This patch fixes the issue of
the buffer leak.

Cc: stable@vger.kernel.org
Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/xattr.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1246,6 +1246,7 @@ retry:
 
 do_sync:
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_buffer_put(old_blob);
 do_sync_unlocked:
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);


