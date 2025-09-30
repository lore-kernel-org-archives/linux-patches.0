Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4575E173;
	Tue, 30 Sep 2025 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245605; cv=none; b=DXq3tCjjm4bHOsnFtuEbGnShj1RWWISCuEDA84JivIX6JFinfEqy0dgUZKxarb6GhCBP2d6tCzWy252HjEhmpVSdtfRXyZCEftczqi+es+gUasF5csOH/JdZuOe19g8lovf9rUsWSJ436QBb6k1y0MnWALdzkw7O0uKMjmnYD6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245605; c=relaxed/simple;
	bh=nKRiAPRgs2FoFI1P2cBv5v0XDP4OfnCbc75oTdPx5T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDYhX136GM9ouFvLmOfoOZ7q2PobgnAc7Nl2ReCOpzFWrlWzLcYsNOnLH4XumCg9K9aGSjiP5srutQe7FX/D6oMNco5lN8kYnMCQVpZYUf1HVpZvPst4xctAzYnQgDeLQZlUXgplUoSmC2tcSelHpIhRWR61v8q+BSbZGzaE1RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SL3wCX+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SL3wCX+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8675C113D0;
	Tue, 30 Sep 2025 15:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245605;
	bh=nKRiAPRgs2FoFI1P2cBv5v0XDP4OfnCbc75oTdPx5T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SL3wCX+NihicAGsxaN/5mjRliHEbIG4+2gPLVNHO1oQjAcMGS+++NJ6iggJsWZewb
	 QTBB8uaJAk1OHE4NRh6ZnyiWzn4/XaIccHrJ7C0/oddl3wiSEIRKogwkeyV12inLNB
	 /PG/iJprw7+n/T2LTLSahw7y7ctGfORzFXvlDDj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/73] bpf: Reject bpf_timer for PREEMPT_RT
Date: Tue, 30 Sep 2025 16:47:31 +0200
Message-ID: <20250930143821.704438240@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit e25ddfb388c8b7e5f20e3bf38d627fb485003781 ]

When enable CONFIG_PREEMPT_RT, the kernel will warn when run timer
selftests by './test_progs -t timer':

BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48

In order to avoid such warning, reject bpf_timer in verifier when
PREEMPT_RT is enabled.

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20250910125740.52172-2-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ead1811534a0d..276a0de9a1bb2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5733,6 +5733,10 @@ static int process_timer_func(struct bpf_verifier_env *env, int regno,
 		verbose(env, "verifier bug. Two map pointers in a timer helper\n");
 		return -EFAULT;
 	}
+	if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+		verbose(env, "bpf_timer cannot be used for PREEMPT_RT.\n");
+		return -EOPNOTSUPP;
+	}
 	meta->map_uid = reg->map_uid;
 	meta->map_ptr = map;
 	return 0;
-- 
2.51.0



