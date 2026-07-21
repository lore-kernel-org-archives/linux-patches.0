Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48DC470123;
	Tue, 21 Jul 2026 19:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663364; cv=none; b=RfE5OUWhJ1dEefvatgKkWm483qytKOVgJA65nuxfGFO+Mx9kE9cR/JOGwwzrZSiIKT9PA+hgFojTKAyD9jfO6ULYRAqSmgcjaVmrN3p8uAIbC/+tyK0t9D6gVTu6AeGrcSY4AgqNT/pdIduXFPBdrkOPT2whJxPdjtKVVG+Xj0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663364; c=relaxed/simple;
	bh=9CeRqqVNYKGUB5LH9eOJ4F9okHjnj/SrLlOzt68UuHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBBlYoUlw1sgb2hm6dRM2qUVQ6f12y7DHGOCOM1V80bqhxlujIDX5LTXNn+SxtdqR//qE8APeTXKGvaeQIUgnMuPtKA+4DUfeHg7TxbAym4fsNknEgCgF0EuYrLLYo/gthMkYVQI7bbEPVh3CNlv8fm1qtFATCkEDZzREqfhPQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1WOvya/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1WOvya/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460E51F00A3A;
	Tue, 21 Jul 2026 19:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663363;
	bh=fqnsa8ZMOgjvKRWny8EohcviF5DbdWm3bP4nvuSX4uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1WOvya/6C59ah0/ivPkdEEFMXtGyJwd5uwz/q3n2Mywf308MwtQvcBUjA+NQ9q59
	 ueLqtylYfNfba7r54I4shxelfv2TsnUayKeSzk+aolabhs3bm2Bkd8J1LdEWNKcdhW
	 SImng/JZkXArAz8s09H/EHtknCNx02EvJx8hIiuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0796/1276] cifs: validate DFS referral string offsets
Date: Tue, 21 Jul 2026 17:20:39 +0200
Message-ID: <20260721152503.885815734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 6abfa22f4c176e..713b95a2361145 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1029,6 +1029,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
 
 		/* copy DfsPath */
+		if (le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+			rc = -EINVAL;
+			goto parse_DFS_referrals_exit;
+		}
 		temp = (char *)ref + le16_to_cpu(ref->DfsPathOffset);
 		max_len = data_end - temp;
 		node->path_name = cifs_strndup_from_utf16(temp, max_len,
@@ -1039,6 +1043,10 @@ parse_dfs_referrals(struct get_dfs_referral_rsp *rsp, u32 rsp_size,
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



