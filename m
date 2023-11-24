Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5CD39FF7;
	Fri, 24 Nov 2023 18:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjR4RmCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6767C433C7;
	Fri, 24 Nov 2023 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849873;
	bh=4KZcLpQMl8j6n1oLVszC1fgTgeeFgZZ7Nb4/Zy9Q6ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjR4RmCGRptJf2gVc150cni/H5SX0MmAlrzKnqd6ub0NbyBuIUISJQecFwBnYEcQU
	 sLjxdx6LCvzHcKoXR9sPitFsPWPwvPG0czKa6Q6j/kjhgWLtiT0BnQeuAjQl1HK/pN
	 dOZX1X/Mhv1GZHrYndO3yxX8Y7LZ+1/vTKl8g6+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	zdi-disclosures@trendmicro.com
Subject: [PATCH 6.6 320/530] ksmbd: fix slab out of bounds write in smb_inherit_dacl()
Date: Fri, 24 Nov 2023 17:48:06 +0000
Message-ID: <20231124172037.776865478@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit eebff19acaa35820cb09ce2ccb3d21bee2156ffb upstream.

slab out-of-bounds write is caused by that offsets is bigger than pntsd
allocation size. This patch add the check to validate 3 offsets using
allocation size.

Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-22271
Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1107,6 +1107,7 @@ pass:
 		struct smb_acl *pdacl;
 		struct smb_sid *powner_sid = NULL, *pgroup_sid = NULL;
 		int powner_sid_size = 0, pgroup_sid_size = 0, pntsd_size;
+		int pntsd_alloc_size;
 
 		if (parent_pntsd->osidoffset) {
 			powner_sid = (struct smb_sid *)((char *)parent_pntsd +
@@ -1119,9 +1120,10 @@ pass:
 			pgroup_sid_size = 1 + 1 + 6 + (pgroup_sid->num_subauth * 4);
 		}
 
-		pntsd = kzalloc(sizeof(struct smb_ntsd) + powner_sid_size +
-				pgroup_sid_size + sizeof(struct smb_acl) +
-				nt_size, GFP_KERNEL);
+		pntsd_alloc_size = sizeof(struct smb_ntsd) + powner_sid_size +
+			pgroup_sid_size + sizeof(struct smb_acl) + nt_size;
+
+		pntsd = kzalloc(pntsd_alloc_size, GFP_KERNEL);
 		if (!pntsd) {
 			rc = -ENOMEM;
 			goto free_aces_base;
@@ -1136,6 +1138,27 @@ pass:
 		pntsd->gsidoffset = parent_pntsd->gsidoffset;
 		pntsd->dacloffset = parent_pntsd->dacloffset;
 
+		if ((u64)le32_to_cpu(pntsd->osidoffset) + powner_sid_size >
+		    pntsd_alloc_size) {
+			rc = -EINVAL;
+			kfree(pntsd);
+			goto free_aces_base;
+		}
+
+		if ((u64)le32_to_cpu(pntsd->gsidoffset) + pgroup_sid_size >
+		    pntsd_alloc_size) {
+			rc = -EINVAL;
+			kfree(pntsd);
+			goto free_aces_base;
+		}
+
+		if ((u64)le32_to_cpu(pntsd->dacloffset) + sizeof(struct smb_acl) + nt_size >
+		    pntsd_alloc_size) {
+			rc = -EINVAL;
+			kfree(pntsd);
+			goto free_aces_base;
+		}
+
 		if (pntsd->osidoffset) {
 			struct smb_sid *owner_sid = (struct smb_sid *)((char *)pntsd +
 					le32_to_cpu(pntsd->osidoffset));


