Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E03B78B4B;
	Wed, 21 Feb 2024 13:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523970; cv=none; b=STQZezD5yqnS8g0no3HGobSKaPfQ132SkCplh8GyNCbo128IkJmVlEoSt90QaHuR5HJBpSmdvYAAockLOGDDZCJEOJOnbhQKfdJs2NGXg9ZjORH4P15o9GnT7dtv5bq6nUBQMAei1r2jsYB9xiOZ+HRKHAvGj8HVpu2C5EbVo3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523970; c=relaxed/simple;
	bh=etzVpM5+is26qfrNpKg6/0SeMNIEVBaJdoP32vv/1TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6fz4vltWyC8GPThBmX8k/yQni+o0oQMGC1u/E/Pni75BJiFHSHeDnONZdAeJgwYMsYaMbVrVvy5NDp6a3CwvT6Z274cXoJDvpJkjy2cw+26uWJgcXH2SypHp5jAzW6N3xdvK/2sg31ma2nQd2paPv+yDWusaD9hESGzTojjbK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrZi6emP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrZi6emP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DB2C433C7;
	Wed, 21 Feb 2024 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523970;
	bh=etzVpM5+is26qfrNpKg6/0SeMNIEVBaJdoP32vv/1TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrZi6emP+QAPO617VbiLyy5w/uUVhKRo/42vun7O12ntZCSaq+ZqBjZKQUjwQ0cuh
	 V+AcfP7r3bn6i5eGI+wHTO30wCnI36Vo5sIujKpqICnlss7igkGU0qoMSutFKc7138
	 xw8dNSKDSgWqUFWlPrLBNDI3lW+BHjNSmaVtbyEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen N Rao <naveen@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/379] powerpc/lib: Validate size for vector operations
Date: Wed, 21 Feb 2024 14:04:46 +0100
Message-ID: <20240221125958.087810712@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d19655328f1..ca4733fbd02d 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -512,6 +512,8 @@ static int do_fp_load(struct instruction_op *op, unsigned long ea,
 	} u;
 
 	nb = GETSIZE(op->type);
+	if (nb > sizeof(u))
+		return -EINVAL;
 	if (!address_ok(regs, ea, nb))
 		return -EFAULT;
 	rn = op->reg;
@@ -562,6 +564,8 @@ static int do_fp_store(struct instruction_op *op, unsigned long ea,
 	} u;
 
 	nb = GETSIZE(op->type);
+	if (nb > sizeof(u))
+		return -EINVAL;
 	if (!address_ok(regs, ea, nb))
 		return -EFAULT;
 	rn = op->reg;
@@ -606,6 +610,9 @@ static nokprobe_inline int do_vec_load(int rn, unsigned long ea,
 		u8 b[sizeof(__vector128)];
 	} u = {};
 
+	if (size > sizeof(u))
+		return -EINVAL;
+
 	if (!address_ok(regs, ea & ~0xfUL, 16))
 		return -EFAULT;
 	/* align to multiple of size */
@@ -633,6 +640,9 @@ static nokprobe_inline int do_vec_store(int rn, unsigned long ea,
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



