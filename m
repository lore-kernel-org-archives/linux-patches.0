Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B44137750;
	Sat, 30 May 2026 18:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167018; cv=none; b=OMRDKXkzjO8vKDL9kUTgVLPPdeufjSoz1UUnX21gW3/A0NO/wVFNiweM1oxwQyqwgWvMxxXFBk65enYFeTed8NyDbCPgzHKP3bZJlDfSgWiK5wHGXwgGCZcoc+216X5jPxeDe4tv9ihr6wnbP+AY+ASQXMGeYkLijzGA+oF6RYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167018; c=relaxed/simple;
	bh=SKTGVG1R44ZdIx/AxO5yWA743zY1ZESykpesX4bmi0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJmpd0jEtGaN8FZo0tf7iXRBkCtiOd0IUi24AOM2rK6HVPnwGY/aHtqLX7G5e7PT5Mvks8pQgtDFfpZ9jzVd1alQ4MTVTQKbL3RiisGFDiyz94u9NpdDTEFiu/AZbASNtLAUgyHQxJ16WR9M8zoZ42GvFvYVeKpEZByFafICqog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICJQ+tVZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICJQ+tVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5BC1F00893;
	Sat, 30 May 2026 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167017;
	bh=m8rJHqGpp0gcVajv0OpQLW9W4v4nkyxPgEJSZ38k43Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICJQ+tVZ8g/VcBCO7/wJHZF2a8mH5L3flfjMujbrYC5ysHO3hAEaf6g28i19Q4voG
	 bvtSPlKarKlsr7lJaJOWZU/I0VRNl14DUbikU3gB0n1rlC9/EgdkJJt0YSPGOukaPt
	 CsuLBRBDbJCqWAzoYXCkDJYKQa9FanwXeBEP5RYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.10 510/589] ceph: fix a buffer leak in __ceph_setxattr()
Date: Sat, 30 May 2026 18:06:31 +0200
Message-ID: <20260530160238.008128786@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1132,6 +1132,7 @@ retry:
 
 do_sync:
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_buffer_put(old_blob);
 do_sync_unlocked:
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);


