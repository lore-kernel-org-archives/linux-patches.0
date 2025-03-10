Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705B51B3927;
	Mon, 10 Mar 2025 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627396; cv=none; b=QWB78+S/R4CbXUmJqidbO4KuRlU64nkab+8NX9FBoRxznAW8uF8EFsaiSPjH75xIA5rHCw3+0UYbUcxNGbJSEm/kcVxfzgmxlKONfXrM0X8frbNbObDSVcdFmz409dKn5H/cS0s+3mEc0yAgn5b1I4AuYd/2EXNIxfFsuJRxmkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627396; c=relaxed/simple;
	bh=/P/1VpM3haVkTguLFpVYpr98QeGLGRi6ruKlHyBAhlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E15oqsxd7YK87FL1mNmNKlLNJS+NZSqlMQMl5Z3RGauVWiv7RU84Lb16ow955zkm+nfEEQ4Jks2duwg94hybH0/QGH5PWbccvq7MkxXZBWKKQIvErllghL/jDmuVconL1BxB9ZHDTFqYUIfu6TUXNf/lP6b5IENbnQ1ilCr2UfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeWmtAbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeWmtAbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4E8C4CEE5;
	Mon, 10 Mar 2025 17:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627396;
	bh=/P/1VpM3haVkTguLFpVYpr98QeGLGRi6ruKlHyBAhlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BeWmtAbbyawZOwIbRIq05azKKeGp3xebuuJXvqXGeIgsm9rO7hEu7M7JnS4PslZlg
	 hw1kPUe0E/mqrY1Ds6Fm0bUffJbg+Ywb9gjhH0p/qSZOHkGKPNtnIRCU1cqqUMzImu
	 bM0VhwOkrHz0bc2y9XNKoEnaRuU9+Di+wTP+wroQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 084/269] ksmbd: fix out-of-bounds in parse_sec_desc()
Date: Mon, 10 Mar 2025 18:03:57 +0100
Message-ID: <20250310170501.067765881@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit d6e13e19063db24f94b690159d0633aaf72a0f03 upstream.

If osidoffset, gsidoffset and dacloffset could be greater than smb_ntsd
struct size. If it is smaller, It could cause slab-out-of-bounds.
And when validating sid, It need to check it included subauth array size.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smbacl.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -807,6 +807,13 @@ static int parse_sid(struct smb_sid *psi
 		return -EINVAL;
 	}
 
+	if (!psid->num_subauth)
+		return 0;
+
+	if (psid->num_subauth > SID_MAX_SUB_AUTHORITIES ||
+	    end_of_acl < (char *)psid + 8 + sizeof(__le32) * psid->num_subauth)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -848,6 +855,9 @@ int parse_sec_desc(struct mnt_idmap *idm
 	pntsd->type = cpu_to_le16(DACL_PRESENT);
 
 	if (pntsd->osidoffset) {
+		if (le32_to_cpu(pntsd->osidoffset) < sizeof(struct smb_ntsd))
+			return -EINVAL;
+
 		rc = parse_sid(owner_sid_ptr, end_of_acl);
 		if (rc) {
 			pr_err("%s: Error %d parsing Owner SID\n", __func__, rc);
@@ -863,6 +873,9 @@ int parse_sec_desc(struct mnt_idmap *idm
 	}
 
 	if (pntsd->gsidoffset) {
+		if (le32_to_cpu(pntsd->gsidoffset) < sizeof(struct smb_ntsd))
+			return -EINVAL;
+
 		rc = parse_sid(group_sid_ptr, end_of_acl);
 		if (rc) {
 			pr_err("%s: Error %d mapping Owner SID to gid\n",
@@ -884,6 +897,9 @@ int parse_sec_desc(struct mnt_idmap *idm
 		pntsd->type |= cpu_to_le16(DACL_PROTECTED);
 
 	if (dacloffset) {
+		if (dacloffset < sizeof(struct smb_ntsd))
+			return -EINVAL;
+
 		parse_dacl(idmap, dacl_ptr, end_of_acl,
 			   owner_sid_ptr, group_sid_ptr, fattr);
 	}


