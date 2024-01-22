Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B89B129A63;
	Tue, 23 Jan 2024 00:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968745; cv=none; b=q1D1FF95EVuLTJ4O2Re0XjL2fJMeT7hDtVMe+egfYQahcoVd2VS9YlpDdKOoWdg1kZHct8QEgkk8/mO/jKNa0CcL0MO8SITAdYCIjNKNIcn2JjD57+vfhKHndYlJ2AQUzusX8g1M9fezuN/WBtFqEYpoUhJF6rhJEb+vatffyFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968745; c=relaxed/simple;
	bh=k2mgAJKZFk2qFilPh9p0ufAESElJ5MHnMiziPfrUPpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKEMo6sPZyHPNMjSLQhKxVu5nNAxFDhD/jU2+FXv7ATMDoAz/+BsMy8OSJhijd3Hhf9DI30x1pig8nODZFWMcf8GjauCUcpOti94K+RJp86iEmaECnpvGG5+VqWArAsTxGHtJ+Qnc7njexmy6gbe9zW8NwZvI7DEM3+KiDm20Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fvUnlwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fvUnlwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCFFC43390;
	Tue, 23 Jan 2024 00:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968744;
	bh=k2mgAJKZFk2qFilPh9p0ufAESElJ5MHnMiziPfrUPpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1fvUnlwEufutLdOFHr7Sh0C6XBvjmbw2NxqNnLeO2M44qkfB9oSREhz09AbEE/dWm
	 hLBX0gW61uOeALBTz81K4nZS2vYZMO/9GHejc/jRhEz7czw/cHvv1vCGjUVQUhNw/y
	 jW5jkXXZtZkZ5SWY2o7zVIIjg9EwOp+W/Sh9wRJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/194] ARC: fix spare error
Date: Mon, 22 Jan 2024 15:55:57 -0800
Message-ID: <20240122235720.378976418@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8877de0dfe6c..2759d49a2f3a 100644
--- a/arch/arc/kernel/signal.c
+++ b/arch/arc/kernel/signal.c
@@ -61,7 +61,7 @@ struct rt_sigframe {
 	unsigned int sigret_magic;
 };
 
-static int save_arcv2_regs(struct sigcontext *mctx, struct pt_regs *regs)
+static int save_arcv2_regs(struct sigcontext __user *mctx, struct pt_regs *regs)
 {
 	int err = 0;
 #ifndef CONFIG_ISA_ARCOMPACT
@@ -74,12 +74,12 @@ static int save_arcv2_regs(struct sigcontext *mctx, struct pt_regs *regs)
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



