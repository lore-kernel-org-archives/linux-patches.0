Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018277;
	b=d7AClNNCZqgD+/QRkkRi9rRJZ/LvSuKUNlkiVudBYGkDCiYqCWRyOoqAAinAcidT61/Q
	 bMVl659DNGKj8kaq8JZftFvZoTTBQw69L2QYJAimh5an3Nh1C9z8bCGwB6whiej7jGIt9
	 ajgSX5rWGjkE0JYCe5fbHbJODzlbaHiOp2I6YOjBj0Ym51wFrHw0PLODgf9itqNKkjL9H
	 q1rn/L0KfTrGOlbJXzXwMZ9fcIdo9Sb85r0OGDfel5aK1WgadOyWWpebQVfsrCVS6vpoq
	 jMI3faPjBuqGviT0BOifYxNs3ci++Me/l7muUpmJYrKpVe3AIEcHdS67YHCWDvb6VcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0pKkRe7t22bgFLNE/nEMkoU9z045vlfMyNhXPQjwvE=;
	b=VNExkOP60mqeGXOivK4Msa65R240MDRd1rt6ygCG3rVr3ENKsPCfJhtLOtVIsgj9nn0G
	 RvQEcKKnWtHgNnFUButuDtW9PVY6tZDqd7FB8zwhWp5cKigy0Dcx6yh8w6qJ0rfrlH8IB
	 CIdPgdJJPAKdw6CKmoe/3xEb/b9QrjBiD1Mj9ltqlkQQPhH7ThLj/ygfzHFrAaMQBNbGP
	 rzqDI+zAW9ttMZVNFpeKltd2JkTNxVYtwcEqKbcEhjjmO0E5uahh76h7iIGC6o2K/dxFS
	 mjCSwBMcnWyV8xUST9xj/3FsUPlSDbPf2nDken/g40uSiEPSMciWb+hRuva36j4iGNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZbXAiKf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA90606A320;
	Wed, 18 Nov 2026 16:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ZbXAiKf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C52A1F000C4;
	Wed, 18 Nov 2026 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018277;
	bh=+0pKkRe7t22bgFLNE/nEMkoU9z045vlfMyNhXPQjwvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ZbXAiKfRUwamN13oJluotooCqIv/u7c8oBPu/glyfuEe6oGF/0JyGV7pD9XGJ8Uz
	 KRjPZ6hQl8doYFEZGGnmuWWQUlF7W5UNFzlHr2FlS++MYsHLnWnh3QlOtQjlifDL74
	 cdUy0aisEAh42/kj0UG6awVw4erknjJKVIIw5uaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Shan <gshan@redhat.com>,
	Ben Horgan <ben.horgan@arm.com>,
	James Morse <james.morse@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1184/2651] arm_mpam: resctrl: Correct check that existing class is L3
Date: Wed, 18 Nov 2026 15:40:24 +0100
Message-ID: <20261118150330.627985346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Horgan <ben.horgan@arm.com>

[ Upstream commit 724eae25d16ee49e5cabbd927af95ef2be8fd78c ]

The class used to back mbm_total_bytes can be either at the L3 or the
memory. If a platform had candidate classes at both the memory and the L3
then, as the check for whether the existing class is L3 or not in
counter_update_class() is broken, the class that will be chosen depends on
which order the classes are considered and so the probe order.

Fix the check.

Fixes: 1458c4f05335 ("arm_mpam: resctrl: Add support for csu counters")
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: James Morse <james.morse@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/resctrl/mpam_resctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 9d223057953ab..b825bd90d4bdb 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1076,7 +1076,7 @@ static void counter_update_class(enum resctrl_event_id evt_id,
 	struct mpam_class *existing_class = mpam_resctrl_counters[evt_id].class;
 
 	if (existing_class) {
-		if (class->level == 3) {
+		if (existing_class->level == 3) {
 			pr_debug("Existing class is L3 - L3 wins\n");
 			return;
 		}
-- 
2.53.0



