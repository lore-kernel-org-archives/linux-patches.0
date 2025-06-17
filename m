Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8552EE28B;
	Tue, 17 Jun 2025 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178396; cv=none; b=c3riDb3Cypfn96fzzcDtmfivSERz7/netWEIq4W6/JxVIj0ojB2M0WzXOiiNy29XZ1er+lteCEm4LKofUTVgkdXzaTL6wZzeTijkEdh8uZ6qtbPyXIYQ1Yej6P1Ae9MqWlt/tKCQ2z5hYqB7fcrrfuN3JiSxGK6M4FCu+VCjJw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178396; c=relaxed/simple;
	bh=JKbsWkk7NPSjgpOEjV9kz4Hzny2E62wY907YoCyAIDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOgxFH6sxA1I4b55MnPHOtKuDmkRbmnB/DGeDcWHQx8lK+piRttYiFaL3WhqYTya5UBB1M97R+++15ysQQ6s0+PMOcxSBCo025JWEAd4jZ8utqW51N3pMX2YeU0Y4Cjo62QoWHKU27KR0UOdMAQBwXElsxXAe9p3E1fu4+WkKZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWhu/sU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWhu/sU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2265DC4CEE3;
	Tue, 17 Jun 2025 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178396;
	bh=JKbsWkk7NPSjgpOEjV9kz4Hzny2E62wY907YoCyAIDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWhu/sU4/Sh3wyT33Rmb3F2TspqNj/2+fUo/pQA89ndOF/ejpRl+Gatu/+2yjMPL6
	 /IvUsS72khV9ddojcOtVtySxE/nWF2iPzIkF8L/ZZlBRCUzJhP+J5igyBFnvzY/4F9
	 TJm3+0fOZwzU9Hj/BtkduShrKfEJjKSkugT5Rw30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 432/780] x86/irq: Ensure initial PIR loads are performed exactly once
Date: Tue, 17 Jun 2025 17:22:20 +0200
Message-ID: <20250617152509.058833820@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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
index 81f9b78e0f7ba..6cd5d2d6c58af 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -419,7 +419,7 @@ static __always_inline bool handle_pending_pir(u64 *pir, struct pt_regs *regs)
 	bool handled = false;
 
 	for (i = 0; i < 4; i++)
-		pir_copy[i] = pir[i];
+		pir_copy[i] = READ_ONCE(pir[i]);
 
 	for (i = 0; i < 4; i++) {
 		if (!pir_copy[i])
-- 
2.39.5



