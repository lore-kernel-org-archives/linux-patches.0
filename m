Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C082139B2;
	Thu, 12 Dec 2024 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016117; cv=none; b=AQG2tdit2lswFQ9yRJ9UZM81E+qi2r4DUvVm+L2AMW/Egr1ub+PjUj1b+Ug6MU2Ct7tp1Ay43L6c53PqkYGVSUAIwzrl5XFalmiVFWgkrM4Fw9+s1c6x9v78seRsOWwgCoWMD4sA6561j2ruT770Y/aYdBCpbFVLtoAFUM/8q24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016117; c=relaxed/simple;
	bh=6wnUgyBA2RE/avQYIak0Gk5U7+UF0V0h2C8LpOzhnJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfYnxGDvIlsmGqEP/aPIGPkl6lG2w74V+Hrkq78NftfVbjz6TPdvrZxVULfRzvsNuop9SO8lRCknhKRPssCzIIf0LYk9f36ZohY0JnF81fuRbElP70JIry3bB7fZgxlRyyI9fA7Td1GKN7rqWtcH/4d6Z2VWPT7Sco1v2CX1Fqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NluXTxVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NluXTxVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD70C4CECE;
	Thu, 12 Dec 2024 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016117;
	bh=6wnUgyBA2RE/avQYIak0Gk5U7+UF0V0h2C8LpOzhnJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NluXTxVbTzme7Dx1r088EPNdWJ2EQuRolwmE887qh7LIK4lcrgAqL2MKoPGPH2jaS
	 KSyKbqT4GvqP4s1SdUqcMH14E7hXhaZQFMtjMGCXhYhTRg30Pu8UyLcTpyisCOZj7o
	 5GeJCqDIYTT3xjvenasGi1TUVczPlZNKHJ4yZPb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 138/466] arm64: ptrace: fix partial SETREGSET for NT_ARM_POE
Date: Thu, 12 Dec 2024 15:55:07 +0100
Message-ID: <20241212144312.253529951@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 594bfc4947c4fcabba1318d8384c61a29a6b89fb upstream.

Currently poe_set() doesn't initialize the temporary 'ctrl' variable,
and a SETREGSET call with a length of zero will leave this
uninitialized. Consequently an arbitrary value will be written back to
target->thread.por_el0, potentially leaking up to 64 bits of memory from
the kernel stack. The read is limited to a specific slot on the stack,
and the issue does not provide a write mechanism.

Fix this by initializing the temporary value before copying the regset
from userspace, as for other regsets (e.g. NT_PRSTATUS, NT_PRFPREG,
NT_ARM_SYSTEM_CALL). In the case of a zero-length write, the existing
contents of POR_EL1 will be retained.

Before this patch:

| # ./poe-test
| Attempting to write NT_ARM_POE::por_el0 = 0x900d900d900d900d
| SETREGSET(nt=0x40f, len=8) wrote 8 bytes
|
| Attempting to read NT_ARM_POE::por_el0
| GETREGSET(nt=0x40f, len=8) read 8 bytes
| Read NT_ARM_POE::por_el0 = 0x900d900d900d900d
|
| Attempting to write NT_ARM_POE (zero length)
| SETREGSET(nt=0x40f, len=0) wrote 0 bytes
|
| Attempting to read NT_ARM_POE::por_el0
| GETREGSET(nt=0x40f, len=8) read 8 bytes
| Read NT_ARM_POE::por_el0 = 0xffff8000839c3d50

After this patch:

| # ./poe-test
| Attempting to write NT_ARM_POE::por_el0 = 0x900d900d900d900d
| SETREGSET(nt=0x40f, len=8) wrote 8 bytes
|
| Attempting to read NT_ARM_POE::por_el0
| GETREGSET(nt=0x40f, len=8) read 8 bytes
| Read NT_ARM_POE::por_el0 = 0x900d900d900d900d
|
| Attempting to write NT_ARM_POE (zero length)
| SETREGSET(nt=0x40f, len=0) wrote 0 bytes
|
| Attempting to read NT_ARM_POE::por_el0
| GETREGSET(nt=0x40f, len=8) read 8 bytes
| Read NT_ARM_POE::por_el0 = 0x900d900d900d900d

Fixes: 175198199262 ("arm64/ptrace: add support for FEAT_POE")
Cc: <stable@vger.kernel.org> # 6.12.x
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241205121655.1824269-4-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1469,6 +1469,8 @@ static int poe_set(struct task_struct *t
 	if (!system_supports_poe())
 		return -EINVAL;
 
+	ctrl = target->thread.por_el0;
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &ctrl, 0, -1);
 	if (ret)
 		return ret;


