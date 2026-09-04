Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC8E30C366;
	Fri,  4 Sep 2026 06:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502121; cv=none; b=rdyNIWgzv5Hj6w+R/Gf3OjOA0bKd/2LlcJKtNpX7JoOvv68M1FeHHPQiJV4WlMkzQZkbpWYP67zyqYFYbyxmhhQLouWgOAp+1hBCDM9NMCw9ZIwqEjxjzcEN7d6ECyT9iz/EwT74o8T3dtjwHYMmMVVBExUO61gljCCqgQkox0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502121; c=relaxed/simple;
	bh=M4tM2nGFp6UcPzKutTQGDu+RtCfmHvuSAIQRurB1MxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwQ5SqdaADKruWuxWazZ2ZBTv/C3mQxXgC8WL/pm9obuFQtMUZ2M3nbdB1u1pkJy3Ej++NI+DO2vnxdiQOu9ZkZ1xF8chvWDIErRJY4L8ifgxxdFY3FXl8SrYx0out/qgvgedV9mZUpf6o3Yh0ZjXO3g2RMG7dRcUTMtBIeGzr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnLsJLnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnLsJLnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31ECF1F00A3D;
	Fri,  4 Sep 2026 06:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502119;
	bh=ywaKnVVWTiTMt8olKp5P3OwCsIBH34q+jMVyYwzcRp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnLsJLnhs8yERYDDKPW+aLSok/iebXEjkyfbuxZBvGO/xMFpAwMNV3d388vTsTP1t
	 0fDsaMWsfxmI7hjvbWitFCGb1tJy835a3vjXJ9bKOVuaCf1FjlZC1uCHyI5lq3l5Sx
	 AqTcU4Z6hG4uYvCMedzZdgNFk5bj/MbeTrLse07M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 097/403] nfsd: fix XDR length calculation in nfsd4_ff_encode_layoutget
Date: Fri,  4 Sep 2026 06:58:20 +0200
Message-ID: <20260904045737.040434721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


