Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6B813AC0;
	Sat,  3 Feb 2024 04:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933743; cv=none; b=r1N1Yp8C46CTeDPhlb/YA+bT6aJRrHO57jbWmZwR5xee+aP/0Ki9Zbtn0l+CEkhCMhwF1j9pQK5ihW2torXGPDDgQGFwVviT+Ng/ITxhHnV+yIkjaHIRY9u7xfi0dnUWhme9dctNvF/9o/PnSEXgG0bmTdZvQJbxyshEuQzVfK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933743; c=relaxed/simple;
	bh=pcCDs8dFfAA9+H6tBjeqVMn7eda9155YEHOVCDQnXgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDpuhi17zjC+2Iiax4GwpVgdbEN3bKrKNzUx87RoFpAhqYUlA6DYaeA7kMmIWXXnOSMmIJPYFqzyGFr1T9GiNX6MbEWN7QqRC+O/Z5qMIX0I9EcZj4mfTQSdDXNEKLHvuXT0Xx43wpQeFAVuok6nxlfEGoBqOWZoF9s0Q9+h6co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnjdgZC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnjdgZC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C5AC43390;
	Sat,  3 Feb 2024 04:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933742;
	bh=pcCDs8dFfAA9+H6tBjeqVMn7eda9155YEHOVCDQnXgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnjdgZC0fgSnOza5ktJcTUh+s+TUirA72iz5HolH+eU+lokMzVA5SUq5ALRls/Ir3
	 BHHg0IRZIV8TeA/Es1JMxF1k1QcoK/NwPxOUpOGPl8Nvga0NYE+y+fQZmO9W85MumW
	 HU/BsRD1ImDbZSSRW71qZSnihkgrT+0UDB047Q04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 010/353] powerpc/lib: Validate size for vector operations
Date: Fri,  2 Feb 2024 20:02:08 -0800
Message-ID: <20240203035404.032401251@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index a4ab8625061a..6af97dc0f6d5 100644
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



