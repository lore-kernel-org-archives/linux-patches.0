Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D6936F421;
	Wed, 20 May 2026 17:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297323; cv=none; b=SeRrh1vX37zKBkyvNIjO5qqOcvECdcKoQAmUumxpZP5sm9XvULYVElKbyit7csofK/85pSPyD1ROcu977DU011aRciHZCj5aZz2m6CFnFMRytTtRu0eFj5ST6CywEY+UIBgkVmBILwOyQQ0sUZOS4AHZji/xMspMKmlkRI4TmD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297323; c=relaxed/simple;
	bh=8lPfHbOnLo3mfgPC42n+avaCRGbSFCfUo4VSdy0+2lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMd2FkAB3a0d0GVNJ/5I8MqBoB23nX4KqoQwp1hjCzLWZS4nfIrvksS+RBFnNATr93MrlIsMCWf6o/UMe+1SYM2+R90fxMefI1DpB4+JhePVoPWfqyE3HLlffQAJH3mCheY43TXhXktGM573V2N3aHZdRsdNjZAamYi25NLWbqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUGDw/Gv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUGDw/Gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586B01F000E9;
	Wed, 20 May 2026 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297322;
	bh=YD2dWraivMyHmgaE+G9GNTU5lBrtTSBP/HEny8O00W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUGDw/GvHPB7cvuQuRJbXPNBAt8wjsXtfOW8laFYN2iUa4Ifgki7GNB8RPgWi12s8
	 F0pp3el5VkSARVyVyIBGYK7ucjv0XupAdTWBfKRo9b3F3EKGODCRditHf4y2Zgu/Uw
	 t6/ZtNm0tvk38s43qy0ecfi3HXRoK3ZN2LJ4lnkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.0 1094/1146] ceph: fix a buffer leak in __ceph_setxattr()
Date: Wed, 20 May 2026 18:22:24 +0200
Message-ID: <20260520162212.999149337@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1294,6 +1294,7 @@ retry:
 
 do_sync:
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_buffer_put(old_blob);
 do_sync_unlocked:
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);


