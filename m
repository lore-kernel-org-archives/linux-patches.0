Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663BDFBFC;
	Sat,  3 Feb 2024 04:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933321; cv=none; b=YJ6agYdg/3/q6kg10DnSNCP/84rda2Gd62IBD1WFYA6OHPXeIT5OXs16v/whaHLLHEmsS2tBFFyr8gTr3AKKfOn+7k0R8IU2Ytlxb3jsFKcUlvRVfzwoveG+9IbZ1qj+IVR/UzV2rDPTK5Gd88YpWNxlin3U2rxecoDqYgbZOIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933321; c=relaxed/simple;
	bh=KWJJFYzHvIE00gTojg26mxZI7zU5Ten2PTIwWxG5Fhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CEMhttQtP4qlQO5aBOJLr68FSDLfUDAFZta2/V1+e0hYbb5TMArpHe+yCZtThfD9ctLKhenqcQV1otF56DK7dvnyqY0BYljPlEI5go7UwtG9KvkGPr73hnomef33mYtMbtK4V8+zM6QzusrZvx1FHRnPFciHZJIEN0zNbMzHXeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRJph+mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRJph+mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EE8C433C7;
	Sat,  3 Feb 2024 04:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933320;
	bh=KWJJFYzHvIE00gTojg26mxZI7zU5Ten2PTIwWxG5Fhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRJph+mmHuvwBF6MqPZIzFa/cBvI4G8ApkrNQNfTQuP6ur5PmtnZ97KgTwlvbBgGP
	 QkgS4WyCzMmhqA+bPi0/wzRoGBnbAnIhj7w8HWHJhvrfVu4FGDuIUQPFEtiNwpFf0v
	 F6H4J6F5MoISwngtIxi2v7gu7/jC+vpK5bUvL2Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/219] powerpc: Fix build error due to is_valid_bugaddr()
Date: Fri,  2 Feb 2024 20:02:58 -0800
Message-ID: <20240203035317.840398194@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3956f32682c6..362b712386f6 100644
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



