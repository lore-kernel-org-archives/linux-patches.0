Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774211;
	b=1sdVxjdaMtoCRyS9c1BQ4a2aHyW5iTZKxUTrkSzo2Xe9CktjNnN58xpZCMefrrw2c0Wx
	 8hUckRpX3r/s3MxNDvV1/gTvn3yKp/sN4V5Mz/5Sgahty7gqOPMMTXlq2Pbaks0r+7ppL
	 hmEtkGRkQk6Wt0O+qlYt+LhFUZ7C75CRdCETqk90R63ij+u2c1MPNzWOGMSWXJU35c96P
	 qyn05wA+M88RpXfcl2DlVW/YtuFMCXqSmL79jC9/fbHkGEghvZAht16MACfY9gWt9kz2r
	 ulUzRb5BT7aVo9OOA/Nz6Yb+2wRKcdtpWmpd0KEETx+v7/+iOED83ESHDEGbt30tEhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+FzcQMrcIKpExeCmtP2F/PiT5N30vNmoLKTTFR5qRow=;
	b=33NZv5u5EFyLrF/PzWVKzPsBPnwe4rv619aBiPTsyOw0w7Nc0hGbIAAcwmnolpue1ETK
	 Hsj1r/SS+ZJHCa1NORJda9pYLxRuKSqru8hwQB0Ujhq/wGE+sxUew3VetOuf3Wj2EcrEX
	 PRaQ9QHHZSpYiRKEfbe3B0By2gHrUoFLO45qAZFYod7sje3lG7gFTIwQsMX2lfSXK3p+u
	 Lrg22mKEY6DNsPCsYCa6gW7FZKQtqDMSGw8KjOceWdcNhA7hC8EuYM+x5JNry8PGLBm0a
	 91ucdcrBaoEgXv5L77++2qOrD7tABtUjcMQ6jwciZ9bvMajMIOkKg/Jgsq9OiYZvr/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEU736n+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1AC606A324;
	Fri, 23 Oct 2026 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEU736n+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386091F01828;
	Fri, 23 Oct 2026 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774210;
	bh=+FzcQMrcIKpExeCmtP2F/PiT5N30vNmoLKTTFR5qRow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEU736n+byejb67+80kGls7cTsDwNECoZ/B7NN/l+XYuJ/nsvxEEQ+on5+qFfNFOR
	 PqqOAPo/cGYx6bj6VWWV+UulcwAyzLdxjRuDkZgqp0k3nfLhzzIOCsiQnBrFlvalhi
	 GgNTkaP5dcclTkNVtSxDs7LVjJfpZ9uOozYTLXRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.18 158/193] smb: client: fix heap overflow in cifs_do_set_acl()
Date: Fri, 23 Oct 2026 18:37:15 +0200
Message-ID: <20261023163717.947588520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

commit 1dac61e2c29d1a71784604b48cf3b1234a65ec29 upstream.

cifs_set_acl() validates ACL size using posix_acl_xattr_size():

        4 + (count * 8)  // 4-byte header + 8 bytes per ACE

cifs_do_set_acl() then calls posix_acl_to_cifs() to write the CIFS
wire format into the same buffer:

        6 + (count * 10)  // 6-byte header + 10 bytes per ACE

An ACL that passes the xattr-based check in cifs_set_acl() can
overflow the heap when posix_acl_to_cifs() writes the larger CIFS
format.

Validate the CIFS format size against the remaining buffer space and
USHRT_MAX before converting--data_count is __u16, so sizes above
USHRT_MAX truncate the on-wire packet length, causing the server to
apply a partial ACL.  Replace MaxDataCount = 1000 with
min(CIFSMaxBufSize, USHRT_MAX).

Fixes: dc1af4c4b4721 ("cifs: implement set acl method")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3502,6 +3502,7 @@ int cifs_do_set_acl(const unsigned int x
 	int rc = 0;
 	int bytes_returned = 0;
 	__u16 params, byte_count, data_count, param_offset, offset;
+	size_t cifs_acl_size, bytes_available;
 
 	cifs_dbg(FYI, "In SetPosixACL (Unix) for path %s\n", fileName);
 setAclRetry:
@@ -3520,8 +3521,7 @@ setAclRetry:
 	}
 	params = 6 + name_len;
 	pSMB->MaxParameterCount = cpu_to_le16(2);
-	/* BB find max SMB size from sess */
-	pSMB->MaxDataCount = cpu_to_le16(1000);
+	pSMB->MaxDataCount = cpu_to_le16(min_t(unsigned int, CIFSMaxBufSize, USHRT_MAX));
 	pSMB->MaxSetupCount = 0;
 	pSMB->Reserved = 0;
 	pSMB->Flags = 0;
@@ -3533,6 +3533,15 @@ setAclRetry:
 	parm_data = ((char *)pSMB) + sizeof(pSMB->hdr.smb_buf_length) + offset;
 	pSMB->ParameterOffset = cpu_to_le16(param_offset);
 
+	/* make sure we can fit the larger cifs_posix_aces in the buffer */
+	cifs_acl_size = sizeof(struct cifs_posix_acl) +
+		       (acl->a_count * sizeof(struct cifs_posix_ace));
+	bytes_available = (CIFSMaxBufSize + MAX_HEADER_SIZE(tcon->ses->server)) - offset;
+	if (cifs_acl_size > bytes_available || cifs_acl_size > USHRT_MAX) {
+		rc = -E2BIG;
+		goto setACLerrorExit;
+	}
+
 	/* convert to on the wire format for POSIX ACL */
 	data_count = posix_acl_to_cifs(parm_data, acl, acl_type);
 


