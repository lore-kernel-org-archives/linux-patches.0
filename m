Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72F537C92C;
	Thu, 30 Jul 2026 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425724; cv=none; b=YmTssezMy9QdDIzIhk4rcGRB14yp/aZ/eZTAfNt3PddvLMOCfp+2SkmhrQViS8IHeMlJ/4Wb7ehWyAKC3GkqbHgLdY/+EsCGBspLE7wJilL+YpG5mwGkj5XJl4Uj4owzACVJHWDIYknq8BPpBgYj9HTP7ohjrgE3Oie4WX6H5JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425724; c=relaxed/simple;
	bh=meFGs6zuBGuupQKSVcXC2TIKO12bpm0+8b08M3xOMqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeBF3uxhAPBRdQtLReHGZ8WsyN4/jqDrj59eCMalGqU2N61BjphZXIEGvfnl4JNt8UhMTAzr0rI3AYLD2HT7kfpgF8tMhJY98nqfuP4S5qrePzlv8F9mdQ5HY0QVNFpWJcEPflt3G8WywowCeBUu7fSBtPRFx8Ubx8xrwQPYDfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/j4nZ0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/j4nZ0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6E01F000E9;
	Thu, 30 Jul 2026 15:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425723;
	bh=/3R91Y18cR1e5LqKdNULxo64vsuQTDzXblUbiHDFZSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/j4nZ0kp6nTfbR1ayxD0Vx6SBiYUhpoXwZ4G2aTxGAK6CDRs4vxvaED3b3HEgMFC
	 ka28ro80Uhc7uaRG6kCLqkZz7zDb7UBXlHfDbg8FBuAf6Z6Cn8KJzlO1gp3zXCwXXQ
	 NXS0cWmshsrIv83wunb330DgxjN7K9eA2nteZwdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Yichong Chen <chenyichong@uniontech.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/602] smb: client: validate DFS referral PathConsumed
Date: Thu, 30 Jul 2026 16:09:20 +0200
Message-ID: <20260730141439.501236455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 713b95a2361145..ce8f3fdffc3bda 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -954,6 +954,8 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 	int i, rc = 0;
 	char *data_end;
 	struct dfs_referral_level_3 *ref;
+	unsigned int path_consumed;
+	size_t search_name_len;
 
 	if (rsp_size < sizeof(*rsp)) {
 		cifs_dbg(VFS | ONCE,
@@ -1001,6 +1003,7 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		rc = -ENOMEM;
 		goto parse_DFS_referrals_exit;
 	}
+	search_name_len = strlen(searchName);
 
 	/* collect necessary data from referrals */
 	for (i = 0; i < *num_of_nodes; i++) {
@@ -1009,21 +1012,34 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
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



