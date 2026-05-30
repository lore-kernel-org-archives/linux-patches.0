Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D3529B799;
	Sat, 30 May 2026 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164881; cv=none; b=p+fuA2PDkM4mxGaQmI36gqSzSGPoxr8v3Rstxrj3AKGQJj4nCFpyHplJejxm+8NlmzT8SBuXb/yy9ONthFMtWYB2FmTyf1lwrNoWzGm83yhpUAeNvIvxufjM1NOU1qXq7MeyXmhemF2sK9XWgl6+di//jDW0qd+IG+grHz9B5bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164881; c=relaxed/simple;
	bh=KO0Hi6G4/uNgQVzQW/8WHwaLN09biZfbnBl2iN+mU0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTDukWpunPV0wTn3IyPKssYWx7nTLPiIjv96x7pLveL/jB4VW3F4PHvuxIxmgNhhGlJaCFW5Nj3ur7OIm5HHTtKtoTiR6VAzLUTWP7U9BKrIidQlY+oQczzeq9OLFI/u9XyHVUKXOyEGwBqSixZTW7A0SIo1rsye7KjD3X9PoKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7nSo0+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7nSo0+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95131F00893;
	Sat, 30 May 2026 18:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164880;
	bh=nTUcuUS6VkMzKaP9l1AO6yuTKEIRHlKQ9ym06PrCcyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7nSo0+xR9XLCIbFl1I3W7OyMhnQpXowKKow0H5olHNFmspy7yLgS3BG1CgX6EAzF
	 S7Mj4iEzkhaS1LTukGTv14+XxV7rebv75y3KnVDetFIiVE6nYgXI2wCkzyZTL1qDmW
	 qL34vVPokwTguxzETvmzsmBWT4LKRqpjnktrxydI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 657/776] ceph: fix a buffer leak in __ceph_setxattr()
Date: Sat, 30 May 2026 18:06:11 +0200
Message-ID: <20260530160256.887298066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1233,6 +1233,7 @@ retry:
 
 do_sync:
 	spin_unlock(&ci->i_ceph_lock);
+	ceph_buffer_put(old_blob);
 do_sync_unlocked:
 	if (lock_snap_rwsem)
 		up_read(&mdsc->snap_rwsem);


