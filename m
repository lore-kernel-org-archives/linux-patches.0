Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E361FFBE4;
	Sat,  3 Feb 2024 04:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933740; cv=none; b=uu+R0ZbM3jpGIArShCJZur0vyLd0WdOj8dURo5TTnFBt+XaWdqAYlOcEaw9sWwVUZIZg8v60GcwiFWmeRXaJUjceNjntxnUTI2IacmTkrHxHxfDD3KVbAxNJX/bDtH4O1YE974qYZU4ZBPs1cEIMJ5dj+l2f9EnolwdUyHNSWyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933740; c=relaxed/simple;
	bh=icpO5cR0AzFbgPCF1a1OSplnip58I0cFsrrEJFTFpBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JrvhWpP8xb0vWkdpiMj/JXpbQVU56TKcKe4kYJ47MN13+LLGNa44rS7QJraEvXBtyOxwvJXDjBsb+BZ+Exo8hAMMpcFKF2b4hHtEjZBWER7QZOyvGQCXQ2QCSkwB3eLZAXXikSXcLEMk0gOkKb0mUicygeBV2orH6Al4Ijm7Qrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/COge+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/COge+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A39FC433F1;
	Sat,  3 Feb 2024 04:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933739;
	bh=icpO5cR0AzFbgPCF1a1OSplnip58I0cFsrrEJFTFpBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/COge+jAGhG71dVsp7Z7fqVbF6YcUHof9ENzYRExmJikjH663gxEd7ijT2VI9SRb
	 /WWKMWDBQcXWRA9MWLkkkR8YbhGZKcMCn7xGgXT8tRUJr/VZJNU2Kk5Erdbai8vK5B
	 x/xhqASb2//rek+ZJ0OUfMlmYSg7p9IZ5eFFtbRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 005/353] powerpc: Fix build error due to is_valid_bugaddr()
Date: Fri,  2 Feb 2024 20:02:03 -0800
Message-ID: <20240203035403.849817988@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 5ea2014aff90..11e062b47d3f 100644
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



