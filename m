Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEB61DAC95;
	Wed,  5 Feb 2025 14:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766476; cv=none; b=Yki1Aw0blSBsd/Dv7eyJxEAahwSAczT7NC6C0d7SUmDoD0Dx23NeKFBn9cw0/htr5Y/JWa7PoEW7GwyK21vbQVFyts4EbF5JzwHduUIRHqIkxzXBwQ7i+cxsISfY4vA3nhZ8jnm8DBCJnDoAvlCjzUdIf7Gsmf9KZ39j7uMAvaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766476; c=relaxed/simple;
	bh=qCB8RtvLgEkid4ibqKk8OYgD1F0vFulKBpRFuAFOFjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjJaqP+O4bo46lz6ksVD0sSggOKj6XzPDQ2JG6u8GDRcLZcONH9sNn7UpwKDP/g2/a2+CfJIvFg+bKBW2SBXmDg6j/88Tbka8zT42tghQtdHKWiim+GAJXuCzI1Wvhi4XaP53mrnf+EZzygIewmW9x2Djwud0rw41UyzlmyBGGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYTlhbUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYTlhbUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E1BC4CEDD;
	Wed,  5 Feb 2025 14:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766476;
	bh=qCB8RtvLgEkid4ibqKk8OYgD1F0vFulKBpRFuAFOFjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYTlhbUh0GLkk2RBfwVFrS5+p0IRj7R7SUH8lB/fPkh4l69COqpXwH0Gf8rYXm1mN
	 Qo+TzaUyMDLy1fsXuUXVwk5bGXEjDklNNnKEj/ZBPQfx6ateZle32Tob1FVyjAEGqQ
	 TEjZdQxejIqUhP66yxg2wLkEnEQsSk/hEiMe1Tts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@huawei.com>,
	Brian Cain <bcain@quicinc.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 366/393] hexagon: Fix unbalanced spinlock in die()
Date: Wed,  5 Feb 2025 14:44:45 +0100
Message-ID: <20250205134434.305241064@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Yujun <linyujun809@huawei.com>

[ Upstream commit 03410e87563a122075c3721acc7d5510e41d8332 ]

die executes holding the spinlock of &die.lock and unlock
it after printing the oops message.
However in the code if the notify_die() returns NOTIFY_STOP
, die() exit with returning 1 but never unlocked the spinlock.

Fix this by adding spin_unlock_irq(&die.lock) before returning.

Fixes: cf9750bae262 ("Hexagon: Provide basic debugging and system trap support.")
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Link: https://lore.kernel.org/r/20230522025608.2515558-1-linyujun809@huawei.com
Signed-off-by: Brian Cain <bcain@quicinc.com>
Signed-off-by: Brian Cain <brian.cain@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/kernel/traps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index 6447763ce5a94..b7e394cebe20d 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -195,8 +195,10 @@ int die(const char *str, struct pt_regs *regs, long err)
 	printk(KERN_EMERG "Oops: %s[#%d]:\n", str, ++die.counter);
 
 	if (notify_die(DIE_OOPS, str, regs, err, pt_cause(regs), SIGSEGV) ==
-	    NOTIFY_STOP)
+	    NOTIFY_STOP) {
+		spin_unlock_irq(&die.lock);
 		return 1;
+	}
 
 	print_modules();
 	show_regs(regs);
-- 
2.39.5



