Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFC31DA4D;
	Tue, 16 Jul 2024 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145559; cv=none; b=pE6aR6s5IiTlOKuZjUZ6SiPdbzqd2O/KbmvI603c4vbUlbBj+iT1RPdRJGInymARj+9xXM1ktTOVe6qFK8bnvso4TIwJjrL9D1kfSxPAxkqXJA+253zpu4a2lyqJOToJYf1pzD3lCFpbTSyjIaJRBCa3o1es63nlryb1AUGTMFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145559; c=relaxed/simple;
	bh=V46ERx0EQosId8iPBuvqhTCU8K5GQ1NL6g/HQxdgOT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmEqquEvUOcrat/BsDT/321c+VWSRKaIdeuGrzu2hT5t0RFj5qGINfVlG2OINBm+ga2vETu1snbQ+OAVea/fFgXpK15uItvMKbsrY6yD5Bo7tN79bETTqmv5Qg8I3BNa0UOfUFM1OIjfvfW86pNBBrbkc/53ahfRNjp2QdbbroE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLmI088O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLmI088O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECFDC116B1;
	Tue, 16 Jul 2024 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145558;
	bh=V46ERx0EQosId8iPBuvqhTCU8K5GQ1NL6g/HQxdgOT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLmI088O9y1NoyM6wfEiBnLd1iBkBy0MgeVvnUDhJrx/v6jYyuHKlDJaFS+4ndxAW
	 wQyFW2je92mJ8Qho0yxCfZ6bAwaGx39GIqsFytYQgqzFmoL/m+eh01RcNrl1g2itM/
	 ToxtchJjmSRaaOIm1aEyJzWQWsV85PX4hGS6DQiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Charan Teja Kalla <quic_charante@quicinc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/121] mm: prevent derefencing NULL ptr in pfn_section_valid()
Date: Tue, 16 Jul 2024 17:31:03 +0200
Message-ID: <20240716152751.371818892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 82f0b6f041fad768c28b4ad05a683065412c226e ]

Commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
memory_section->usage") changed pfn_section_valid() to add a READ_ONCE()
call around "ms->usage" to fix a race with section_deactivate() where
ms->usage can be cleared.  The READ_ONCE() call, by itself, is not enough
to prevent NULL pointer dereference.  We need to check its value before
dereferencing it.

Link: https://lkml.kernel.org/r/20240626001639.1350646-1-longman@redhat.com
Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmzone.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e46fbca003099..05092c37a430c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1968,8 +1968,9 @@ static inline int subsection_map_index(unsigned long pfn)
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
 	int idx = subsection_map_index(pfn);
+	struct mem_section_usage *usage = READ_ONCE(ms->usage);
 
-	return test_bit(idx, READ_ONCE(ms->usage)->subsection_map);
+	return usage ? test_bit(idx, usage->subsection_map) : 0;
 }
 #else
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
-- 
2.43.0



