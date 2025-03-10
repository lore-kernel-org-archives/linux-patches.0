Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C0A17CA12;
	Mon, 10 Mar 2025 17:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629215; cv=none; b=KfBGo8FvLDx1qjFct6Vx8zABn+vTWrpfwKcNpkG2XnnuaJbuXIpejIxatwrZgWiyOP8xOAidNcFN1y0ZVrQPuCfBRrnL0E7hTgSzT4U4MEnf2JeMdtfD2PPoiyybFPPARAZls3OyAoeW48eGVlr9N5Xazw4Fq02Pj71RjjWEiio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629215; c=relaxed/simple;
	bh=5I0wGFA0hXQrOhO7mTfLQqNhuu3bE1zM3MAZ2cFXUjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qN2cU84behJu5ATAdhf5dLj1u/chBAG8yjPnTJ40b99uJd4lDAZMlCEq7FTbRxFHeI41tcwxVwQtxwXDOPXXrFHX1yrGSZ44tlUT5gN9MVikz2A3d29vWNrNRZtmxEExK8nljhIgtTlbdjx5YNkdzJkvhW8mNMNmS4D2jf8PArI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3XxJdz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3XxJdz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646AFC4CEE5;
	Mon, 10 Mar 2025 17:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629215;
	bh=5I0wGFA0hXQrOhO7mTfLQqNhuu3bE1zM3MAZ2cFXUjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3XxJdz8VsASJ8eWqZb5BNAMeXbZyXWYzi/S6tAgg/h8OP4rSk0g3rU8ck6zKVXBL
	 ZxklvxbV1ncbNrT38eIQn4JD+KAmg2civK8ihXoq8TpxHQvVaGPh0DH5cx0F8ADuo9
	 +x4yW5RiPIvgnl2LKFaPdw+4yanN5rpQ+zqYRNUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@huawei.com>,
	Brian Cain <bcain@quicinc.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/620] hexagon: Fix unbalanced spinlock in die()
Date: Mon, 10 Mar 2025 18:00:31 +0100
Message-ID: <20250310170552.936099201@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1240f038cce02..7aca1c329f944 100644
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



