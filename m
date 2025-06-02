Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F5E2253BC;
	Mon,  2 Jun 2025 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876606; cv=none; b=SN2W5p6mi3n/vpUZdXqo31jPbRBRECzfiSNTeEPMyhKFEdI/Zc8oi8FxEaUAPRYfnMsnW/bUBvPGn3owSo3H09LIm6dmpZBEgv2hwCViPIBuzCIifguYHazai6yienb3JYEtnh4ri3Sx9dzXaLaeG8alcX84vgc3SNpq4qyKDJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876606; c=relaxed/simple;
	bh=4DCVWKB3CGwyxurtAKWOCX2tQ3IxCL54zl2lMYSCLKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtWrgqNyUOlUe8h0vdy+ejzr+iN0h3ExZUTjsh8lVkPQc1Zl7teEkDMKSHgv+gGCCY2wUWgB9TImB4hGlUHj9yayYwsXL1MeYpvtO3S/LmQ2Ty7VyIErpoa0jzpb/QEV5bQL4WOWTkWbQ7TxCTvdb53mpV6Ooe3u+LJiXcUb5rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAMEKO1Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAMEKO1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3B2C4CEEB;
	Mon,  2 Jun 2025 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876606;
	bh=4DCVWKB3CGwyxurtAKWOCX2tQ3IxCL54zl2lMYSCLKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAMEKO1Q0vUQ4Jt2JE/PAv+YNeQ6qNby09Oi1MxORU+zxQj7JjX/BvOE7uzshyr0y
	 mWb0bJrbqsO0HI+kSjwO2S7LCQs6xeWwaPhF5K0x6XrGzNlPdqyvdZu4O0MqszmugI
	 Nn/Y2TwrVzB7F6gUhCGndXS/L5moih2lKMQ8jvkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Kammerdiener <brandon.kammerdiener@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/325] bpf: fix possible endless loop in BPF map iteration
Date: Mon,  2 Jun 2025 15:44:53 +0200
Message-ID: <20250602134320.439499632@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

From: Brandon Kammerdiener <brandon.kammerdiener@intel.com>

[ Upstream commit 75673fda0c557ae26078177dd14d4857afbf128d ]

The _safe variant used here gets the next element before running the callback,
avoiding the endless loop condition.

Signed-off-by: Brandon Kammerdiener <brandon.kammerdiener@intel.com>
Link: https://lore.kernel.org/r/20250424153246.141677-2-brandon.kammerdiener@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index dae9ed02a75be..06bc7f26be06f 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2172,7 +2172,7 @@ static int bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_f
 		b = &htab->buckets[i];
 		rcu_read_lock();
 		head = &b->head;
-		hlist_nulls_for_each_entry_rcu(elem, n, head, hash_node) {
+		hlist_nulls_for_each_entry_safe(elem, n, head, hash_node) {
 			key = elem->key;
 			if (is_percpu) {
 				/* current cpu value for percpu map */
-- 
2.39.5



