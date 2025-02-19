Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0991C1F0D;
	Wed, 19 Feb 2025 09:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956627; cv=none; b=Gt90Cdb25LLm5QK9Dz+aBgO/Vv/f8oiHL+dfAvzONUYwkkYKlcPQZv+Dwe5hmVg4EMSfeaoflswlAdQ1yXPmsL1yu0+3ErZudUA/MXM4XtOFRYREKPJSV7dPtLo9Q2dMnBiYPTxu6Bjiq7HlEN0p6kxAVRD26G/SNsPHgfcps7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956627; c=relaxed/simple;
	bh=Z0zK9yTxotPgO01ey+H891mWd+V8dHpFSgqCjHwKtm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJ1GjyyJpJ6UYPHnhLfzAA9ZMYgXqpC00T7KwJH0c0BiTqTTz4cmA7Tdy5gTNDL36Yqht7x4vfYMBUnL3YWzIk3NY844xZdf/YV9Pdfahu7qUOuktBi/qNvUAV3RMwg8Px7eGwqtaGdCGMbDkedyCo0Q3eoWBC8Nma/m4i0dQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YiVGiJB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YiVGiJB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CF9C4CEE6;
	Wed, 19 Feb 2025 09:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956625;
	bh=Z0zK9yTxotPgO01ey+H891mWd+V8dHpFSgqCjHwKtm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YiVGiJBhuiL+IQ67VMZAl4xCwj+2l7WeBOsO/r5G/f4wOYVuIVs64CwT/ku15Fq+
	 Z3Pk4nb2TlyUmL7rL6WxmA+hbo88NfmgMR2rTyUtO5L9sw+afXI8k0HsmBnIWjaLhc
	 RT4O9enYoXhAl7EffxYihU2sbXJdkwTPDNtraF2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@huawei.com>,
	Brian Cain <bcain@quicinc.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/578] hexagon: Fix unbalanced spinlock in die()
Date: Wed, 19 Feb 2025 09:24:06 +0100
Message-ID: <20250219082702.555498895@linuxfoundation.org>
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



