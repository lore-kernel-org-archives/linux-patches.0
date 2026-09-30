Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E743B2D1A;
	Wed, 30 Sep 2026 19:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796520; cv=none; b=ZaJ3TlC+m7cFVW2ffWNsegXLbgypP2GMyDeHytf7wsvQfC92kOG+qzXUwo0hA9xtfiqbH+IT6PYAVeHQOhjKGpAmhUM7xDUuX2IVvI8WRxt2FR65TzVbMFNp+J/FqJT+Y6OSUEWGX0YL4FJmHfgNZarNrbCEJAiPg9RholOVzuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796520; c=relaxed/simple;
	bh=S5IKrA29vW6jAT3O/kzMQLVBCgccM0oLwfHIRvbV144=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnIshb5XCjL6PwbcU99UQ1mg1SyYtFCbKxprs98Nxd8e+bw26LCVlF7FdGqLF6zwcY9HMhSDbCDxF1JwGi28ILsQv+1rbHZqGEQ5x0JJ/ODLHkwRPCmo3sVK+kEC2OXg4KoJ/pcSumsIjtIGvBjNi2sNESL+A9iEC0nxQfNYm5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fShqLMms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fShqLMms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986301F000FF;
	Wed, 30 Sep 2026 19:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796519;
	bh=EwiWmN5hrM4Xei8EmdI9njEOzuInL+v7jPvdCQuRBR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fShqLMmsOoh25FU6N0dzQwXTZmSG46Fv9pUWqVhgYvXDZHLNFbiairoTmVyFxgn/D
	 N3rln0LOp9z+dBgsuP9vW9k5+PAWxgFB88bccdMMHFMpad1wtm+fMBELjz9NEmF6sd
	 ZlpeXkGUC8D+l5IFRoE9eVdtBxgwPCcGJFhoYy+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0940/1193] smb: client: fix missing lower-bound check on DFS referral string offsets
Date: Wed, 30 Sep 2026 17:27:04 +0200
Message-ID: <20260930152455.123668884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -1056,7 +1056,11 @@ parse_dfs_referrals(struct get_dfs_refer
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
@@ -1070,7 +1074,11 @@ parse_dfs_referrals(struct get_dfs_refer
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


