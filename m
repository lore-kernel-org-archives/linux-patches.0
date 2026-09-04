Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E35F3BFAE0;
	Fri,  4 Sep 2026 05:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498805; cv=none; b=oOhXXfyUAgMtA4kg93S9ekuW2TrFleg6494k75PUfn2nX4wOMkQ+nBLvzXhYfmUOps7YIaVq2qHgXJXZfP06aAqH5tSTYQ3+17MPJeqB0CD9tJ/l6vXAphnAzmzD4ulb70j1qvnMh/BdyAEBspI568Apvp4bhYSIn6R1V/nX/Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498805; c=relaxed/simple;
	bh=x4eBMhnozVz0bz/aAcM0/wBikEDf4fi9L9JMKMBPsx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJaCeXaA12QBFa0V2wYWaPLHxDbM6qqbSVs0GuxmZ3wNtDg/dyIOR/ToaVFiw54gwAGq79YvBpueFH8kmgLjZFugyOWp7hUDzG6rlq4BTsLh3entZAyd+MyjulasiJ7lG6mrBJr0OWQIptTawkTST1yhh3G9Eb1quhjUwsv33+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBveeJ/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBveeJ/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2E61F00A3D;
	Fri,  4 Sep 2026 05:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498804;
	bh=9fi+XyISQl4O8OOifcmpuP5/t9Imu9ftkz6ERM+KX+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FBveeJ/PMViN67YqHO87zQ1j+mFrriOZ+t6ULihKuKTxlYrbLxcjFZFYnFF0+25u1
	 0tQb5LN90eQ2WStcHpdmxWGtnRTxg8NHoveLslpEwD85iMMqqcNE2Kl5YCQRQ64mQH
	 whb6DX7uoI2lRydxG4cn7X1NW2boE92m1X3Esips=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 193/713] nfsd: fix XDR length calculation in nfsd4_ff_encode_layoutget
Date: Fri,  4 Sep 2026 06:52:41 +0200
Message-ID: <20260904045808.138286917@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

commit f9868174af49d207fbaf0c5e055d088a983684af upstream.

The XDR buffer size calculation in nfsd4_ff_encode_layoutget() has
multiple errors that can result in either an out-of-bounds write or
leaking uninitialized kernel memory to the client:

 - fh_len doesn't account for XDR padding on the file handle data
 - uid and gid lengths use "8 + len" but xdr_encode_opaque() actually
   writes "4 + xdr_align_size(len)" bytes
 - ds_len omits the flags and stats_collect_hint fields (8 bytes),
   while len's header constant overestimates by 8 bytes -- these
   partially cancel but leave a net mismatch

The worst case occurs with short strings (e.g. uid=0, gid=0 with an
odd-sized file handle), where the function writes up to 5 bytes past
the reserved XDR buffer. Conversely, when string lengths happen to be
4-byte aligned, the reservation is too large and stale buffer content
is sent to the client.

Fix this by breaking out every encoded field explicitly in the ds_len
calculation, using xdr_align_size() for all variable-length opaque
fields, and correcting the header constants.

Fixes: 9b9960a0ca47 ("nfsd: Add a super simple flex file server")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260528-pnfs-fixes-v1-1-8a1255ae2f16@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/flexfilelayoutxdr.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/nfsd/flexfilelayoutxdr.c
+++ b/fs/nfsd/flexfilelayoutxdr.c
@@ -30,19 +30,24 @@ nfsd4_ff_encode_layoutget(struct xdr_str
 	struct ff_idmap uid;
 	struct ff_idmap gid;
 
-	fh_len = 4 + fl->fh.size;
+	fh_len = 4 + xdr_align_size(fl->fh.size);
 
 	uid.len = sprintf(uid.buf, "%u", from_kuid(&init_user_ns, fl->uid));
 	gid.len = sprintf(gid.buf, "%u", from_kgid(&init_user_ns, fl->gid));
 
-	/* 8 + len for recording the length, name, and padding */
-	ds_len = 20 + sizeof(stateid_opaque_t) + 4 + fh_len +
-		 8 + uid.len + 8 + gid.len;
+	/* data server entry: deviceid + efficiency + stateid + fh list +
+	 * user + group + flags + stats_collect_hint
+	 */
+	ds_len = 16 + 4 + 4 + sizeof(stateid_opaque_t) + 4 + fh_len +
+		 4 + xdr_align_size(uid.len) +
+		 4 + xdr_align_size(gid.len) +
+		 4 + 4;
 
+	/* mirror: ds_count + ds */
 	mirror_len = 4 + ds_len;
 
-	/* The layout segment */
-	len = 20 + mirror_len;
+	/* stripe_unit + mirror_count + mirror */
+	len = 12 + mirror_len;
 
 	p = xdr_reserve_space(xdr, sizeof(__be32) + len);
 	if (!p)


