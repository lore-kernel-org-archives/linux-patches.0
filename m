Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977ECF9E4;
	Sat,  3 Feb 2024 04:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933317; cv=none; b=DBOmotHXaFTgfbwfydsjEccC4PlNmxOHzYj3xnqxUClN31K8xzB2Py+2TAvdb5i5e0VZyhNh56k4aX4IhOR+c+q43tegdH/nulNG95ctP03rVhUY4SbZlwtmcI2dZKH4EuVhRYCGcwOrrXmnLcbMVcJ4bWTV9o6pAQr/U4AhJhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933317; c=relaxed/simple;
	bh=r86nZ1LGZCy2S87YeEgftaiWmxSdEzQN+OuQskVDMjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8chzsxSy1lJWc/g61piwf0E+MzK7zweuYoN7bSIBdsFWhjEaW9+iwCDBpvxEzGATivmlfW/pPqKiDLY05eBc/Rbfaja5A5nsh0WEfF3i7YHp8QRmGdVGU+mUMF4p2U2yEGxJ4bXYmmWkl/s239GtjevJreowDq3cMWowkAN+QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puZKa1ZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puZKa1ZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7C4C43394;
	Sat,  3 Feb 2024 04:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933317;
	bh=r86nZ1LGZCy2S87YeEgftaiWmxSdEzQN+OuQskVDMjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puZKa1ZO/fF2FtkBhqJ68gKeIcv2c2VGzzfXuG6dBJ/663AgeIGjcDzUXhPpLTnTP
	 004m6goea7mTHvVChoPAFHWgHWe7Iywjm3ZmxXter2ifopFdLmeggEiR793Wyz4Mhy
	 ATTMAMtjodOtki8ybR3eF8yISTAW481X6ftikkC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/219] powerpc/lib: Validate size for vector operations
Date: Fri,  2 Feb 2024 20:03:03 -0800
Message-ID: <20240203035318.280367435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen N Rao <naveen@kernel.org>

[ Upstream commit 8f9abaa6d7de0a70fc68acaedce290c1f96e2e59 ]

Some of the fp/vmx code in sstep.c assume a certain maximum size for the
instructions being emulated. The size of those operations however is
determined separately in analyse_instr().

Add a check to validate the assumption on the maximum size of the
operations, so as to prevent any unintended kernel stack corruption.

Signed-off-by: Naveen N Rao <naveen@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Build-tested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231123071705.397625-1-naveen@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/sstep.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index 398b5694aeb7..ec30af8eadb7 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -586,6 +586,8 @@ static int do_fp_load(struct instruction_op *op, unsigned long ea,
 	} u;
 
 	nb = GETSIZE(op->type);
+	if (nb > sizeof(u))
+		return -EINVAL;
 	if (!address_ok(regs, ea, nb))
 		return -EFAULT;
 	rn = op->reg;
@@ -636,6 +638,8 @@ static int do_fp_store(struct instruction_op *op, unsigned long ea,
 	} u;
 
 	nb = GETSIZE(op->type);
+	if (nb > sizeof(u))
+		return -EINVAL;
 	if (!address_ok(regs, ea, nb))
 		return -EFAULT;
 	rn = op->reg;
@@ -680,6 +684,9 @@ static nokprobe_inline int do_vec_load(int rn, unsigned long ea,
 		u8 b[sizeof(__vector128)];
 	} u = {};
 
+	if (size > sizeof(u))
+		return -EINVAL;
+
 	if (!address_ok(regs, ea & ~0xfUL, 16))
 		return -EFAULT;
 	/* align to multiple of size */
@@ -707,6 +714,9 @@ static nokprobe_inline int do_vec_store(int rn, unsigned long ea,
 		u8 b[sizeof(__vector128)];
 	} u;
 
+	if (size > sizeof(u))
+		return -EINVAL;
+
 	if (!address_ok(regs, ea & ~0xfUL, 16))
 		return -EFAULT;
 	/* align to multiple of size */
-- 
2.43.0



