Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519632F2D;
	Tue, 27 Feb 2024 13:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041416; cv=none; b=rPqV3tllSYhL9gSqIArCjdYj/tP5mGNyllm3LvkathVIROMRCDFc0zdONc51+G8flZQA7DimfzjeWh8SFLZPJpGvLA1VD1mO2JCr1jyGxjzjj9BIYPtboDTYKEbh7fD68rOJon/BgbFqgNZZy86qmqkUEwv4N+8odMF503ahbow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041416; c=relaxed/simple;
	bh=eG2xMOqPBGcR+sLvAhvODFuxpyd6tY4kKVPTIoK0vXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyD8ZlE2CfBh05/M07pcKVeq9vxzdhni368U7Ihy8H4eIbbu4JmEW/DqylqN700lxGr7DYj8aS8HZFo80TyGN1+mshLNRoSC2WnMTwWcxrkiq87skrdTJRQW6H47sLGFrohlQX76Qx9gcwh5eyT+LSnDRByd1HDC9J/BWKZ8JeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqR08y5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqR08y5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8221C433F1;
	Tue, 27 Feb 2024 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041416;
	bh=eG2xMOqPBGcR+sLvAhvODFuxpyd6tY4kKVPTIoK0vXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqR08y5Moenw9LnpTBm9xVj3porU1rHupV374ozGHmyQ30KhjJ2/NE7Dzht6ChR08
	 VQcZ1k4nm0f2ni+nRuMtPRDebFN7aLWGJOeNgaAZMgGgVxD8B7nZsQPDTdpnYdLs5i
	 ozpjWeyXBlki9kGg8jw28OIlgpCfVOeGHLZUmvVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengming Zhou <zhouchengming@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 332/334] mm/zswap: invalidate duplicate entry when !zswap_enabled
Date: Tue, 27 Feb 2024 14:23:10 +0100
Message-ID: <20240227131641.857057816@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengming Zhou <zhouchengming@bytedance.com>

commit 678e54d4bb9a4822f8ae99690ac131c5d490cdb1 upstream.

We have to invalidate any duplicate entry even when !zswap_enabled since
zswap can be disabled anytime.  If the folio store success before, then
got dirtied again but zswap disabled, we won't invalidate the old
duplicate entry in the zswap_store().  So later lru writeback may
overwrite the new data in swapfile.

Link: https://lkml.kernel.org/r/20240208023254.3873823-1-chengming.zhou@linux.dev
Fixes: 42c06a0e8ebe ("mm: kill frontswap")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1222,7 +1222,7 @@ bool zswap_store(struct folio *folio)
 	if (folio_test_large(folio))
 		return false;
 
-	if (!zswap_enabled || !tree)
+	if (!tree)
 		return false;
 
 	/*
@@ -1238,6 +1238,9 @@ bool zswap_store(struct folio *folio)
 	}
 	spin_unlock(&tree->lock);
 
+	if (!zswap_enabled)
+		return false;
+
 	/*
 	 * XXX: zswap reclaim does not work with cgroups yet. Without a
 	 * cgroup-aware entry LRU, we will push out entries system-wide based on


