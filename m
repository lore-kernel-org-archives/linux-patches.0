Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208243;
	b=1xm6/DZtQ+/Ypu/411JcK+WlEcF8RO6fmbArC2CkAcEXpR5e5s8btzuiX8E08TsnLWHG
	 TAAl8oJ6EITmFFaW+MKJRqvvzHl9hUw7HmyLWYDffgS9ptjOyjrYzhsM+tTwdO8bYIC+T
	 3mHm26ezgk3Vby67eUnqNPyZth1RappVeFFcebF+fLyPpX1K/Gz1i428DBGObspFM9Wtp
	 pcANtQ5tUS6Hx6QM3JMzjlRNN9auJyyS2K7jT1YAik+V9VZ8Oa9A9vIFySj8nLL85SKqR
	 53QJ/HAARugWukvK8zPMbxP6sBvD1O3hIzFYOJpLRcDHLm0p0Y7oc7jqEsTfbzgNrJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jCWgyN7Zs/5Of20kVc7de8LfOrCuvkGXzbrZxQAjKpQ=;
	b=taYzvDLsJaIHSYvGk6IZfSA1N1GR9B05KQCX6hWjn6N0qO3FAdvreynHAF5dokJ9T++E
	 a1x42aeD6yI4Y3OCzVUjd+LButSQz/uJx5DiHJ/0wFJdC+zD4B+n2dN6iABFRzPTVxwVH
	 wOddqoaqLZJb50AldixaHuo4f1LBuZuipww+fjieCKVncTMWo6jzVLgrFtpblaSq2nyq5
	 VDCROA3vu0iKbngMYwyyF53iiMKSmTNK9w9p9+zj4Sy2XD6bk+E4DI2PGPLdsL5+VG1Lw
	 ZwOcLoKRiogzOvVzDxUVALMt+tC4mE0c/Dn66DrjeL0cSQ3MJvDaEUqSuN68WfUKn9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=be4RIUEn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7444A606A31C;
	Wed, 28 Oct 2026 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=be4RIUEn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11111F01825;
	Wed, 28 Oct 2026 17:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208243;
	bh=jCWgyN7Zs/5Of20kVc7de8LfOrCuvkGXzbrZxQAjKpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=be4RIUEnAySSHYgHeUpZdiLAl/IFO+GBTgSoOGuDcttkics0r3DwZOmrs92TMUN6v
	 Fk4JzhILynXqVG9UxySGTwfcdNDegXnhiruz9BeAbnxclN4fP+v5ryyd1zZLDm1/t7
	 xYpugVhiZ2vJ39IM3QpZ6ZrxbICKsM0UrAe8+9V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Yongchao <grayhat@foxmail.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 008/516] smb: client: fix OOB read/write from unvalidated DataOffset in coalesce_t2()
Date: Wed, 28 Oct 2026 17:52:40 +0100
Message-ID: <20261028170003.725292144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 6343c1da561962688f203362d80d6a3bfa39fa1b ]

coalesce_t2() computes data pointers directly from server-supplied
DataOffset fields with no validation against buffer bounds:

  data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
                     get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
  data_area_of_src = (char *)&pSMBs->hdr.Protocol +
                     get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
  data_area_of_tgt += total_in_tgt;
  ...
  memcpy(data_area_of_tgt, data_area_of_src, total_in_src);

A small DataOffset can push a pointer below the actual byte area,
overwriting header fields; a large one can push it past the buffer
end, causing out-of-bounds heap reads (source) or writes (target).
The BCC overflow guard does not prevent this: BCC reflects how much
data is present, while DataOffset controls where in the buffer it
starts.

The "validate target area" comment present since the function was
first written in 2005 was a placeholder that was never implemented.

Add lower- and upper-bound checks for both data pointers before the
memcpy, and before any target header fields are modified.

Fixes: e4eb295d38b5 ("[PATCH] cifs: Handle multiple response transact2 part 1 of 2")
Cc: stable@vger.kernel.org
Reported-by: Shen Yongchao <grayhat@foxmail.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ transplanted the bounds validation to coalesce_t2() in smb1ops.c due to code relocation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb1ops.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 80287c26cfac0..3b5427b17ff51 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -318,12 +318,31 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr)
 	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
 				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
 
-	/* validate target area */
 	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
 				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
 
 	data_area_of_tgt += total_in_tgt;
 
+	/*
+	 * DataOffset fields are server-supplied and not validated against
+	 * buffer bounds; check both data pointers before mutating the
+	 * target header.
+	 */
+	if (data_area_of_tgt < (char *)target_hdr +
+				sizeof(struct smb_t2_rsp) + sizeof(__le16) ||
+	    data_area_of_tgt + total_in_src >
+	    (char *)target_hdr + CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
+		cifs_dbg(VFS, "%s: target data area out of bounds\n", __func__);
+		return -EPROTO;
+	}
+	if (data_area_of_src < second_buf +
+				sizeof(struct smb_t2_rsp) + sizeof(__le16) ||
+	    data_area_of_src + total_in_src >
+	    second_buf + smbCalcSize((struct smb_hdr *)second_buf)) {
+		cifs_dbg(VFS, "%s: secondary data area out of bounds\n", __func__);
+		return -EPROTO;
+	}
+
 	total_in_tgt += total_in_src;
 	/* is the result too big for the field? */
 	if (total_in_tgt > USHRT_MAX) {
-- 
2.53.0



