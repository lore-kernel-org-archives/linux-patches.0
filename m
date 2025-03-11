Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F05F25E83B;
	Tue, 11 Mar 2025 15:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705878; cv=none; b=D61eGlBisFWtteToEEFwyoBcWW6BvJUMJSOCILqUBl0SZabbfq8GT4jeTueaFu/xs3dLMjOkaIc0GONMp61YmFKdOwFQx8i7gP4BncHXKN0Qp8M6kYNKP/sLZOImsRQ5rzvFdtcxahfH4nyR1UUDWLt1UD61scP8aA/03JoAhRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705878; c=relaxed/simple;
	bh=CeDsqQKS6WLXPECIW/WEZ19Ap0h7L1oJelUSSuClPgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUsL6v0HVqdeCTEiO33a6Y0zsvH/Ji3axywhyF091BHEmRw/IsEVwcklrXHM3fR+RrNrbwlY/45Cyri0bs9mrgAmwJ/F3D9RwWB6PYJKUXdiy/L+myY/8U4ztOrwunZeqHFi9XHvQAjE8ozzv1iiUH9GQc9rVENAKEwA9+O/TFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5cPuz6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5cPuz6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802AAC4CEE9;
	Tue, 11 Mar 2025 15:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705877;
	bh=CeDsqQKS6WLXPECIW/WEZ19Ap0h7L1oJelUSSuClPgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S5cPuz6YmTY9MEQxuXwEUN2fyIvcy9oK4yPTcJdyh8EBuRhwx6eZpmWxZnAFYWtiM
	 ymtkQGJTiNG1reFcQQxANNgKuhVrlY4oIMTkRlsOaqPhCYiW6uY0RBdAKDeId+Xvpg
	 o4TW2MAUGskRzHAk/NKkModLBSAAbpPebRyiHzXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Rendec <rrendec@redhat.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/328] arm64: cacheinfo: Avoid out-of-bounds write to cacheinfo array
Date: Tue, 11 Mar 2025 15:58:56 +0100
Message-ID: <20250311145721.504409803@linuxfoundation.org>
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

From: Radu Rendec <rrendec@redhat.com>

[ Upstream commit 875d742cf5327c93cba1f11e12b08d3cce7a88d2 ]

The loop that detects/populates cache information already has a bounds
check on the array size but does not account for cache levels with
separate data/instructions cache. Fix this by incrementing the index
for any populated leaf (instead of any populated level).

Fixes: 5d425c186537 ("arm64: kernel: add support for cpu cache information")

Signed-off-by: Radu Rendec <rrendec@redhat.com>
Link: https://lore.kernel.org/r/20250206174420.2178724-1-rrendec@redhat.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/cacheinfo.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/cacheinfo.c b/arch/arm64/kernel/cacheinfo.c
index 97c42be71338a..1510f457b6154 100644
--- a/arch/arm64/kernel/cacheinfo.c
+++ b/arch/arm64/kernel/cacheinfo.c
@@ -87,16 +87,18 @@ int populate_cache_leaves(unsigned int cpu)
 	unsigned int level, idx;
 	enum cache_type type;
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
-	struct cacheinfo *this_leaf = this_cpu_ci->info_list;
+	struct cacheinfo *infos = this_cpu_ci->info_list;
 
 	for (idx = 0, level = 1; level <= this_cpu_ci->num_levels &&
-	     idx < this_cpu_ci->num_leaves; idx++, level++) {
+	     idx < this_cpu_ci->num_leaves; level++) {
 		type = get_cache_type(level);
 		if (type == CACHE_TYPE_SEPARATE) {
-			ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
-			ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
+			if (idx + 1 >= this_cpu_ci->num_leaves)
+				break;
+			ci_leaf_init(&infos[idx++], CACHE_TYPE_DATA, level);
+			ci_leaf_init(&infos[idx++], CACHE_TYPE_INST, level);
 		} else {
-			ci_leaf_init(this_leaf++, type, level);
+			ci_leaf_init(&infos[idx++], type, level);
 		}
 	}
 	return 0;
-- 
2.39.5



