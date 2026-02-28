Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461CC4A33E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300958; cv=none; b=YuZgsETV0/D6gN5rd892TI313MEYvF+Udl1TkM3Jd21iBDKVKQd/t8tZFaIUs3nvWODoK+f+akcahOr4tDr0Px0kVzWgG4GxUSzimD4yufTqlteX3aqGgKYTijqOjrlV+7CMW+bjAMiEjeRfbOI8axPeo8EA61COeCGKotGeKwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300958; c=relaxed/simple;
	bh=Tt05porqRyRnssxdn9DZukO1OHEjo69i5bpT6YuJ088=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deAQrbXJ5/jgTe/kHYQbb7i7h4q2vxYGzg5orrJ/BYEprA5PCV9G/izgRerh2/X3UA7XbwGqySUR4s5ecan1cW9XhBL3IyHNdU7SCtOFApCHVEXteNo9YMp7+M/OLDDSBePosdeJM7S9RtXTN3RQhG9LjgLGS1xI87zkTQ/FyT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9jG1HdM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9jG1HdM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F23C2BC87;
	Sat, 28 Feb 2026 17:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300958;
	bh=Tt05porqRyRnssxdn9DZukO1OHEjo69i5bpT6YuJ088=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9jG1HdMqf0j51NTyIa5BMMMQkehbPS7uhDEqINVFXJ1RY68YIuTynNiRErz7kl1A
	 KRqAu9riEGXLbudRcODwzIpVJZg1A22fgwIZz36tCkA60lGAd2YeXNGcWZi4so3fk+
	 ni67LpB6d+PKsjIMyKRPQM+by1nnN5vE6yPIB18DcLgPImMrVRU2Q+Lmpr2YhD75Cz
	 2VDi/pjEbFVklKnYQHg3Mtex6ICrIccVk/nqRJkgqjOMf8C8MwVjyGb9X3Hazruk/Z
	 dpk+TkMKCuVtS1qlwAzX34pbf2vdppcAPkiefqKN6hgpLtootRQOVAxKB9PhM7hqGA
	 7bptsjVTC284w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 082/752] bpf: net_sched: Use the correct destructor kfunc type
Date: Sat, 28 Feb 2026 12:36:33 -0500
Message-ID: <20260228174750.1542406-82-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sami Tolvanen <samitolvanen@google.com>

[ Upstream commit c99d97b46631c4bea0c14b7581b7a59214601e63 ]

With CONFIG_CFI enabled, the kernel strictly enforces that indirect
function calls use a function pointer type that matches the
target function. As bpf_kfree_skb() signature differs from the
btf_dtor_kfunc_t pointer type used for the destructor calls in
bpf_obj_free_fields(), add a stub function with the correct type to
fix the type mismatch.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260110082548.113748-8-samitolvanen@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/bpf_qdisc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/sched/bpf_qdisc.c b/net/sched/bpf_qdisc.c
index adcb618a2bfca..e9bea9890777d 100644
--- a/net/sched/bpf_qdisc.c
+++ b/net/sched/bpf_qdisc.c
@@ -202,6 +202,12 @@ __bpf_kfunc void bpf_kfree_skb(struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
+__bpf_kfunc void bpf_kfree_skb_dtor(void *skb)
+{
+	bpf_kfree_skb(skb);
+}
+CFI_NOSEAL(bpf_kfree_skb_dtor);
+
 /* bpf_qdisc_skb_drop - Drop an skb by adding it to a deferred free list.
  * @skb: The skb whose reference to be released and dropped.
  * @to_free_list: The list of skbs to be dropped.
@@ -449,7 +455,7 @@ static struct bpf_struct_ops bpf_Qdisc_ops = {
 	.owner = THIS_MODULE,
 };
 
-BTF_ID_LIST_SINGLE(bpf_sk_buff_dtor_ids, func, bpf_kfree_skb)
+BTF_ID_LIST_SINGLE(bpf_sk_buff_dtor_ids, func, bpf_kfree_skb_dtor)
 
 static int __init bpf_qdisc_kfunc_init(void)
 {
-- 
2.51.0

