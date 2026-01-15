Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C991E3BF2E4;
	Thu, 15 Jan 2026 16:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496210; cv=none; b=nOIEnCdPm7QVzLma7nfhVghiE2K5jLzG4RDlUXzKy21PBLeDl03s0SwNbbw/0SH+p2bzHkIpfjB6kOpdmvkcWjsSqySb21Mfjag45uJgcIzbOMw8Szqagaa3csBaxexjMf0ssQNO/hqh2jZaYPvi9uVChgJPtHciEaqre1LKk7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496210; c=relaxed/simple;
	bh=XzLph8tJMR0g1XhS5dgTlypJw6LCXDjw15DyQy5g+nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI0sXO73LLtnxG0QKnsfNBOMjXbeAcgGvrkCDm9Ll1P35gatVt+q2CV61nLoRa17xeXw9kQQcazWhrgz++fMI1ZuAnfjIZzLbRR7RVSBLq0qhx/e9bA2vYyFabt7ylSgT386qVjqpRa2307g6TtVviLWmTVq8XAM6tU5gjrn4pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vf7ShjCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vf7ShjCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D798C19422;
	Thu, 15 Jan 2026 16:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496210;
	bh=XzLph8tJMR0g1XhS5dgTlypJw6LCXDjw15DyQy5g+nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vf7ShjCV6tXT6hPoSFVJ7H3tFF62a7mmJjYwZOaegibFYvzPuWE1yU3L2C4IW+gfZ
	 Dyb6kuSOhmsvj5bbvWrZ/Vmoziij5AdHgPm1k7jPog9oekPvaEbDZYuTd2aXPvMkIH
	 YKfTVzC4N9TCJ9tvuJ0MZwt4MtQCrx/kFtgkusVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Suchit Karunakaran <suchitkarunakaran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/181] btrfs: fix NULL pointer dereference in do_abort_log_replay()
Date: Thu, 15 Jan 2026 17:47:34 +0100
Message-ID: <20260115164206.539159264@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Suchit Karunakaran <suchitkarunakaran@gmail.com>

[ Upstream commit 530e3d4af566ca44807d79359b90794dea24c4f3 ]

Coverity reported a NULL pointer dereference issue (CID 1666756) in
do_abort_log_replay(). When btrfs_alloc_path() fails in
replay_one_buffer(), wc->subvol_path is NULL, but btrfs_abort_log_replay()
calls do_abort_log_replay() which unconditionally dereferences
wc->subvol_path when attempting to print debug information. Fix this by
adding a NULL check before dereferencing wc->subvol_path in
do_abort_log_replay().

Fixes: 2753e4917624 ("btrfs: dump detailed info and specific messages on log replay failures")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Suchit Karunakaran <suchitkarunakaran@gmail.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index de9ea9d52482f..1444857de9fe8 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -189,7 +189,7 @@ static void do_abort_log_replay(struct walk_control *wc, const char *function,
 
 	btrfs_abort_transaction(wc->trans, error);
 
-	if (wc->subvol_path->nodes[0]) {
+	if (wc->subvol_path && wc->subvol_path->nodes[0]) {
 		btrfs_crit(fs_info,
 			   "subvolume (root %llu) leaf currently being processed:",
 			   btrfs_root_id(wc->root));
-- 
2.51.0



