Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4399618F2FF;
	Mon, 28 Oct 2024 06:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097510; cv=none; b=tdCmKzi/v24MVFNvzjoELbUp0j5+FY7pkF9YpAjt4Sd3lLZkr/q1Juq2fNwmPAQHKVLbW7rntpxXg7y+N4PgcOZI4KkY5WEDDInu/UNQ+pAH2+NFA0Ej1qm11huPbDIPMrIwhr5TdJLkK26bJiVIDSpcsvys8EmqwdobFQvk6PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097510; c=relaxed/simple;
	bh=UweZvFU7WYsZ+FMuoPXPBBlh/pzXaCndbbG4X3laRyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y56qml/9ukCd7AOu5mSnkOq0kNNBsf4090Ap+j3dtSXDN4VywHQ+KyA6baR1svFPicD8cvp1JJbc9Cfqltr8XDO30dW/WfrmKktzBTM+fKEMuh7Dd9eOurOkK5rUWDprbhtbSNVjBKz9hgCxzs9otV8VjK7gieFzL4wR5PrVpp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyiSWxy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyiSWxy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CD4C4CEC3;
	Mon, 28 Oct 2024 06:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097510;
	bh=UweZvFU7WYsZ+FMuoPXPBBlh/pzXaCndbbG4X3laRyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyiSWxy8Qze32K7bIlECw+SRnF8ayPOAX9ZdjifX3VMTrNYWBkSPo3jzEKb/zypgr
	 DuTNzvCh4u7MAGU/12m6rmWKvmSXg2mVVH7AIU+EZQmtsSnoZCIfRPHSyxOavRafHg
	 6VdoFqd7VG+UrTwoM6295BbPW9TxOOXOr/n8ko9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/208] bpf: Fix memory leak in bpf_core_apply
Date: Mon, 28 Oct 2024 07:23:06 +0100
Message-ID: <20241028062306.812675299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 45126b155e3b5201179cdc038504bf93a8ccd921 ]

We need to free specs properly.

Fixes: 3d2786d65aaa ("bpf: correctly handle malformed BPF_CORE_TYPE_ID_LOCAL relos")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20241007160958.607434-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index e0e4d4f490e87..c8828016a66fd 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -8435,6 +8435,7 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 	if (!type) {
 		bpf_log(ctx->log, "relo #%u: bad type id %u\n",
 			relo_idx, relo->type_id);
+		kfree(specs);
 		return -EINVAL;
 	}
 
-- 
2.43.0



