Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0CC7CF0B;
	Wed, 21 Feb 2024 13:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522302; cv=none; b=UV9edF12ajukkjMnTyKyZCxZoEXrv4RWvMI6IHk2UbTuGSTcLkyHHKZ51k+xQG7hRNYV7Xs5bXqoPytvj7TMBF0gCPqrU212qFOIEjRWtKyH+YMVEY5ltQX6rMZDlmxT3/2xF7MFxxPWoAmFVGzCmonVUEzdtBKqlUPjxzjcNw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522302; c=relaxed/simple;
	bh=PaxuO6nlXzLHBlttzWS+KDO/lNhrWNqzkkG9IrYBk80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ujWY8btBL7c9y/FxnLu+xVjGTaop9yKJA2PbGt3MsoICcNAdpt4EKBahAcjNml8uMh3JN0Wi6svrYxHmk9jR9tloWL0JH9hJSCetTSqvQKRNmyKCZZdAzeRnlqSkdTG15gVQdC39U4djJfqMz7WaEfZeUPz0yXfZaHtAVdgfT8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNz73cWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNz73cWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6FAC433F1;
	Wed, 21 Feb 2024 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522299;
	bh=PaxuO6nlXzLHBlttzWS+KDO/lNhrWNqzkkG9IrYBk80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNz73cWkqHE34HpF4fTUmnqxonAiDRw+4DJMHKTci8nJF3dXTFB2hc/OJEcW81+YJ
	 XiMZ+c5fpUoN4S3PNQX4o4jhQbCMQkMpowDkMsIkNjRePurbwiibKfd1dugKD9P+fz
	 o+NhZ2dYiL7pYg5ppXnFyLjNlBRAsR2gYX3cpfcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 128/476] powerpc: Fix build error due to is_valid_bugaddr()
Date: Wed, 21 Feb 2024 14:02:59 +0100
Message-ID: <20240221130012.696866274@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fe912983ced9..f1a2a75c4757 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1423,10 +1423,12 @@ static int emulate_instruction(struct pt_regs *regs)
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



