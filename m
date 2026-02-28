Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B7B4A2E2D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300911; cv=none; b=FZU7zLjlk6qZmbV+RokukAi4DmKpSTPqAhdU6Omw2VKQCCJbTEdp6lAiccPhoJa5P0fmoIvO5UFplMyFn73XQkm/H4dql5TCmq6CKmYIJe2k4lPQKlCi3Ru0KkEuNiTHFXpMltGicFNPEk2gvwi7lVkGJ6tMq4QkjlyHAbkbbzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300911; c=relaxed/simple;
	bh=hAXeOOOmI3T8WgXpDixCdLc5UNfP6glbB/SnAzY0/TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DW+OHlUE9Afqb1q9AQLBE5p+E9ST1Ee/J0/ELXcWGH9lzckwgwp7jx9y1c7qdkoS8gnApwKMR0eZl92r7W/j3UibmLeQsRrkPHX6eDN8+fUS++KpPeZ0YsxjW4SKsAmK1+3rC+MgZjN6mzTalc8jNr39dIrXICVKhsetJP/sslc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sij03x7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sij03x7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A8AC116D0;
	Sat, 28 Feb 2026 17:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300911;
	bh=hAXeOOOmI3T8WgXpDixCdLc5UNfP6glbB/SnAzY0/TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sij03x7Qvx9+KCPv56QBGAL20/mgAPefZ7Yf4Jm65/NTklehsPxJaS3Ilpi4sC572
	 zSW2hfV/pzVKrkrSoVRJCfwCB+X2YSNxnTb92HrKUZ7TocYnACszrzJok6W/bttLxk
	 vwQuvWixWhLtCRjP2o1TnEJNMOxiPnGPvNoYAehbISiU+c8EncULJCip56MNgqVVp5
	 CEb/wOZ3X9mUBmMxyzDTOD9IddmKW7PIkSyKOd0CycygNdqFAYcB2iELuOLZ9Z1avL
	 pWCmsjit72LRtgx4FyC++dRDxSpmEbhCecwu187ri2rh9G5zfQG+VF6VUGoSaQNB+B
	 Q9n7F1JT3XYsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Deepakkumar Karn <dkarn@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/752] fs/buffer: add alert in try_to_free_buffers() for folios without buffers
Date: Sat, 28 Feb 2026 12:35:37 -0500
Message-ID: <20260228174750.1542406-26-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Deepakkumar Karn <dkarn@redhat.com>

[ Upstream commit b68f91ef3b3fe82ad78c417de71b675699a8467c ]

try_to_free_buffers() can be called on folios with no buffers attached
when filemap_release_folio() is invoked on a folio belonging to a mapping
with AS_RELEASE_ALWAYS set but no release_folio operation defined.

In such cases, folio_needs_release() returns true because of the
AS_RELEASE_ALWAYS flag, but the folio has no private buffer data. This
causes try_to_free_buffers() to call drop_buffers() on a folio with no
buffers, leading to a null pointer dereference.

Adding a check in try_to_free_buffers() to return early if the folio has no
buffers attached, with WARN_ON_ONCE() to alert about the misconfiguration.
This provides defensive hardening.

Signed-off-by: Deepakkumar Karn <dkarn@redhat.com>
Link: https://patch.msgid.link/20251211131211.308021-1-dkarn@redhat.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/buffer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6a8752f7bbedb..b6b477ff7b75d 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2948,6 +2948,10 @@ bool try_to_free_buffers(struct folio *folio)
 	if (folio_test_writeback(folio))
 		return false;
 
+	/* Misconfigured folio check */
+	if (WARN_ON_ONCE(!folio_buffers(folio)))
+		return true;
+
 	if (mapping == NULL) {		/* can this still happen? */
 		ret = drop_buffers(folio, &buffers_to_free);
 		goto out;
-- 
2.51.0

