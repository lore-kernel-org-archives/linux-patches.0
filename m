Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58053876B0;
	Tue, 10 Mar 2026 11:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141931; cv=none; b=mb/sAOCBuX1xiCMJJPGuNiwZCqRpKLDxHacTyqDRZDCkKE/0McyfZdv+oy21/Q2GM3lNm4cHQ/AMMYHSL2uKflWyGrtDEAYXPAirwhIsB0P8Yr7fqzZwzxGhiP66EyxbZ6foVU/q3sg4knh/QfjRMo2MhBbjI1kS6iEjmM2q+4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141931; c=relaxed/simple;
	bh=f25AIy4501CoqbO3vsdXAGMsDM5fHn44JgW67BoGRg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDSI/kTfUTXA2IVN/hEjt7ZNnC7De+1a5r/uLSNAzico/iQxmLpwbBb7SozHIP2FZ+JQL3UKoqVEIn+VsEbZB7o0KG46KS177F8sVkqybpB18l5PguBVGx7HhsSEO6kbS5pSZIU2rLWchKDTL2YqL2DMiKIfgiqn688fW/Y40WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4KG3j7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4KG3j7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3A0C2BC86;
	Tue, 10 Mar 2026 11:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141931;
	bh=f25AIy4501CoqbO3vsdXAGMsDM5fHn44JgW67BoGRg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4KG3j7RF+sG5TBodyK3DlelpQTaeqHna/h2GADrSQF7fjLdoVtHzIRdmSXzZJsKJ
	 c1Pul3NkVl5CB4hnbmAy3NCOYWIgTg379erR2MuGk57K3JEQh6zINrYn5cYr8N2KzJ
	 FfyjqSKOh22Ly59tS5f6UmjOYR3xGth4T2M2XYD0z6HhA/lIp7E0IVl+of5d83EN0F
	 Ie9IxLiRPNWUfiPS1tw0Kvx9o5uhSBwO8Mrv30EyYzgTqMlq6KF4VECkXDnrIKYNUT
	 zYxjklCBOxv0b6/wzKcQ7tuxbO9liT/LZ1yo+fFRK9skvwqYPdRm3wh3VbdFGbmcfq
	 vwzqbLS1NFKIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Harmstone <mark@harmstone.com>,
	Chris Mason <clm@fb.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/314] btrfs: fix incorrect key offset in error message in check_dev_extent_item()
Date: Tue, 10 Mar 2026 07:15:14 -0400
Message-ID: <5b2ecca7f719747de5ea5ec084fdcc94f7802106.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 511dc8912ae3e929c1a182f5e6b2326516fd42a0 ]

Fix the error message in check_dev_extent_item(), when an overlapping
stripe is encountered. For dev extents, objectid is the disk number and
offset the physical address, so prev_key->objectid should actually be
prev_key->offset.

(I can't take any credit for this one - this was discovered by Chris and
his friend Claude.)

Reported-by: Chris Mason <clm@fb.com>
Fixes: 008e2512dc56 ("btrfs: tree-checker: add dev extent item checks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c10b4c242acfc..7bc758ec64a11 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1894,7 +1894,7 @@ static int check_dev_extent_item(const struct extent_buffer *leaf,
 		if (unlikely(prev_key->offset + prev_len > key->offset)) {
 			generic_err(leaf, slot,
 		"dev extent overlap, prev offset %llu len %llu current offset %llu",
-				    prev_key->objectid, prev_len, key->offset);
+				    prev_key->offset, prev_len, key->offset);
 			return -EUCLEAN;
 		}
 	}
-- 
2.51.0

