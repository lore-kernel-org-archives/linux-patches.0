Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2001A1C2432;
	Wed, 19 Feb 2025 09:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957285; cv=none; b=l9uYsaqslDNcZhX0rmZcnvgD/teM+laeFMGMOd8EgWi2Cfzq+xispKz9Q84wgeR+HsmTZCTqadxtU2q1qFHU1VOpc205yWEFsSgxB6QxQmA1Iypa9vxEKGPHhslOXcHuS3vzmA4muJ7OtusLtFFJTkzscsoRwnqZllb+eTxDW0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957285; c=relaxed/simple;
	bh=zQjYhK9ZrNQ3/0Px20BizDqLlSCsVzOEcB0k3iFrQ70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCTAuA0/Z3fPk+cahW9jaLv40kfSycjur6DEIoi5HV8yuPL+jspOW3cii858I1SCVJExRlw5pcBMUIuLHkeLvJM5gpyHCqRyo0RzUkfEGZkLR0CSkCabtWeAhQPQZxXhVskjz8SfvqsNCEkmiNdG1TAPnU9yVlru2ROW1eX8vGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDS40Bqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDS40Bqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D863C4CED1;
	Wed, 19 Feb 2025 09:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957285;
	bh=zQjYhK9ZrNQ3/0Px20BizDqLlSCsVzOEcB0k3iFrQ70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDS40Bqa1YrR8ofWlszmsm43HbH7gzdczf/CmEG5U3tBDWMDgv9aUFqMkkz+vz3vj
	 nNGh+h0Fqi5zLuetRtWoEtWmcLj89rtUqGSbrPHtp5ODuJj4bAltYyEawVFcskP/LK
	 sXO+TswqMzSU8VScUTuUQ1IX90wRLIp4Ki70Onug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Rendec <rrendec@redhat.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 472/578] arm64: cacheinfo: Avoid out-of-bounds write to cacheinfo array
Date: Wed, 19 Feb 2025 09:27:56 +0100
Message-ID: <20250219082711.576260069@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



