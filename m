Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA2E604C5;
	Tue, 23 Jan 2024 00:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970821; cv=none; b=tpKWj6WsP5UpWycAnMHANiUCxykTvveqVIQEiDSEPwpX7uVWZyRMWt+nL7Pejt4snxbfNalrO8uKK3JfDN2eiOq6NVoI1AWGPFGTpacfNF2uMYevWmr7Yve8NZN0x41j5WDw5AoPBJy6hEG/jUvkNndBWsDs19UI7BDtJ47L8v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970821; c=relaxed/simple;
	bh=nwIRKbaxOTeu792JI4Pb4kyTZVgFb/O2ndCG44cNMiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qupi/TA2wgggN6fdEUmP2E4Zn4bvMFh5GxBazTRC47nXMSMjMQ28me+D/UXQfCu/Q6l4RwCUZKiqcOG0mkhY4FXy6xlyZNu42kKxB+nLpruSMSRDaVNOZpI47eKkZbKarI+4w6X5SeppnxdLBOqOkiSZbV9qarrNmi/djn8j7q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rfqn3mIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rfqn3mIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D75C433F1;
	Tue, 23 Jan 2024 00:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970821;
	bh=nwIRKbaxOTeu792JI4Pb4kyTZVgFb/O2ndCG44cNMiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rfqn3mIBG7nW5/RQ1maYd+hjnK/XQOX/+iHK+pEyR3PIHaWzchx98LcsX16bvVh9i
	 F4g8/LadLT9XHbytNIRfko0PgIhncUFSf1jwmhb9IX48OcoF+Kqobpr2jM+0mzbcdO
	 EcDZYFFNePEXuFKY3HYMsvacBpwXIzpf07px0p9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <aspsk@isovalent.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/417] bpf: add percpu stats for bpf_map elements insertions/deletions
Date: Mon, 22 Jan 2024 15:54:22 -0800
Message-ID: <20240122235754.948596489@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <aspsk@isovalent.com>

[ Upstream commit 25954730461af01f66afa9e17036b051986b007e ]

Add a generic percpu stats for bpf_map elements insertions/deletions in order
to keep track of both, the current (approximate) number of elements in a map
and per-cpu statistics on update/delete operations.

To expose these stats a particular map implementation should initialize the
counter and adjust it as needed using the 'bpf_map_*_elem_count' helpers
provided by this commit.

Signed-off-by: Anton Protopopov <aspsk@isovalent.com>
Link: https://lore.kernel.org/r/20230706133932.45883-2-aspsk@isovalent.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 876673364161 ("bpf: Defer the free of inner map when necessary")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index ba22cf4f5fc0..21b192ce018a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -249,6 +249,7 @@ struct bpf_map {
 	} owner;
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
+	s64 __percpu *elem_count;
 };
 
 static inline bool map_value_has_spin_lock(const struct bpf_map *map)
@@ -1791,6 +1792,35 @@ bpf_map_alloc_percpu(const struct bpf_map *map, size_t size, size_t align,
 }
 #endif
 
+static inline int
+bpf_map_init_elem_count(struct bpf_map *map)
+{
+	size_t size = sizeof(*map->elem_count), align = size;
+	gfp_t flags = GFP_USER | __GFP_NOWARN;
+
+	map->elem_count = bpf_map_alloc_percpu(map, size, align, flags);
+	if (!map->elem_count)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline void
+bpf_map_free_elem_count(struct bpf_map *map)
+{
+	free_percpu(map->elem_count);
+}
+
+static inline void bpf_map_inc_elem_count(struct bpf_map *map)
+{
+	this_cpu_inc(*map->elem_count);
+}
+
+static inline void bpf_map_dec_elem_count(struct bpf_map *map)
+{
+	this_cpu_dec(*map->elem_count);
+}
+
 extern int sysctl_unprivileged_bpf_disabled;
 
 static inline bool bpf_allow_ptr_leaks(void)
-- 
2.43.0



