Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD94A231854;
	Mon,  2 Jun 2025 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875938; cv=none; b=Zt5HJBx95576djw08JZ6iJ6/iMMColPVV21dyM8Qy3Od1+vRAssTx0jfmxg5MdJlGIQ7DlDFbNsUVaMPfzQB8GJxJTsGwrPSYXbS7ddqTScB3u/PVbjLx1jDirVdYYnprpgMchjkFzJcVayTeAwKOa7NeyIWLsBCjlNSQnZdsFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875938; c=relaxed/simple;
	bh=pTovmpH3iGYILiUB5CpRbnX+NUJ3Cjfd42hxBBzWM9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvTBZwTOb1Sjxu6eV+yFgaOfzs6fHPf8U86iJGHMBWJy/VUftQd9lV03/GcSoRpyDoHbIPjOCx2Awz2nOav3O6dSfRA6CzX8eZDVCuAj/0wiCBXUnpiuo1Dntq4HT+SxiwygsQpORxnapiKiaskCwy0ApDDbukJefeFQB9a3Qas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOzn+pJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOzn+pJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF78C4CEEB;
	Mon,  2 Jun 2025 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875938;
	bh=pTovmpH3iGYILiUB5CpRbnX+NUJ3Cjfd42hxBBzWM9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOzn+pJwBfGrr6Gdr8l++noMgC3cevwyZsLVcskixiNt+k2MlG5IFqTOTGYBzwWGq
	 mcYNISM/HW5k9GsG1dKJXrq85T0rX5otbVjXb2ZmlezbVgGS7QUQ4gJKoIE+pxBjzw
	 DtW3wMASIsze2PoxQVqWOcF+SC4vB7JdNsrz7gFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Kammerdiener <brandon.kammerdiener@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/207] bpf: fix possible endless loop in BPF map iteration
Date: Mon,  2 Jun 2025 15:46:18 +0200
Message-ID: <20250602134259.018682196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d08fe64e0e453..24258c54057d4 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2102,7 +2102,7 @@ static int bpf_for_each_hash_elem(struct bpf_map *map, void *callback_fn,
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



