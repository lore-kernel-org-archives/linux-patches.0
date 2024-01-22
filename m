Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1B722060;
	Tue, 23 Jan 2024 01:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974964; cv=none; b=HsdHNDL2TABlV53q/MvSIlGBLm8fTFdP0nb+BhC4fPR1y5WQBOAptI5fqjKHAyu1IoRBAYkxZVZcTLAGbA2mvIFTjIuMa1F6QCchrGtsdpfWzOHa5oJ+D9NZJzCBC14En0HKGQzdSO9KT7Yl9X+g6xw19G0JHwgQj+SC9X/8P/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974964; c=relaxed/simple;
	bh=q6KSqTh68k3oDq51Iiw217elzCcVT47w9CcXN7oRSMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tv6duw4Lr800QVaxdeHgD+9r41pFipafSEp4pVegxRwTxCn97JQVrSNOjkl2LMnZwnHS32eJVX/DrInK/e7Lk5o8UD4Suq7ltm8oiqiiop8a20m08XGBDDxaR1OSKOHAX7auk9vQNAnEsL2uK8QxLBpGRouU+HotEGHgNmI6WcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZGSS2Zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZGSS2Zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6910DC433C7;
	Tue, 23 Jan 2024 01:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974964;
	bh=q6KSqTh68k3oDq51Iiw217elzCcVT47w9CcXN7oRSMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZGSS2ZhcwX4jC2BhXDaA43O5/LRVvkk+pSEi3N1YtrUhvEzdY9DK3LjS8kBMKcXy
	 eYjF/17txBeMF7ht8Bk24bFyKR+mtwtpW+v38XmS+5CYXHMyRcN6eqgzLnkAeqwGSl
	 SvKYPNg9kXlxHfDjivJ3imcvBiufSnLcxKBAJTw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingwei Lee <xrivendell7@gmail.com>,
	Hou Tao <houtao1@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/583] bpf: Limit the number of uprobes when attaching program to multiple uprobes
Date: Mon, 22 Jan 2024 15:53:42 -0800
Message-ID: <20240122235817.262954608@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 8b2efe51ba85ca83460941672afac6fca4199df6 ]

An abnormally big cnt may be passed to link_create.uprobe_multi.cnt,
and it will trigger the following warning in kvmalloc_node():

	if (unlikely(size > INT_MAX)) {
		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
		return NULL;
	}

Fix the warning by limiting the maximal number of uprobes in
bpf_uprobe_multi_link_attach(). If the number of uprobes is greater than
MAX_UPROBE_MULTI_CNT, the attachment will return -E2BIG.

Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Reported-by: Xingwei Lee <xrivendell7@gmail.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Closes: https://lore.kernel.org/bpf/CABOYnLwwJY=yFAGie59LFsUsBAgHfroVqbzZ5edAXbFE3YiNVA@mail.gmail.com
Link: https://lore.kernel.org/bpf/20231215100708.2265609-2-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 868008f56fec..39c4cef98b95 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -41,6 +41,8 @@
 #define bpf_event_rcu_dereference(p)					\
 	rcu_dereference_protected(p, lockdep_is_held(&bpf_event_mutex))
 
+#define MAX_UPROBE_MULTI_CNT (1U << 20)
+
 #ifdef CONFIG_MODULES
 struct bpf_trace_module {
 	struct module *module;
@@ -3198,6 +3200,8 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 
 	if (!upath || !uoffsets || !cnt)
 		return -EINVAL;
+	if (cnt > MAX_UPROBE_MULTI_CNT)
+		return -E2BIG;
 
 	uref_ctr_offsets = u64_to_user_ptr(attr->link_create.uprobe_multi.ref_ctr_offsets);
 	ucookies = u64_to_user_ptr(attr->link_create.uprobe_multi.cookies);
-- 
2.43.0



