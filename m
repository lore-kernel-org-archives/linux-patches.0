Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3971815E8B;
	Mon, 30 Dec 2024 15:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573511; cv=none; b=Qx7rNB2GI0LT5YuRWzajP6Np2F0uj+QPE5sfVdyKpACEVleJUYSYfR1Hs77Zc+fr3NO23bXTrMMS0erbtlHurSd3+6j11L/MsYpD6NpEXDXI2JJ6oxbLjcFBLoX8i7dHyZShhCaBkZJsY4mix3GwcECUj1o5Yo3p/elQnRSslcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573511; c=relaxed/simple;
	bh=xLkIVKm1j3zfDdRPtZFO1H5umMJatNRx2QtOTvgHswg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqrCaAyMKcKLdCF7+3ifT3Z/ZHIGnu2yspZesF3E78mApf39U54wWRqw7iMZadKr4mfhslwf1oeAt9jWqFkS0EGoxSaQd8UPQFLw12+HkvrftwkzAVeU3wi2B7pwVYHlh22RsGk3xCMRUhQgoDZys+iY5aKgsp7m+wg+Qhcf/Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jjpdn8IH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jjpdn8IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231F1C4CED0;
	Mon, 30 Dec 2024 15:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573510;
	bh=xLkIVKm1j3zfDdRPtZFO1H5umMJatNRx2QtOTvgHswg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jjpdn8IHx/+xgBtBooLclYZlMH2YyeKDFdDE9sS73qNyPYWr/LcB6i7X3mQWJpGtj
	 ZnM6pWHLsXKm4MN/kBH3AEb5xXSul5sWFhfG2PBNgFr742v75BYNpMNlSCyqw4Z3Dy
	 VGvYB8Is4bK0GnZr16cWiLdCACn4uO8xhpwJ0iOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Konstantin Khlebnikov <koct9i@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/60] mm/vmstat: fix a W=1 clang compiler warning
Date: Mon, 30 Dec 2024 16:42:12 +0100
Message-ID: <20241230154207.371620931@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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
index 19cf5b6892ce..4fb5fa0cc84e 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -513,7 +513,7 @@ static inline const char *node_stat_name(enum node_stat_item item)
 
 static inline const char *lru_list_name(enum lru_list lru)
 {
-	return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
+	return node_stat_name(NR_LRU_BASE + (enum node_stat_item)lru) + 3; // skip "nr_"
 }
 
 static inline const char *writeback_stat_name(enum writeback_stat_item item)
-- 
2.39.5



