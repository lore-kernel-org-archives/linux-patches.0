Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1985733F37D;
	Tue, 11 Nov 2025 01:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823170; cv=none; b=sHbUhxIbFvXIgBj52jHGa+RJzlu2WPlE2DG+D2vdFemqtQPbHXjSUKClVQJ4qDVnGTP3wh5FxOyBmI1U+WSOIwDBiSQQ2U2+qAedeM7DtmHocyG/SqK1/614gz09PJh6A/CmQPdm5RxMoEXzbtZsMH1QQI7Gzi6T4s5MpR66vVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823170; c=relaxed/simple;
	bh=YLytaYgxaNPmaS5MvhF8HumWST/QlYp29qUoNeeUiC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1BSUEa7/bi4Eb4VlHbyCA+O3WAf0Qe6bCWmLKtKKyZmSWTuRW46JzEO0otym0PxrKHKdG/8cFIjtfKqV+DqKgwHaDB+s4slnvag5qdFPONsV2+LIZrhqj4K8edd8qeYnZbQ3kxbw1MBYCOaLZkwl6OX1Buay1NNmCMcCk+YA3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXoRR2YX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXoRR2YX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF0BC116B1;
	Tue, 11 Nov 2025 01:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823169;
	bh=YLytaYgxaNPmaS5MvhF8HumWST/QlYp29qUoNeeUiC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXoRR2YX86UvPJ0OwF7rPtLgA8m3RleyaD3QQ1a2t10IJKjUx4cxnY9f/33CBJIkt
	 sU20Iq0OXhZCngHg5y24Loupi3wfMpExQ/ov3qsLqxcXKDLkqYRXQ18HcfCOfOW8J3
	 nHM+gjgFOlZdGhbX/qDyTwHHlG18CqRkzvKcm+18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 208/849] uprobe: Do not emulate/sstep original instruction when ip is changed
Date: Tue, 11 Nov 2025 09:36:18 +0900
Message-ID: <20251111004541.472084708@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 4363264111e1297fa37aa39b0598faa19298ecca ]

If uprobe handler changes instruction pointer we still execute single
step) or emulate the original instruction and increment the (new) ip
with its length.

This makes the new instruction pointer bogus and application will
likely crash on illegal instruction execution.

If user decided to take execution elsewhere, it makes little sense
to execute the original instruction, so let's skip it.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20250916215301.664963-3-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/uprobes.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4b97d16f731c1..109276c68ecba 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2741,6 +2741,13 @@ static void handle_swbp(struct pt_regs *regs)
 
 	handler_chain(uprobe, regs);
 
+	/*
+	 * If user decided to take execution elsewhere, it makes little sense
+	 * to execute the original instruction, so let's skip it.
+	 */
+	if (instruction_pointer(regs) != bp_vaddr)
+		goto out;
+
 	if (arch_uprobe_skip_sstep(&uprobe->arch, regs))
 		goto out;
 
-- 
2.51.0



