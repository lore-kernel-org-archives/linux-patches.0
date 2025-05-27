Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB78E27F16C;
	Tue, 27 May 2025 16:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364400; cv=none; b=uQ3on1q3TULhPwmu9q36HQTc9lJFPVAkCJNkNTK/K6ajWDzT5QOUr7uaeHMwNn0F/JpEOEjw/RyDreDEfwVYsMS55FY3temxu7AYNcguSS9BKSP9O7UZrWEUI+TbcPnXUkaFVTt26R+1dXFKeJarBmSv6bkujKyXEtk0yIpJuqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364400; c=relaxed/simple;
	bh=VNmGqVhOBm8LmbL+anAFbrfi6PTw0HlfZ8kq7DI5xRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtXIU9ovqQv6grBsDaU29p3Yy29aLSOux8tuYpE8TqnNo3QDT4nn0BH3/JxMXXkUQC0vwYBDiPxt2Gv6KIpkrgAsm/q2J4dg2mh9cxd8oZfL5DxgoA7B6li2SdU9e7TcyVHwBq8NAFeTnTIOd/hVjhkg2yceHrqF+O86HgfVZzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFDmegaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFDmegaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17944C4CEEB;
	Tue, 27 May 2025 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364400;
	bh=VNmGqVhOBm8LmbL+anAFbrfi6PTw0HlfZ8kq7DI5xRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFDmegaXMa2AB26GXrBbgc/L4VXMutMiwyxzuelMDTKoCce2Cswl6MbPlS1ii8Dbc
	 TGeCtQcsYCRfT+3tzVLtA8y/W1T6mI9olohDuK88lWYNW7gcxeLepbKBdbTwQKjEpr
	 pnQ0T2AKFqb168iQ9SeYjmA8og5mc6SA0HtwVFnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Kammerdiener <brandon.kammerdiener@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Hou Tao <houtao1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/626] bpf: fix possible endless loop in BPF map iteration
Date: Tue, 27 May 2025 18:18:55 +0200
Message-ID: <20250527162446.770721853@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index bb3ba8ebaf3d2..570e2f7231443 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -2223,7 +2223,7 @@ static long bpf_for_each_hash_elem(struct bpf_map *map, bpf_callback_t callback_
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



