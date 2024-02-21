Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93C369D29;
	Wed, 21 Feb 2024 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525111; cv=none; b=lk8lWO5UqBztsh1ifvK6VLurK5ewR9rSWJZxOtQFZfhBcw/NO/1/RduplEZ2nQBaz8Y3Y7Mq6Ndf8yQDERPas427ZBrtzElEiZz4ezZ1q68tJF+kVpDTCpk8Wug4JogiiOBxdbTChfSjmk/SJer5AKfExa/FiZlkIGj91zvxXbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525111; c=relaxed/simple;
	bh=Jy8/nesuAKgLH9kMo03NU9GIpWIQUSkqKapEYYg7Ccw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sN7TVKf1vBHr8zaWt9jRzfXlc4F0ONAXPNJCUYZAdK54cIGWKkqoH3k1AbfzuxsQ3I68nPkiMYyBc5BN0S9QohYNDBA1hAkxzWYi3tWSPebKnCKCZ53Ejy8y3U1L5iX4VPMfuQrXZcBI8iaBTEdxIgTMhKEZR1KiF0PXAJftEb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5EEZdq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5EEZdq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54ADC433F1;
	Wed, 21 Feb 2024 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525111;
	bh=Jy8/nesuAKgLH9kMo03NU9GIpWIQUSkqKapEYYg7Ccw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a5EEZdq824wPQl5ZuHL0bzsqwHJ+bcOoMBab4y4BkOXl0HOzu0XtDjyz2sEk2gB+o
	 TToHidL9y7VELXtF1oT8bJfvgwVo9PkLnnVZmBulfxK8fn/w+VC7V3xjdjV29mH2+a
	 9lJnqYKHwlTqQlcrnuBqNj+9368uLwe9g1D47XDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/267] powerpc: Fix build error due to is_valid_bugaddr()
Date: Wed, 21 Feb 2024 14:06:43 +0100
Message-ID: <20240221125941.949843946@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 70b99246dec4..402a05f3a484 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1424,10 +1424,12 @@ static int emulate_instruction(struct pt_regs *regs)
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



