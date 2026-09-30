Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C00F502560;
	Wed, 30 Sep 2026 17:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788890; cv=none; b=QnJ9YYFLlAizpsX+5qMjOMdU1TDdbdb6mFkToH/nI4F/9H7vLQnUHUMIjEgyy7AOY+yRvGPBJmO3ySaW5D27uWkQVPoVEa5ekGICUi+GjT3W3ltrUW0BrBKEbnZiA23ssUKpW0Kj11M2xEFN2Up7vLJpbYLU4N3j1ozftgR2yZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788890; c=relaxed/simple;
	bh=nhFU0R2XXVGyfbiY2PEIeATa5U2bq7N33Jm5RvcJZXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WixsJILf0GFSuy0e2k679IBT3LGDPjIEiepQN0KFlVBKv3jl/XJdCOgJRk9PH1LLDrzEJnvgwS8E0mLqwyrq4bQ85Idal3qpUMovkAIYRZu1F/n9m/ZZgrpNKLOWJobYPWmLM896r9nAONGVUi7EVFCPN3FWavpGf27nBRzTQzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5VLVlsc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5VLVlsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA191F000FF;
	Wed, 30 Sep 2026 17:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788889;
	bh=BGsZUqj945PE2SfH35HipJiWGU/viqVMIjae5BIa7EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5VLVlscu7YJCmBjOwDjadPajkkgLLMxWB9+Iy3kRDFB5RjtHPWvvJTwwg+j7aZ5h
	 rme2u7KbfsDDcZWj2q78wmmikytSzA9OkQXasYE+v8Gv9rH2Ah5XX2WFtsjT6jmQs9
	 cNeA1FeTlgmpzpDpf3j+/uHlgTrzs3qij6WICsWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 284/877] smb: client: fix missing lower-bound check on DFS referral string offsets
Date: Wed, 30 Sep 2026 17:19:55 +0200
Message-ID: <20260930152420.843744836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

commit e83330c55edc0c3ac08aa6c95e49e4694c65523b upstream.

parse_dfs_referrals() checks that DfsPathOffset and NetworkAddressOffset
do not exceed the buffer end, but fails to check that they don't point
inside the referral header itself.

If a server provides an offset smaller than
sizeof(struct dfs_referral_level_3), the derived string pointer overlaps
with the struct fields, causing cifs_strndup_from_utf16() to interpret
header data as UTF-16 strings.

Fix this by enforcing that string offsets are at least sizeof(*ref).

Fixes: 4ecce920e13a ("CIFS: move DFS response parsing out of SMB1 code")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/misc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -1046,7 +1046,11 @@ parse_dfs_referrals(struct get_dfs_refer
 		node->ref_flag = le16_to_cpu(ref->ReferralEntryFlags);
 
 		/* copy DfsPath */
-		if (le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+		if (le16_to_cpu(ref->DfsPathOffset) < sizeof(*ref) ||
+		    le16_to_cpu(ref->DfsPathOffset) > data_end - (char *)ref) {
+			cifs_dbg(VFS, "%s: DfsPathOffset %u out of range [%zu, %td]\n",
+				 __func__, le16_to_cpu(ref->DfsPathOffset),
+				 sizeof(*ref), data_end - (char *)ref);
 			rc = -EINVAL;
 			goto parse_DFS_referrals_exit;
 		}
@@ -1060,7 +1064,11 @@ parse_dfs_referrals(struct get_dfs_refer
 		}
 
 		/* copy link target UNC */
-		if (le16_to_cpu(ref->NetworkAddressOffset) > data_end - (char *)ref) {
+		if (le16_to_cpu(ref->NetworkAddressOffset) < sizeof(*ref) ||
+		    le16_to_cpu(ref->NetworkAddressOffset) > data_end - (char *)ref) {
+			cifs_dbg(VFS, "%s: NetworkAddressOffset %u out of range [%zu, %td]\n",
+				 __func__, le16_to_cpu(ref->NetworkAddressOffset),
+				 sizeof(*ref), data_end - (char *)ref);
 			rc = -EINVAL;
 			goto parse_DFS_referrals_exit;
 		}


