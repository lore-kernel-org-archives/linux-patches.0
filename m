Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60C715CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5ADC433D6;
	Tue,  8 Nov 2022 14:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916520;
	bh=dC4UArNlSzALEEHKLQ1HuG79HBf7LgS3pY2Gyn9sCZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBBfYmhhxnwanpt0mlEFK+FPC6TBSR1kEHTRlKjWG9DUv1TME1vEBZggSvUCTrBGp
	 Hh/19jtZ9ORNQlk28yW2uO53El35Gg+QRPTVbJDoLW6e8loxsmqhqP1Y+EgdBqURXz
	 0juzUxHVd1qC7FK2jTEco7tQlO6fjK2F1bmEySr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 047/197] btrfs: fix ulist leaks in error paths of qgroup self tests
Date: Tue,  8 Nov 2022 14:38:05 +0100
Message-Id: <20221108133356.962166655@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit d37de92b38932d40e4a251e876cc388f9aee5f42 ]

In the test_no_shared_qgroup() and test_multiple_refs() qgroup self tests,
if we fail to add the tree ref, remove the extent item or remove the
extent ref, we are returning from the test function without freeing the
"old_roots" ulist that was allocated by the previous calls to
btrfs_find_all_roots(). Fix that by calling ulist_free() before returning.

Fixes: 442244c96332 ("btrfs: qgroup: Switch self test to extent-oriented qgroup mechanism.")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tests/qgroup-tests.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/tests/qgroup-tests.c b/fs/btrfs/tests/qgroup-tests.c
index eee1e4459541..843dd3d3adbe 100644
--- a/fs/btrfs/tests/qgroup-tests.c
+++ b/fs/btrfs/tests/qgroup-tests.c
@@ -232,8 +232,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
@@ -266,8 +268,10 @@ static int test_no_shared_qgroup(struct btrfs_root *root,
 	}
 
 	ret = remove_extent_item(root, nodesize, nodesize);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return -EINVAL;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
@@ -329,8 +333,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = insert_normal_tree_ref(root, nodesize, nodesize, 0,
 				BTRFS_FS_TREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
@@ -362,8 +368,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = add_tree_ref(root, nodesize, nodesize, 0,
 			BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
@@ -401,8 +409,10 @@ static int test_multiple_refs(struct btrfs_root *root,
 
 	ret = remove_extent_ref(root, nodesize, nodesize, 0,
 				BTRFS_FIRST_FREE_OBJECTID);
-	if (ret)
+	if (ret) {
+		ulist_free(old_roots);
 		return ret;
+	}
 
 	ret = btrfs_find_all_roots(&trans, fs_info, nodesize, 0, &new_roots, false);
 	if (ret) {
-- 
2.35.1



