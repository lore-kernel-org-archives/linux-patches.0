Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ADE2ECEAE;
	Tue, 17 Jun 2025 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176893; cv=none; b=fHLzwtsD2Ali0kP1jKl4E6nMnx0qdsgkjunOXuoqRxj2DiypRmBolwxJxKaax8Xj08eZPQuQs7hbxXRk14rV1frgP+CTtoHTpKKV+RweBr7GS59sGiRU1f7agf0Ieg0Rq7v215DDtiN/3k5MQ8sUe9wb8Rw+N+ByhGqCauV+zdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176893; c=relaxed/simple;
	bh=1w8h+HOsH4dAvjL3epDArXiK8q6+VdPR3NvMPuXp6Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfKs5XIWZpXzFd/M/PvWwDSQIiDTPzzPHpf2ResBJel7SlcwzVXVhyFnXKV4ijJaVYxvP32CnkPanlAq+ceVQUAakUWSEoYthBN9Yk20gpA2+93TDUf6OGD8hqQvKfCT/8odYbb8X8pF76q3T6sl+S7yGzMeLf1dGLDx3h1RUwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAud9fYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAud9fYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885CBC4CEE3;
	Tue, 17 Jun 2025 16:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176892;
	bh=1w8h+HOsH4dAvjL3epDArXiK8q6+VdPR3NvMPuXp6Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAud9fYOwjbQ4/vtABV75g5yOwDzP5Iw/jVbukAcxXuR8X0In1nm4plyAc6xiPrLp
	 MD/XvVxEz1nmnGAbNdFfjwC3Js5Lpst4fhD6KVjoIrBdCqEvkP9XNlSgmNfhbOUUCv
	 JddUezRMZgiwwZNt78sUDfJ2OYD2H9+J36NnuE8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/512] x86/irq: Ensure initial PIR loads are performed exactly once
Date: Tue, 17 Jun 2025 17:24:02 +0200
Message-ID: <20250617152430.779586870@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 600e9606046ac3b9b7a3f0500d08a179df84c45e ]

Ensure the PIR is read exactly once at the start of handle_pending_pir(),
to guarantee that checking for an outstanding posted interrupt in a given
chuck doesn't reload the chunk from the "real" PIR.  Functionally, a reload
is benign, but it would defeat the purpose of pre-loading into a copy.

Fixes: 1b03d82ba15e ("x86/irq: Install posted MSI notification handler")
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250401163447.846608-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index feca4f20b06aa..85fa2db38dc42 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -414,7 +414,7 @@ static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
 	bool handled = false;
 
 	for (i = 0; i < 4; i++)
-		pir_copy[i] = pir[i];
+		pir_copy[i] = READ_ONCE(pir[i]);
 
 	for (i = 0; i < 4; i++) {
 		if (!pir_copy[i])
-- 
2.39.5



