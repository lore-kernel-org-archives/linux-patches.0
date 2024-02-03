Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E668211188;
	Sat,  3 Feb 2024 04:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933489; cv=none; b=u2sXu1G/72+6Bm+oHiuFWv8J4ubVdo9DOgOeQXrDf/ufs+ku8YBl7KbXHN2oTYMFFFui3d5W2HCnCrnOB7PNV9M1BEY/hjBo8npLeciS+wVGvr5Vi4LmjW0v5tYNLLfT1dyob6nNETwlpcN3VcaGTEe2jLYbJ22v4KSWjQp2WFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933489; c=relaxed/simple;
	bh=q5+Q73moqHqY0MnSPCskU2xd90K0VerNRDMF0EYY65k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhVQgy/DmUlKLZMSV9UVNlOKPhjVrNGTE3gx6uwcvrW/Q3qtJXL1YSlRx53XoX6X800co+5gzj934oLvyAdzwSP1gfGSw7SDMhLPJstKq/eY2lVDowUMfvHlqwnUcpJ0K3G5vQSRbv3v21WYtAdxA8bk9GOw/9E7Lpo08SOkguI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMa5jcE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMa5jcE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0341C43390;
	Sat,  3 Feb 2024 04:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933488;
	bh=q5+Q73moqHqY0MnSPCskU2xd90K0VerNRDMF0EYY65k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMa5jcE7qqx3A6GcB8qNbVVW4jYXS9G0AgiKFkigdJrdJeUSN5fWwUJdSAWeHLOTo
	 jvAQ6Smj3xz16HXrisADd4M4BljYdX6P+vy6kSQ1F1m3Rk++ZEtPcjH3c8psuTV7sZ
	 ek+wXxO+hBSuEbV7tt2XTtcZwuGsYO6S1zaYhlsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/322] powerpc: Fix build error due to is_valid_bugaddr()
Date: Fri,  2 Feb 2024 20:01:43 -0800
Message-ID: <20240203035359.257636440@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit f8d3555355653848082c351fa90775214fb8a4fa ]

With CONFIG_GENERIC_BUG=n the build fails with:

  arch/powerpc/kernel/traps.c:1442:5: error: no previous prototype for ‘is_valid_bugaddr’ [-Werror=missing-prototypes]
  1442 | int is_valid_bugaddr(unsigned long addr)
       |     ^~~~~~~~~~~~~~~~

The prototype is only defined, and the function is only needed, when
CONFIG_GENERIC_BUG=y, so move the implementation under that.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231130114433.3053544-2-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/traps.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index fe3f720c9cd6..2de7f6dcd32b 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1439,10 +1439,12 @@ static int emulate_instruction(struct pt_regs *regs)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_GENERIC_BUG
 int is_valid_bugaddr(unsigned long addr)
 {
 	return is_kernel_addr(addr);
 }
+#endif
 
 #ifdef CONFIG_MATH_EMULATION
 static int emulate_math(struct pt_regs *regs)
-- 
2.43.0



