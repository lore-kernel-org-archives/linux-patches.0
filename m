Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93803155333;
	Wed,  5 Feb 2025 15:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768480; cv=none; b=QziXA0ZxFcwkiVMQJWd4QXSU0zjYZAUCsetFT9i2I/HJIPLM2R7rQnngIgLbJIcMBUm1V/FhOhdf04JeFGpKrPuuRB4N1/Vt9oy/nH8+6vkr84g4ysdAMkK1wZ2uETbhUryokq2ktK51jA0JoPJwyKYZc/t7oWA5OUJleI6Yyi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768480; c=relaxed/simple;
	bh=S5UVSZiE5Jv2p/5UwkEHmGQM48yyJpPKE2YFOkIs+Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST9Rx69CpmDJHKKJvc+uut3NyEdXgq4m3MehWm6cVjJtZaI1Q7g1VxIZzmJqqtsBLDUQyfOjfXTeAyYbyJ61Lwdv5Kkq4KGx8/giDF8hNlhM4aYsW2NKoCCPYvAXVwFUtuPHMB8b3SYZm9cY7hlE/aEGpkfPslLRWezO07WpU6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBY3+yeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBY3+yeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EBBC4CEDD;
	Wed,  5 Feb 2025 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768480;
	bh=S5UVSZiE5Jv2p/5UwkEHmGQM48yyJpPKE2YFOkIs+Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBY3+yeGGx8p24lBoDfj2VBVwfLW6TgiuvVQeS526Rvvx8THnyUMiC30vprAdeMZb
	 DdAnlh6xFiCP7KEFNUHAo/DT0sAktPlFZDLZ0gofVVrSd92/0YspCYtKaHiUgzsf+d
	 TM9ZX732RVwBapB1PSEUyJEVWMjMTG2jWkhT3gl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@huawei.com>,
	Brian Cain <bcain@quicinc.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 569/623] hexagon: Fix unbalanced spinlock in die()
Date: Wed,  5 Feb 2025 14:45:11 +0100
Message-ID: <20250205134517.985631605@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 75e062722d285..040a958de1dfc 100644
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



