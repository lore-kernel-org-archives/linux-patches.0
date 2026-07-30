Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB56432E65;
	Thu, 30 Jul 2026 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423900; cv=none; b=ZH58E4XVk/vEGdxLRi+qgO5Co+411Po85WI/MQl/TdfmyK0IzvHuvuGbCatUGyGHS8Q/BzZEO6o95iVZInaHkKNmrBj7vOV8CUHttx2yVZFuYDMlVbF7Rnm5EhJyDFHiU8biKDsmvDw6EV+XW5C2rfG55IF7OIbdm3M+d26vdzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423900; c=relaxed/simple;
	bh=TY7ZMKNwCn+q+SqqSxq3bQHuSMVuUEeI1aP93b8Ax9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRd6+hre+3olVQEa2Y4kawuOQIYz6/W0jK45LxeuSl/UPQiKFawTRZ9BaZXW9ce+0a9nAuoF461pyuqgwPWAHdp7n5R1xpoJHV1CPwWgGe8Kl3YqA7O7F52ZNGRKtEAowCsff3ItTJewi+YxYXDIPY9sCjbDL4VCK8Ha23wpFzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpMCr2eg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpMCr2eg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653F91F00A3D;
	Thu, 30 Jul 2026 15:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423899;
	bh=0Qlng6xZG0efga/BV7Q47V/T3oWLO96vDu2G03G56FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wpMCr2eg/SVfoHpZiDB4sVe54EB2KJfUR74Hao12ARGlYa+5GL7BdBefNxUg/rNvt
	 IdvQgGTBYT5FGtgKWUj567qHZJlJr6clS5bbyPI348PysQGJT3AzhniT5pCNU0i8bt
	 ja7m94Rp1Ek7tygbjYBXjHWhZYCyUq+H11yOyteg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Yichong Chen <chenyichong@uniontech.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/675] smb: client: validate DFS referral PathConsumed
Date: Thu, 30 Jul 2026 16:08:54 +0200
Message-ID: <20260730141449.479123331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit f6f5ee2aa33b350c671721b965251c42cebb962e ]

parse_dfs_referrals() validates that the response contains the fixed
referral entry array and, on for-next, the per-referral string offsets.
However, the response also contains a PathConsumed value that is later
used for DFS path parsing.

If a malformed response provides a PathConsumed value larger than the
search name, later DFS parsing can advance beyond the end of the path.

Validate PathConsumed against the search name length before storing it in
the parsed referral.

Fixes: 4ecce920e13a ("CIFS: move DFS response parsing out of SMB1 code")
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/misc.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index f378437113129a..d9771d224527d7 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -957,6 +957,8 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 	int i, rc = 0;
 	char *data_end;
 	struct dfs_referral_level_3 *ref;
+	unsigned int path_consumed;
+	size_t search_name_len;
 
 	if (rsp_size < sizeof(*rsp)) {
 		cifs_dbg(VFS | ONCE,
@@ -1004,6 +1006,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		rc = -ENOMEM;
 		goto parse_DFS_referrals_exit;
 	}
+	search_name_len = strlen(searchName);
 
 	/* collect necessary data from referrals */
 	for (i = 0; i < *num_of_nodes; i++) {
@@ -1012,21 +1015,34 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		struct dfs_info3_param *node = (*target_nodes)+i;
 
 		node->flags = le32_to_cpu(rsp->DFSFlags);
+		path_consumed = le16_to_cpu(rsp->PathConsumed);
 		if (is_unicode) {
-			__le16 *tmp = kmalloc(strlen(searchName)*2 + 2,
-						GFP_KERNEL);
-			if (tmp == NULL) {
+			size_t search_name_utf16_len = search_name_len * 2 + 2;
+			__le16 *tmp;
+
+			if (path_consumed > search_name_utf16_len) {
+				rc = -EINVAL;
+				goto parse_DFS_referrals_exit;
+			}
+
+			tmp = kmalloc(search_name_utf16_len, GFP_KERNEL);
+			if (!tmp) {
 				rc = -ENOMEM;
 				goto parse_DFS_referrals_exit;
 			}
-			cifsConvertToUTF16((__le16 *) tmp, searchName,
+			cifsConvertToUTF16((__le16 *)tmp, searchName,
 					   PATH_MAX, nls_codepage, remap);
-			node->path_consumed = cifs_utf16_bytes(tmp,
-					le16_to_cpu(rsp->PathConsumed),
-					nls_codepage);
+			node->path_consumed = cifs_utf16_bytes(tmp, path_consumed,
+							       nls_codepage);
 			kfree(tmp);
-		} else
-			node->path_consumed = le16_to_cpu(rsp->PathConsumed);
+		} else {
+			if (path_consumed > search_name_len) {
+				rc = -EINVAL;
+				goto parse_DFS_referrals_exit;
+			}
+
+			node->path_consumed = path_consumed;
+		}
 
 		node->server_type = le16_to_cpu(ref->ServerType);
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
-- 
2.53.0



