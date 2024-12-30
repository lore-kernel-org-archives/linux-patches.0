Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C445B1AAE33;
	Mon, 30 Dec 2024 15:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574040; cv=none; b=RC5XjUBA+2r0qYSi4DUbz8eEBDrZxBVIWqQdHz2r1wrwCFqIGDVFb3jReW7ccMod5wtxqB1LBFeEBBJUL0E3OemETZDaWpfTMtFg5eGtz1gQR1Dh4WQ83namJH4b95Bdfw4NcKQfcyuaACRuP5j9MuEOYzJCyNgH2/p8XwARh3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574040; c=relaxed/simple;
	bh=o8G70GdW31WaRPEP/0RAPScGBM/GN1HU7873rRM6J8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwDepWXIM43d26qR5xlv2nokV772v94g1EsQUAO6itBt49R2YHhqZH709Toofwm78VdUJP0HACd29u7f3Pg9tpMLJRiu9pwr2NfTKsoVifgj70HVh1e+OL+BS9qWhKaDfmxqUkOLKXHIpif8xd6UWu7PB++ggKAjPZd87K7hX2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCI7DQeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCI7DQeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496B2C4CED2;
	Mon, 30 Dec 2024 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574040;
	bh=o8G70GdW31WaRPEP/0RAPScGBM/GN1HU7873rRM6J8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCI7DQegt7WBFeg3hzv/cK5Tj7YBq0X41ov5p3UD1CMdS9iw/B87zRQLgZ01AuN1T
	 AH2EnOVnN+tIYuN30UiVOqymrt4ChPQETHNkZaHCyvtzMfz/NjhG56fhM7IO1UyYZS
	 5wS+NySkrYcbXqjhGlqPBnO0GCr95/hF6P7159+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/114] mm/vmstat: fix a W=1 clang compiler warning
Date: Mon, 30 Dec 2024 16:42:03 +0100
Message-ID: <20241230154218.306448762@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 30c2de0a267c04046d89e678cc0067a9cfb455df ]

Fix the following clang compiler warning that is reported if the kernel is
built with W=1:

./include/linux/vmstat.h:518:36: error: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Werror,-Wenum-enum-conversion]
  518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
      |                               ~~~~~~~~~~~ ^ ~~~

Link: https://lkml.kernel.org/r/20241212213126.1269116-1-bvanassche@acm.org
Fixes: 9d7ea9a297e6 ("mm/vmstat: add helpers to get vmstat item names for each enum type")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vmstat.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index d2761bf8ff32..9f3a04345b86 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -515,7 +515,7 @@ static inline const char *node_stat_name(enum node_stat_item item)
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
 }
 
 #if defined(CONFIG_VM_EVENT_COUNTERS) || defined(CONFIG_MEMCG)
-- 
2.39.5



