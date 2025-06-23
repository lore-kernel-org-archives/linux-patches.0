Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC821EE7C6;
	Mon, 23 Jun 2025 21:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714438; cv=none; b=SZhHsiEuPZec9Mtz+KC0/7lvbVs1dZcgblj6p2tV7Vu92mZG2GaSCFCPB9UFXqd3DAceF+ZDdbsmz5GijPPvmK9lxPoINGeBlBxqVlRPpSs++Am8MqM1gIKut8lHC2RBHRyvhgqjmnjC6Cm1RYgZ4gn1assh6027L6ghqbQIzMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714438; c=relaxed/simple;
	bh=6CgBv0VKJokmxeLQ820N4sDc7IjNpy0xY/uPy3wl9dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7Nw3s/zluw5RH201cgU+31KnfVQTNJNpyCCV+G69SKTERr10DfOYoIGafLzxfx8b2jfnBCbVfJK+c4q3AX826yhWkVSK7JsQbJoADA/qrbZAgUEaUmKGegzUwechoIzXWCayFhItEmzqta3TF3xdw5+kdAl0d6R0mtUgewp03s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkZMDGcn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkZMDGcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E22C4CEEA;
	Mon, 23 Jun 2025 21:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714438;
	bh=6CgBv0VKJokmxeLQ820N4sDc7IjNpy0xY/uPy3wl9dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkZMDGcnJZ+4LoGUjlycju6MUjlMQcZ9dvL9ZOE6OkskrqVRSAD+Jj/bADQraL67t
	 7EYK5GYSakx0cxIj9e1HbYXK+BnqteCmHFm+yqNIkzEYKRyoovU9ipr7kt3L1V3g7h
	 FrYG9Z8vTl5FRiDt9D4q4zMNo0dawS7aiu4xC7EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dce5aae19ae4d6399986@syzkaller.appspotmail.com,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/290] bpf: Check rcu_read_lock_trace_held() in bpf_map_lookup_percpu_elem()
Date: Mon, 23 Jun 2025 15:06:38 +0200
Message-ID: <20250623130631.027313718@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit d4965578267e2e81f67c86e2608481e77e9c8569 ]

bpf_map_lookup_percpu_elem() helper is also available for sleepable bpf
program. When BPF JIT is disabled or under 32-bit host,
bpf_map_lookup_percpu_elem() will not be inlined. Using it in a
sleepable bpf program will trigger the warning in
bpf_map_lookup_percpu_elem(), because the bpf program only holds
rcu_read_lock_trace lock. Therefore, add the missed check.

Reported-by: syzbot+dce5aae19ae4d6399986@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/000000000000176a130617420310@google.com/
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20250526062534.1105938-1-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 41d62405c8521..8f0b62b04deeb 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -128,7 +128,8 @@ const struct bpf_func_proto bpf_map_peek_elem_proto = {
 
 BPF_CALL_3(bpf_map_lookup_percpu_elem, struct bpf_map *, map, void *, key, u32, cpu)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 	return (unsigned long) map->ops->map_lookup_percpu_elem(map, key, cpu);
 }
 
-- 
2.39.5



