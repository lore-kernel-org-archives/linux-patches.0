Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3660202983;
	Mon, 23 Jun 2025 21:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713221; cv=none; b=KCj3vQGKiIjsRuRVW3yQm3SGsuyn7grOwc0aKXc4eg1QyAzBWzWppa8rgq0FA2BsCBK9xmeeFUehzNx7kRRoQVQ1JiJlaJFquoL8wWTQvTdh4cVwRH3mT2IEpCGTYaY814vSjDSgvweUxB2CIdN1W34kqSE2hKel6GaUj2dXedM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713221; c=relaxed/simple;
	bh=PC3CuU6ga4b/qPC+GyYUc6hrXBYVmnFGGt+mnpuw6EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUXPVrbyKtxBEx3tfHpVD+63MbBngRNjGX/Ksh5zXERPEctRLEB6roTEOQFFm10RoqhVVhkKqj6rzPevfSoWLbp0vNA+MZf/g9fc8152jyhnur5ta0SN9juJBmWkZEpH2JUuIDcjx1Hva5+ZnWAed4dyNwlUp1MZLVv67ZWP7DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9np1Elu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9np1Elu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7BFC4CEEA;
	Mon, 23 Jun 2025 21:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713221;
	bh=PC3CuU6ga4b/qPC+GyYUc6hrXBYVmnFGGt+mnpuw6EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9np1Elu17IcSO8+TOIopBxBDCpBT1SCP2tO/v+BhkepaQA77i0Xmpw30TQdbS3RV
	 sTe8oQcxSipXJ9PSQMpAaMHldpazQa5L+LPWFqDyKNpvgKj35gBHNKmAOHv6fU1K8a
	 ZcTeho2jet+SAJ5X4UrZHOa/jcbsQ9bGvfFJ8gxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dce5aae19ae4d6399986@syzkaller.appspotmail.com,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 315/592] bpf: Check rcu_read_lock_trace_held() in bpf_map_lookup_percpu_elem()
Date: Mon, 23 Jun 2025 15:04:33 +0200
Message-ID: <20250623130707.915806376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e3a2662f4e336..a71aa4cb85fae 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -129,7 +129,8 @@ const struct bpf_func_proto bpf_map_peek_elem_proto = {
 
 BPF_CALL_3(bpf_map_lookup_percpu_elem, struct bpf_map *, map, void *, key, u32, cpu)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 	return (unsigned long) map->ops->map_lookup_percpu_elem(map, key, cpu);
 }
 
-- 
2.39.5



