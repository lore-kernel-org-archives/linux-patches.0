Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE34F3603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300969; cv=none; b=VusKc2u25am+G4rKjrb/fO9aDMQcOCV/G4wSEDP3Jktd6MP3aD58qUaZF8DkQdoncODU4TnWNG0RyRaBbwnP0aqVw73pZBAAHhesfrYVylAVXZn9ad9fYi+AsZkdQX+m50jYVM6ufeoLTdnmdQNd1mbvHQNFZbFHmXg1c8pngbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300969; c=relaxed/simple;
	bh=hqFVOjlF5+ZO2pilwS5gg2mQkEKBO5ayny0CHgbb+js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odDrsoH3B0D5eb1j2V4HfS0y2TOMgtDBBUlmL7ZJ69+p6xiv6SwQ7NJVGCJ4TAe4thAEPFeQyqNLRF1/etYa2jaJ/0O/7qzjjGao+LegUrQRf1ECfPCWQm9L2KyK6ftbIrV32LQ5YXey3GTPQnhCFNHsMbq8o09gpsYkay6Sq4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mC5M9sjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mC5M9sjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE38C116D0;
	Sat, 28 Feb 2026 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300969;
	bh=hqFVOjlF5+ZO2pilwS5gg2mQkEKBO5ayny0CHgbb+js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mC5M9sjPlOiGmmr0gY02pSv8PwSz4oAuz1x2GGNeFlsWIcGOs1oyVIJRzpgHQ3xpO
	 JfSyxAZIoDXBUvx33EPLHoukhggRCHkAGKdLZ5CBQqw16y8iP1gMOBy86P/14tEt3Z
	 BuEieDJ1gwUsDw6VLNfbLH1ipfVnEX8MGwn/8fRjFi+R6waB6LAn0s0DIVnPy3QLq5
	 WCEL7mGXmhq4xRtrbpahejMkziEjfzmYboOGaKZQcaf38lDnnZEDyg/gCqsWn+T2Cd
	 yBxEKfwG3Mp007+VwIqPekhJd0lB9BIAheE3ltsOsf6Rhpmd520bpdtam59W6aGYwa
	 s9WbMbT2B8LQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ruipeng Qi <ruipengqi3@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 096/752] pstore: ram_core: fix incorrect success return when vmap() fails
Date: Sat, 28 Feb 2026 12:36:47 -0500
Message-ID: <20260228174750.1542406-96-sashal@kernel.org>
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

From: Ruipeng Qi <ruipengqi3@gmail.com>

[ Upstream commit 05363abc7625cf18c96e67f50673cd07f11da5e9 ]

In persistent_ram_vmap(), vmap() may return NULL on failure.

If offset is non-zero, adding offset_in_page(start) causes the function
to return a non-NULL pointer even though the mapping failed.
persistent_ram_buffer_map() therefore incorrectly returns success.

Subsequent access to prz->buffer may dereference an invalid address
and cause crashes.

Add proper NULL checking for vmap() failures.

Signed-off-by: Ruipeng Qi <ruipengqi3@gmail.com>
Link: https://patch.msgid.link/20260203020358.3315299-1-ruipengqi3@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index c9eaacdec37e4..7b6d6378a3b87 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -457,6 +457,13 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size,
 	vaddr = vmap(pages, page_count, VM_MAP | VM_IOREMAP, prot);
 	kfree(pages);
 
+	/*
+	 * vmap() may fail and return NULL. Do not add the offset in this
+	 * case, otherwise a NULL mapping would appear successful.
+	 */
+	if (!vaddr)
+		return NULL;
+
 	/*
 	 * Since vmap() uses page granularity, we must add the offset
 	 * into the page here, to get the byte granularity address
-- 
2.51.0

