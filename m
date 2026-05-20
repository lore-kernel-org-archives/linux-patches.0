Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C054028D6;
	Wed, 20 May 2026 18:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302976; cv=none; b=WUbqT+bIrKwnhUaIUIs8kbbB8X+sCw4e/xnz6mJWEbC+Y99RkM9uCKVX2pcUb3c6i0KflCaVun09se/mVNFZ0OzfGlCbZE4JLLH7IDRtUsVvdU60lpNpTQzJq9bB68xZ13d6UOTCac/fNDfk29Z93AwqvHEkHLF3UKkd+vPMqDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302976; c=relaxed/simple;
	bh=F0wXsSBmaLCnxF4DPXWFkdzpQOAWbD9kRMgliWTqR6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPTB6D2DEwoTA++uoHJ8W+57RowVS65c+QxSbNrZx15MS+plGsSMUNlKUsmwEGbBX5O87nf+WMbmGj3eVG4VGChaSw1Iv6VgY4n7iLGMMTzvG8XOhhuCxu5rXfYvrWChqNEc1Q4K9Qemaahgz4WYwuu+lvSihNtNaKuvQb3bSi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jswzu+nu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jswzu+nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0E41F000E9;
	Wed, 20 May 2026 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302974;
	bh=+BNwY4OpMtqzLPs8JjalyFfvWOdpAck/1CBZA8T0GS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jswzu+nuWxw8/WZXNVNJOFsNVcV01OcMTw5I66gV/cvSJhofnWrQ0YsYwlYya7uk6
	 G5M8AvOWeskTotFcfC65kRTEgRqXfBDEtJ20cd/HSD2vUwcJwz5DC35Pz8zkPWxl3X
	 A4xQ4//31AZbw8h8cE5sKpX+5bXS1NAWi8sZkbm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.6 470/508] ceph: fix a buffer leak in __ceph_setxattr()
Date: Wed, 20 May 2026 18:24:53 +0200
Message-ID: <20260520162108.779617111@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1279,6 +1279,7 @@ retry:
 
 do_sync:
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_buffer_put(old_blob);
 do_sync_unlocked:
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);


