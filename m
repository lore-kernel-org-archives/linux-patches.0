Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D59A1EEE3;
	Tue, 23 Jan 2024 00:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968264; cv=none; b=KCnP2xChZ1XLfbT1EGfRCOMQt9Y9OOVt8QdozarHeSw+KWI2YjIazuoGNIhITlqBUXv17Q8wBcpMl680mQGe8qMn/3KGOF5pvDmIT8Fn1aBfBTvNmqtWD6/+lUCRmxoEThHOfR8zBR02wXk4hrzfTUvFjv6HSWOrtaZV06xaEUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968264; c=relaxed/simple;
	bh=z1N8PbS9FQHTQt2/7unhOyQukbjBBl2daMbMb+Cqmwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bW2QhjPHUazGRT76aZTFS6ndgmUxk7pSu3ySrKIkUnL1GETZeidLDTYRVwKt3new3JMAfa3Bqw+Qf0k4CoJUZNoDodZEpCAAgAkHxSghRhkblgmCSbTjeriV6sWbq0dMeflZdL8Ev3mkhTKQxDxYtw9IElNARX7P7jrzT/gVYmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gx5kA+tA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gx5kA+tA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFC6C433C7;
	Tue, 23 Jan 2024 00:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968264;
	bh=z1N8PbS9FQHTQt2/7unhOyQukbjBBl2daMbMb+Cqmwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gx5kA+tAYfT23YzsoMQT2KH6Sy3DSrHCRjVlaAn4DmuHXrx1jQ3lIVk2n1Lx3r+aO
	 D7kXKP+7QYn/51f7viHHDCvfh7BbEFoDsEZGMVHZK4P5O/3W4uGHRldayVZL+cn3+x
	 vIluu3hV25FNTdf+9r87a1EF+V/1xCROq86EUCEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 019/148] ARC: fix spare error
Date: Mon, 22 Jan 2024 15:56:15 -0800
Message-ID: <20240122235713.203499044@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vineet Gupta <vgupta@kernel.org>

[ Upstream commit aca02d933f63ba8bc84258bf35f9ffaf6b664336 ]

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312082320.VDN5A9hb-lkp@intel.com/
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/kernel/signal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/signal.c b/arch/arc/kernel/signal.c
index 68901f6f18ba..c36e642eb1a0 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -64,7 +64,7 @@ struct rt_sigframe {
 	unsigned int sigret_magic;
 };
 
-static int save_arcv2_regs(struct sigcontext *mctx, struct pt_regs *regs)
+static int save_arcv2_regs(struct sigcontext __user *mctx, struct pt_regs *regs)
 {
 	int err = 0;
 #ifndef CONFIG_ISA_ARCOMPACT
@@ -77,12 +77,12 @@ static int save_arcv2_regs(struct sigcontext *mctx, struct pt_regs *regs)
 #else
 	v2abi.r58 = v2abi.r59 = 0;
 #endif
-	err = __copy_to_user(&mctx->v2abi, &v2abi, sizeof(v2abi));
+	err = __copy_to_user(&mctx->v2abi, (void const *)&v2abi, sizeof(v2abi));
 #endif
 	return err;
 }
 
-static int restore_arcv2_regs(struct sigcontext *mctx, struct pt_regs *regs)
+static int restore_arcv2_regs(struct sigcontext __user *mctx, struct pt_regs *regs)
 {
 	int err = 0;
 #ifndef CONFIG_ISA_ARCOMPACT
-- 
2.43.0



