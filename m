Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048836;
	b=u+4HiLJIaex7M71cdxfdS/fDKrQ9wAB/8Llvs5bn4QIzXuLxjaeKa+/+0HOdzRee98Nm
	 BqwMQMk5Nn+RIRqHtPX0XnFeY3QzS+z9grGJi8xRepDgWqiJOgozOwduQ7/XRPPqIK6PT
	 5y4fRyu1oEWWsfIu6WYpjTHM0+u4yTBqDL4CeoeTBQpBQ/w1i4zaRA07/7T+KjbqBK0+s
	 DSPT6m5f4AekNtc+HFjbz163i3zZ49NE+GCmKol36TrMC7qkCjlZQhwmJ7kKxMQ3NPvY+
	 khVDj8oLnma678wp0BbWWvZV69fy0D4QqX+UNx8hp6i/S8GTB9FpRU8RoOAklNpWkCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6OhQoAFANgIkh4ttgcqR7QHpR3+33V5frTAM/6KnAJw=;
	b=AlRSXNe7SOG5IUy+6TRCIUwmUyVgFKpXZja2YHEpDLEWFExQeft6hdUrJ7zlQcOvsiWa
	 8vhyKfDwELMj9jE78Ao9FoDkwS13sBuvfjT76kbtC9AfH3lo6jYSS8lGDEErZz5mrZf+W
	 oKIlxojiR3hd/89hhEcrUfwJH+SkfH2AltY6/+OfipmmcJ4AqkTmx3JufCUGZfBMHWoh9
	 JhIwbGl/GgUTdZhVcrZULstCDpNa1C7W1ZiCrsWDMecNH/cesjsryuyKGtbAPZQcT4s8u
	 MvB6hG9Q27gn/rmGzShxepicR80WBA+w5QeQis7oDILF9QOQeiYWn/fEKCWUxJ4haMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdFHtNBZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A14606A320;
	Thu, 19 Nov 2026 00:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EdFHtNBZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10FE1F000C4;
	Thu, 19 Nov 2026 00:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048836;
	bh=6OhQoAFANgIkh4ttgcqR7QHpR3+33V5frTAM/6KnAJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdFHtNBZuyu9DNV+7hSRNrF30oM9R3asqIolwlQgAmWBTvltyENEP1Tgj/lacdZqP
	 QqcV7sf7S6UPUbtFaEvgvqx8z5RpZrgg1Yu3JPqN0rAuxZuzh4P7jtrbNiXoCw8lRH
	 VJrne/XxDeMhl6ydTxONpjMRBHZ+XQcuIK+YcTss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2120/2857] RDMA/mlx5: Restore mr->pi_mr after temporary stack-local assignment
Date: Wed, 18 Nov 2026 15:52:34 +0100
Message-ID: <20261118150317.736525605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9728effe43d8fc4d58e12b697d0d6127355abdd5 ]

In handle_reg_mr_integrity, when mr->pi_mr is NULL (physical-address
optimization path), the code points mr->pi_mr at a stack-local pa_pi_mr
so set_pi_umr_wr can read it during this call. The pointer is never
restored, so after the function returns mr->pi_mr dangles at a freed stack
frame. A second IB_WR_REG_MR_INTEGRITY posted on the same MR without
remapping reads the stale pointer and dereferences it.

Save the original pi_mr (captured at function entry) and restore it on
the out path.

Fixes: 2563e2f30acb ("RDMA/mlx5: Use PA mapping for PI handover")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260919100848.2442-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/wr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/wr.c b/drivers/infiniband/hw/mlx5/wr.c
index 737db67a9ce1d..5965d61e92d96 100644
--- a/drivers/infiniband/hw/mlx5/wr.c
+++ b/drivers/infiniband/hw/mlx5/wr.c
@@ -925,6 +925,7 @@ static int handle_reg_mr_integrity(struct mlx5_ib_dev *dev,
 	qp->next_fence = MLX5_FENCE_MODE_INITIATOR_SMALL;
 
 out:
+	mr->pi_mr = pi_mr;
 	return err;
 }
 
-- 
2.53.0



