Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA3233FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300919; cv=none; b=Xhzy7Ogeyau24LawHabei59saYNTrcR28H7JZEcoTJF7hbf1qPxdyOvVLb50Bz0VjQNB3joPRebhJWEeAvV1q6eVkfnUL6/UPv+8G+ZiJ8mcrbHBhmJ0h7Qq129hcihTdH1AQVblE9LSXdYyRbw5+d/9zXRO3OwTnZgi4s/Wl44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300919; c=relaxed/simple;
	bh=qFxe7UMVks0SzFECFu0TKvPZLn9NTWwEwRkXjs1MK28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQTlWuvLO7MzIRtNAdcTa6EhqKG6qv/rG1zG7pfPIrwhwvK+QNAZqJ6P8ozmxRcSM78OlLL4x8Vo6s5i/+IOwnzjcrU7w1zc/raF5zLrrOpj6Qq1pVJJyUnqKTOgGq37EYSmcw9R3bZ3bByBPsTtSqYgLpGh7Ao85RQRYRrR8Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PXRREQsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PXRREQsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFF7C2BC87;
	Sat, 28 Feb 2026 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300919;
	bh=qFxe7UMVks0SzFECFu0TKvPZLn9NTWwEwRkXjs1MK28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXRREQsvu0SA/w1MqkpYinL/s7XJqNmze7jlwvSCtczXL8kLUj3xeHNt7LlyRGn2F
	 5TiTZoo3iG6R8KdON5PIoTgeByWrcXH0Kl0LO2bbckQXTCT9l1LyjwiuPLQfnl2u34
	 UI9s6kS1fftS5p6lalaYNzbOoxjd2/vCG5O05NYx/JeMdjvmY9QnycX6d+avqULL83
	 xDYRWC+bQeFeQOZnX/DHEEPhdCXnS5eMgrXQVCzg6Q1Ub9Z4IHCRiRD0zu4yUsU79G
	 tWjzdIeuG0jc9xx3E/tJ0sLMBSjaRg4BgmGivh95HnLm7oWL6QsVMDSprjwI9xrNS5
	 4Oo2mYFnBgXwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ezrak1e <ezrakiez@gmail.com>,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/752] dlm: validate length in dlm_search_rsb_tree
Date: Sat, 28 Feb 2026 12:35:46 -0500
Message-ID: <20260228174750.1542406-35-sashal@kernel.org>
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

From: Ezrak1e <ezrakiez@gmail.com>

[ Upstream commit 080e5563f878c64e697b89e7439d730d0daad882 ]

The len parameter in dlm_dump_rsb_name() is not validated and comes
from network messages. When it exceeds DLM_RESNAME_MAXLEN, it can
cause out-of-bounds write in dlm_search_rsb_tree().

Add length validation to prevent potential buffer overflow.

Signed-off-by: Ezrak1e <ezrakiez@gmail.com>
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index c01a291db401b..a393ecaf3442a 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -626,7 +626,8 @@ int dlm_search_rsb_tree(struct rhashtable *rhash, const void *name, int len,
 			struct dlm_rsb **r_ret)
 {
 	char key[DLM_RESNAME_MAXLEN] = {};
-
+	if (len > DLM_RESNAME_MAXLEN)
+		return -EINVAL;
 	memcpy(key, name, len);
 	*r_ret = rhashtable_lookup_fast(rhash, &key, dlm_rhash_rsb_params);
 	if (*r_ret)
-- 
2.51.0

