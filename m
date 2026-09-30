Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C416D511E9D;
	Wed, 30 Sep 2026 16:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786212; cv=none; b=nMTQV+vIREbrdLBLjWMjMaNW3xfk3TD4D82jCPChda76lL9ENTsZ3lEeVjIbprwFXUWITli5Gb+C4vIquNRHjws4O+QU+yM0c7pKgP4ibzfCZ1e7TUM5SUm87HXhaG3ycc8StQx4Lktw4hNUFQ0qeqU6uMkSbNKXXv+TUsn4ve4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786212; c=relaxed/simple;
	bh=FjWdBcIMKjK9HJGLC9/HgJC5MMu2G/dmLXBM9bZjeBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ate+kftaFbE8FFv1AwMYp6WIE7kE4d74RZqUuY9fOxY7GdxfEKrQ5V/c09ld6zn7JVRG5reK0BtqkcfSasUso9WWEZsyjDAQOUQosJnAsI3nOnVGeHoCaPeMh8qdPTt9/y8PA6O9zh+85kgF1JbZ9v2VTXy3CpudMFEc/aKmcZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkywwpKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkywwpKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2626E1F000FF;
	Wed, 30 Sep 2026 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786211;
	bh=cLf+p2oz/I2Wes4ubwxCnvlDOLc0MWUwNcSXW9YxNeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkywwpKEWzzs4po4HX/j3MCQEB9ccFsW9Am0T33T62EBJAvcGf3UVGBumWCJ2GzIj
	 oIHCv9fLCfIHj9AAHyJClxDG0EB3Ci4kPF4O1NNOg/4AKrw5j47K/Mq0X5bIxQqk+t
	 J0SoDi/1Rd6gjgzQG60YcP2UxJhInxVZl/9Vpb6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.1 780/982] smb: client: fix missing lower-bound check on DFS referral string offsets
Date: Wed, 30 Sep 2026 17:25:16 +0200
Message-ID: <20260930152433.509243056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
@@ -1005,7 +1005,11 @@ parse_dfs_referrals(struct get_dfs_refer
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
@@ -1019,7 +1023,11 @@ parse_dfs_referrals(struct get_dfs_refer
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


