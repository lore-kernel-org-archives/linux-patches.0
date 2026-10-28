Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210604;
	b=tzSeVfSrBwRVDIwHAv/vXfLzZv62WswvMq3q2PfL6pXA7ZxqTGlFpRIaN3Haaod+2gOv
	 49VrdR4mT/DqAnwKohyVNleY4n6e/Kj/ImP/KFxo+JwdPAh4r8M242Srn6Hr+PFwd7XC+
	 btvYlXnxdtu8nCvgd5xWnyFPZQpHZs1kk/kGNjv91+hSZiIakLF4As0FlvsSn9JgRrrpx
	 8mfw3rJiD3OMK1ivI4EqrgPnjp7AqN8WiaC6WUTbA2ZdeQtlKtSD/AXXYl9GCt28WQ5Fd
	 Me+/nopUKqzjgRo7YcY6mFkD6YMxWpLyzxJ8PBB5aZflRbmeTQLgv4A20Smcb0+HyUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WSO0qaOIFpzEp8n1k8P/y3Xw75Gs7kqkZ6OJ7RnD3lU=;
	b=0KZlJkHMlsq2o7mR910syhXwwXJLXi0Ug3KmtTtDKlvPyhvsFGn7jmzXdh2Oc84wEmHw
	 Hc0v9yX+bv4sG2w/3snGbFxxCIKH1eOulw3QLBTLIQoWDmmsNuH5rderwbZsd0Vam+RiL
	 dlwsX3dhCvIGSl110XLZF4zhdK9zdXusuOrU7kIwVPuHA//F0Vaa21cQRBdDsiCa/GHIw
	 p4IX2n6Rpc/Ja/PvvEsHe6AqPtkQokTR1+as1UPOf2mwzVzOeiy8ti52ybqSM6nggd0u6
	 18HPXgvrsduTi4n5Xrj0s+MlbED6n0H/xxPkDYgkt6ctz7zVnMbBNS+RXozjNDNq6SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1NB2BJvl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DCA606A31C;
	Wed, 28 Oct 2026 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1NB2BJvl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2411F01825;
	Wed, 28 Oct 2026 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210603;
	bh=WSO0qaOIFpzEp8n1k8P/y3Xw75Gs7kqkZ6OJ7RnD3lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1NB2BJvl1kGa/0jYOBYLrD+0/OJEix09uzsmptpeBHcemLWTtbZAxKmpzhfO957Zd
	 f/sAsABiFjCpqxoVbI+uVZ6zwekwgAAE5p88xMQ9Bir0lbNS+rv/J1AZec0JISMdSd
	 DQzlu6kOyEt1jFPLAA7X3tVmN3ypUIGbpRh+aHnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/571] smb: client: fix potential OOB read in smb3_enum_snapshots()
Date: Wed, 28 Oct 2026 17:53:06 +0100
Message-ID: <20261028170008.954219883@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 4775c3b7a597907e0b97556c7986fda238a377ae ]

If snapshot_array_size is smaller than GMT_TOKEN_SIZE,
smb3_enum_snapshots() sets ret_data_len to
sizeof(struct smb_snapshot_array) without verifying the actual length
of the server's reply.

Because SMB2_ioctl() places no lower bound on the server-supplied
OutputCount and allocates retbuf to exactly that length, a short reply
results in ret_data_len exceeding the size of retbuf. The subsequent
copy_to_user() then reads past the end of retbuf, leaking adjacent slab
memory to userspace.  The subsequent clamp check is ineffective as it
only reduces ret_data_len.

Fix this by rejecting replies shorter than
sizeof(struct smb_snapshot_array) with -EIO. Note that the bound is set
to the 12-byte struct size rather than the 16-byte
MIN_SNAPSHOT_ARRAY_SIZE defined in MS-SMB2 3.3.5.15.1, because 12 bytes
is exactly what copy_to_user() attempts to read.

Fixes: e02789a53d71 ("smb3: enumerating snapshots was leaving part of the data off end")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 3aaa45375d8ba..42b5e5264fb6e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2271,8 +2271,14 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 		 * and retry the ioctl again with larger array size sufficient
 		 * to hold all of the snapshot GMT tokens on the second try.
 		 */
-		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE)
+		if (snapshot_in.snapshot_array_size < GMT_TOKEN_SIZE) {
+			if (ret_data_len < sizeof(struct smb_snapshot_array)) {
+				rc = -EIO;
+				kfree(retbuf);
+				return rc;
+			}
 			ret_data_len = sizeof(struct smb_snapshot_array);
+		}
 
 		/*
 		 * We return struct SRV_SNAPSHOT_ARRAY, followed by
-- 
2.53.0



