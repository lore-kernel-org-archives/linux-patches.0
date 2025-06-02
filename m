Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47745224B12;
	Mon,  2 Jun 2025 14:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873080; cv=none; b=FXTqDeTjhOXI2JIzj24TJv+NlsqxMKX0wJ/ucqqgrpwgAAAY0iGhGskgOquBw9rv7U1jvPxjA2R8DJuBBobKNwkrIIFCO9l+4DV3BbgRx7C4S46z5kw2ELk6SJMaexxIAc35NClMFEgzbPzaqxMlZzpNVDNsfcQnQEIUg8hTq5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873080; c=relaxed/simple;
	bh=6gPFYV0SotfomPURtRklv/9CBZjAD/0OjayZCEqRF54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRHyOTkyqAraYeltl7z95+ncmnDN3XJSF3imPEaKjgv39L7gpNLhZuxg2tdAWsLHxMWHlObat7UdBkC2/yid8JZyXQoyO5B4Hf8gUiU9cUFOLcDWWTEBaJe3h5h2QVDvLhmXH+fxrTpvIARHEwcK3Qr9zQl+AahUxGFbr5NO27w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOwjUhKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOwjUhKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F96C4CEEB;
	Mon,  2 Jun 2025 14:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873080;
	bh=6gPFYV0SotfomPURtRklv/9CBZjAD/0OjayZCEqRF54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOwjUhKjFYTxmYjheah4BmiNT4t5OrAYd1oG737Hk5DHn0a5rk7Nc+sYbflrvlCqm
	 5omUVTvzxl+O203UWSFM2AMT8rw6YAnNwegJuZ3fNQBS/kJKP4UqGYq78tPp/L2UGI
	 3x0uzS1AOxYdjfE2rOi/yY8SrZYIYr453PExMIVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Kammerdiener <brandon.kammerdiener@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/444] bpf: fix possible endless loop in BPF map iteration
Date: Mon,  2 Jun 2025 15:41:35 +0200
Message-ID: <20250602134342.181115437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fc34f72702cc4..8a3eadf17f785 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2212,7 +2212,7 @@ static long bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_
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



