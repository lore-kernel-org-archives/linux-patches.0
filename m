Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00F543CEE4;
	Tue, 21 Jul 2026 21:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669958; cv=none; b=fbJoz7107hjvMQzhw48oKlxXUKCHKiQywNmQfKBBrDgvt5lr9vlh5zPDTK9Ff0EJXFgpTub49MyV1KQLhmakraO5CeA2G1VGPMMymgaqIS4M6oivs/XlB/Xm7tsYbQlzxsQAOW3QwjrfnVpav73Tub+Up+S1kn23+1biVKYUwpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669958; c=relaxed/simple;
	bh=Z7fCe3lvfSiaFnaj1FXTMnestHXhAjuXx7k1/9P2HFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRS/ovroAlY2HcbBgObwZkxJFkNVht+UM9duVnoZCyQL8Nb5gls4CJoEwRaWMNNanY2PqTZwQHz0txM/fxlAQG97UWrX/NY84XZzoOJ46kA4iS+Mqhh+7j5SZ4P9Wj6JG2TBJhYhp8IW1Dlu3waGUiww77u3ixSwB1itzjyJeZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVmvDdBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVmvDdBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7831F00A3E;
	Tue, 21 Jul 2026 21:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669957;
	bh=l++fg4s+UZie72PBTMPFJGKzx5+P9MN8A2CgJ0RrtUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVmvDdBnxTO6sR1U47QckQplVOvz2AQzhAS1mgpxTzrHcgIzE5yyYqOK/hV7vzjcx
	 O/kq8xmy+501oT5vlTc0IDOvNAKRcwdzWnRHbtKUstEr+47MO3PVFPZ1DMth5XdwiA
	 MPnt9JbQktlqc5aMy+WvK2rbpBBpAKEH11J46+Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0708/1067] cifs: validate DFS referral string offsets
Date: Tue, 21 Jul 2026 17:21:49 +0200
Message-ID: <20260721152440.428729003@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 049a14677c9106..8ca5143c34a195 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -981,6 +981,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
 
 		/* copy DfsPath */
+		if (le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
 		temp = (char *)ref + le16_to_cpu(ref->DfsPathOffset);
 		max_len = data_end - temp;
 		node->path_name = cifs_strndup_from_utf16(temp, max_len,
@@ -991,6 +995,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
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



