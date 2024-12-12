Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327FF2139B2;
	Thu, 12 Dec 2024 15:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016114; cv=none; b=RciivQK+Fq9yMI0MU8VGT6Z+8iNo7G0amsC3a6uy5jTk/o8RWv/6woeZYyZdxGBCcSpjKPyS4ug5eLiokh7/Xut2A/2nTMB1Rv/6qasiNzJ7OGvMKx0hEzJV8Ou+DrE47Cz0sLTA4Sp0Hf4CK+c1vMJA02n6BC+25Jwcj2pLHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016114; c=relaxed/simple;
	bh=x+Z1rFqlgZC1faQkyFojAewLmwlYSIf6rLlrD+UoD/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bev0GNHE3kHO9FG4JOaxlWbB00NlkJPuAAcrKlwluJlNLRa7wAsE5DQk7cySXt23R3Mi72UzAuxfZjZiYCFIq7fUlAHhLfonb2kwmkj3GLJRLGGW/W+bMgufThTRaeGBkK65Q5eJTJR0FesyacGiwxAGNMcqY1PxHJWWAUOF3M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhtYXgnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhtYXgnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19C7C4CED0;
	Thu, 12 Dec 2024 15:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016114;
	bh=x+Z1rFqlgZC1faQkyFojAewLmwlYSIf6rLlrD+UoD/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhtYXgnHe6/ttTt0Fl01UQRg/XHGwVt064XA3XkOgtzd4PzrpLpFlepXzuhIqCeHq
	 CBSKz4zKPxRfkTU9qyUIZSQWozPEkU/2SuVpvQJQKNSZW5ag6WGZQJtehR3GG60204
	 GWBOLTtUdn9OQpV+7BdDjMrbrKU7vbg8ez2py3s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 137/466] arm64: ptrace: fix partial SETREGSET for NT_ARM_FPMR
Date: Thu, 12 Dec 2024 15:55:06 +0100
Message-ID: <20241212144312.214725297@linuxfoundation.org>
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

commit f5d71291841aecfe5d8435da2dfa7f58ccd18bc8 upstream.

Currently fpmr_set() doesn't initialize the temporary 'fpmr' variable,
and a SETREGSET call with a length of zero will leave this
uninitialized. Consequently an arbitrary value will be written back to
target->thread.uw.fpmr, potentially leaking up to 64 bits of memory from
the kernel stack. The read is limited to a specific slot on the stack,
and the issue does not provide a write mechanism.

Fix this by initializing the temporary value before copying the regset
from userspace, as for other regsets (e.g. NT_PRSTATUS, NT_PRFPREG,
NT_ARM_SYSTEM_CALL). In the case of a zero-length write, the existing
contents of FPMR will be retained.

Before this patch:

| # ./fpmr-test
| Attempting to write NT_ARM_FPMR::fpmr = 0x900d900d900d900d
| SETREGSET(nt=0x40e, len=8) wrote 8 bytes
|
| Attempting to read NT_ARM_FPMR::fpmr
| GETREGSET(nt=0x40e, len=8) read 8 bytes
| Read NT_ARM_FPMR::fpmr = 0x900d900d900d900d
|
| Attempting to write NT_ARM_FPMR (zero length)
| SETREGSET(nt=0x40e, len=0) wrote 0 bytes
|
| Attempting to read NT_ARM_FPMR::fpmr
| GETREGSET(nt=0x40e, len=8) read 8 bytes
| Read NT_ARM_FPMR::fpmr = 0xffff800083963d50

After this patch:

| # ./fpmr-test
| Attempting to write NT_ARM_FPMR::fpmr = 0x900d900d900d900d
| SETREGSET(nt=0x40e, len=8) wrote 8 bytes
|
| Attempting to read NT_ARM_FPMR::fpmr
| GETREGSET(nt=0x40e, len=8) read 8 bytes
| Read NT_ARM_FPMR::fpmr = 0x900d900d900d900d
|
| Attempting to write NT_ARM_FPMR (zero length)
| SETREGSET(nt=0x40e, len=0) wrote 0 bytes
|
| Attempting to read NT_ARM_FPMR::fpmr
| GETREGSET(nt=0x40e, len=8) read 8 bytes
| Read NT_ARM_FPMR::fpmr = 0x900d900d900d900d

Fixes: 4035c22ef7d4 ("arm64/ptrace: Expose FPMR via ptrace")
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241205121655.1824269-3-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/ptrace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -719,6 +719,8 @@ static int fpmr_set(struct task_struct *
 	if (!system_supports_fpmr())
 		return -EINVAL;
 
+	fpmr = target->thread.uw.fpmr;
+
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &fpmr, 0, count);
 	if (ret)
 		return ret;


