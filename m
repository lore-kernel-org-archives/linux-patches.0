Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9E225E817;
	Tue, 11 Mar 2025 15:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705385; cv=none; b=lxZ3+ctDoOdkk70foDoyP77yEUBchLQQUf1vC9MP89tXd4c3VAmeVEU3pTorGaqPv5slpRCTx5JazYkhMswtQ/VNVIxn93Awz7t0vacqEaG77Bz1ItYC1+MY6zBVjl5IYjJpgkV9TOjQO3ABVA3TPuvtc3iMynqeknS8J0V9Fi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705385; c=relaxed/simple;
	bh=LvGr5VIGhvs7baIy1GWT/4+kGaoOwKeHSnbtipqSGFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn6UTTQH4Bc3a1rNKUiTaAq6WNS1b9V65w9+l4gY7nBVfYVYBUGOIITwQvk0WnzJq8Lr2I61FrFlwb+wVN7V4wBRXkZOpMHLbM/J81EqbsEHrD2fT8CpCX7WQsFgar2t76JjQB/YvxkShxesRZEOspfRkCIF84mQ/gcc7CZJoYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5cFCe6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5cFCe6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C4DC4CEE9;
	Tue, 11 Mar 2025 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705384;
	bh=LvGr5VIGhvs7baIy1GWT/4+kGaoOwKeHSnbtipqSGFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5cFCe6UGNNgBFizh57wJW6KfiJItV4loZKZSGWWFL/mZLWkNSJ/JMyaKNQrIllqS
	 1DzV9x7OHMgp5fA89q8Q3Ab7fTJvzDylJIaEwOqtQ3hgIMUpPrLXFFaq4VCwRj06sN
	 QIVG1NYoyaa7g279wmfR39H8Qdf/GTDOGnRYEkPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/328] afs: Fix directory format encoding struct
Date: Tue, 11 Mar 2025 15:56:16 +0100
Message-ID: <20250311145715.127383387@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 07a10767853adcbdbf436dc91393b729b52c4e81 ]

The AFS directory format structure, union afs_xdr_dir_block::meta, has too
many alloc counter slots declared and so pushes the hash table along and
over the data.  This doesn't cause a problem at the moment because I'm
currently ignoring the hash table and only using the correct number of
alloc_ctrs in the code anyway.  In future, however, I should start using
the hash table to try and speed up afs_lookup().

Fix this by using the correct constant to declare the counter array.

Fixes: 4ea219a839bf ("afs: Split the directory content defs into a header")
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/20241216204124.3752367-14-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/xdr_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/xdr_fs.h b/fs/afs/xdr_fs.h
index 94f1f398eefad..cccc8e74f49b0 100644
--- a/fs/afs/xdr_fs.h
+++ b/fs/afs/xdr_fs.h
@@ -82,7 +82,7 @@ union afs_xdr_dir_block {
 
 	struct {
 		struct afs_xdr_dir_hdr	hdr;
-		u8			alloc_ctrs[AFS_DIR_MAX_BLOCKS];
+		u8			alloc_ctrs[AFS_DIR_BLOCKS_WITH_CTR];
 		__be16			hashtable[AFS_DIR_HASHTBL_SIZE];
 	} meta;
 
-- 
2.39.5



