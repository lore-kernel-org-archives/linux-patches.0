Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA2E1DFDBB;
	Wed, 19 Feb 2025 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956274; cv=none; b=dNUwNQ1X0wn+SBbZm8Ur6+N66WE9kU40Uxs0f3Ldwz6Ct2HLpkY07dXmPc68BYkkb3yEGvfSGqoMilWF7Hzxb6QMOywFDTKk5G0l/4QDuLfwIEZQIN7kGbK/v7+VJ7rMASPn22EUZ1p4Pq15JRxWkW09TyOBRqOZLOnzDFroCfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956274; c=relaxed/simple;
	bh=3a6xgHu1/YOnAjbEtZZiw16bl5Cpy88VspFiYDv9hSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJJ2xKySqaiErwUr5A2CsEHJeR3pqutzj75D0Uha8CYKpaHzkwnNJPqGvEHCSCpCQu31dwo3HPL9HV1auEs756bf7Yrz6vY9CQGcZ6N++B2xdwexa2kY5HcZLkJpx44uQ6hdrAbbcNRjLLtMzp7zFF6CMvLFnsjXD/MuGRw8yM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJgGd2NR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJgGd2NR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C11C4CED1;
	Wed, 19 Feb 2025 09:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956274;
	bh=3a6xgHu1/YOnAjbEtZZiw16bl5Cpy88VspFiYDv9hSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJgGd2NRIRjdtX3Gh9r729W86b3EthgOTqfdrISN2GKPwCYVcujchWVEBDgzMvS00
	 xakjxi8v9ly1KW1BeESXAbYEgzyZjkuo/Xh6MqgEz3f7obgqQPZ3D0x9ClmEpUt3c3
	 Xl6EKq8QpfAIP0dsw4WlEuep3Nr1P3l/pJTyMU7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com,
	Puranjay Mohan <puranjay@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/578] bpf: Send signals asynchronously if !preemptible
Date: Wed, 19 Feb 2025 09:22:09 +0100
Message-ID: <20250219082657.905779538@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 87c544108b612512b254c8f79aa5c0a8546e2cc4 ]

BPF programs can execute in all kinds of contexts and when a program
running in a non-preemptible context uses the bpf_send_signal() kfunc,
it will cause issues because this kfunc can sleep.
Change `irqs_disabled()` to `!preemptible()`.

Reported-by: syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67486b09.050a0220.253251.0084.GAE@google.com/
Fixes: 1bc7896e9ef4 ("bpf: Fix deadlock with rq_lock in bpf_send_signal()")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20250115103647.38487-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f46903c1142b5..af48f66466e81 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -857,7 +857,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (irqs_disabled()) {
+	if (!preemptible()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



