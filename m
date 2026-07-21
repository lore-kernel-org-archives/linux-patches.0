Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03473B95F9;
	Tue, 21 Jul 2026 20:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667076; cv=none; b=OawwBURR8VbDNwL49DY6L2O/tBCBHqdiyVus+itzVNl937OBRXxgiWZs12Kv3lRofAAqr7PhgziQ/nYIbjl2Hjzp4StFeDynXX4zcc/NPiSB2nqAqqQVuUFr4MWs8Zc3ez0qmf7TU+CfB4g4HBiAGMrhKXhKTfEV5mdx+lOrn9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667076; c=relaxed/simple;
	bh=CkqC3jETmp47Sm0IS5Nv84DTGvHHs+rbOdv7pdRXrCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/2CnSGAXkKkqfOxzujBUSNJOFYh97nwCV3cZx0hJgDWKBwk6qHSds8/UjqFM5cb2IUVTTmhlhoHRXr8k5Hj1InMWdwnPK9hl+bMBfxRXge2Ucc7DTvHzA8+4kesjBsLS4Em2r/9R6jiedCh44N7CPN+Da1Q6903/T1xrL1EE0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZuGS4wrz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZuGS4wrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327DF1F00A3A;
	Tue, 21 Jul 2026 20:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667075;
	bh=Ti5NudFfGLfecRiZ9i29YswiSoW49ge3xX2GacaGwAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuGS4wrzkG2lobGd0w4hnWpQug068TLOZU7QIxvPmxeVjwT4NGZAgIqtgnvDNLs+K
	 z+4xbO1UVnRD9XqwY7CRoQ6g2H6HZX6LUAtM0lkoMy4xn+DUPBXGYVrGvgFWGhsVgU
	 1y3o6XRw0ahmg9Jq8375NzJkAo+uCX9pDiL/I5vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0880/1266] cifs: validate DFS referral string offsets
Date: Tue, 21 Jul 2026 17:21:57 +0200
Message-ID: <20260721152501.541775183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 027a84ac6b50c12ef767c15abfc58aa865820e9e ]

parse_dfs_referrals() validates that the response header and referral
array fit in the received buffer, but each referral also contains string
offsets supplied by the server.

Those offsets are used to compute the DfsPath and NetworkAddress string
pointers without checking whether they still point inside the response
buffer. A malformed referral can therefore make the computed pointer
exceed the end of the buffer. The resulting negative max_len is then
passed to cifs_strndup_from_utf16(), and the non-Unicode path forwards it
to kstrndup() as a size_t, allowing strnlen() to read out of bounds.

Validate each string offset before deriving the string pointer.

Fixes: 4ecce920e13a ("CIFS: move DFS response parsing out of SMB1 code")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/misc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index a31b4e912719cc..46ca8f326c9813 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1039,6 +1039,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
 
 		/* copy DfsPath */
+		if (le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
 		temp = (char *)ref + le16_to_cpu(ref->DfsPathOffset);
 		max_len = data_end - temp;
 		node->path_name = cifs_strndup_from_utf16(temp, max_len,
@@ -1049,6 +1053,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		}
 
 		/* copy link target UNC */
+		if (le16_to_cpu(ref->NetworkAddressOffset) > data_end - (char *)ref) {
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
 		temp = (char *)ref + le16_to_cpu(ref->NetworkAddressOffset);
 		max_len = data_end - temp;
 		node->node_name = cifs_strndup_from_utf16(temp, max_len,
-- 
2.53.0



