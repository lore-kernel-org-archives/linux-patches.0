Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20352231A37;
	Mon, 10 Mar 2025 17:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626524; cv=none; b=NocwPhmOLUeWpuvzeaibMNqf913NFdXhjnsXMfG3J0yLGlD5zwJI1Vc0f1kz0WR+moifo6dGpWxZ3Q2y8BP5wO/2RRX2LcmqsFNTfe1kaYlPCqFkRwp7lxzjj2XX0ELTWeqftsZ+2OhP2+jRUHxcYIIXA9WIdQSTFBmf+fcXDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626524; c=relaxed/simple;
	bh=dm1+6peYKhdDJ61SrGk5sjpX16gd6MEYSEjgK9wAxMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvPf+TSoFPWoZmHTVYVvLBGtI8EmvgyFCHhn/lyji1ONqB5WZLFISIa/w1QsAWEJtfdebVcRKN9gBV/qILUkpZyP2scI1EShiAIcvC/h5L1l5RpTS8IUDJX4v0ugLYf86SNMg7xWn6kKtN/q9DABMKk79wnwNcN69mhYkUky6xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmEkKE+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmEkKE+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A506C4CEE5;
	Mon, 10 Mar 2025 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626523;
	bh=dm1+6peYKhdDJ61SrGk5sjpX16gd6MEYSEjgK9wAxMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmEkKE+z42Ve6L3m5ibly60Z9IGRQeVlmTa9M9P33Rr3kzbZ4uhqyBCUtxk0h51fK
	 GVu9btn4kBJsNoyVGBezJUq8IipONGnDZdFCIXcQTIKyLEDRQ/sD+XGb+Ke5+NbAcd
	 dreiZkLljAaCeuT+SWb2vb/8UJIBXCZp+QL25zcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.13 021/207] ksmbd: fix out-of-bounds in parse_sec_desc()
Date: Mon, 10 Mar 2025 18:03:34 +0100
Message-ID: <20250310170448.612373422@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


