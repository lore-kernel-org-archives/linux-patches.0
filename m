Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1C71E47A6;
	Mon, 21 Oct 2024 10:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507145; cv=none; b=NvJeA6mw2Bzjx1YE22179cm6NhLXwqnrWfyUQZBGARWDURXppW3VdxwzOVpSHaVd6AkKswx8AqhYmDYYbtH23eI+xp9gA16sYWlqlMFA3CYytIjRsjR8orx2xSiC88yXvEL2iq2CVWHUXxTPYfJDymYOCzXs3IX1Q3Iltjaq740=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507145; c=relaxed/simple;
	bh=kC9f8U6kvT29SEYXaC1wA50oDKXMv2BCsZXMfjV5iyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWuWYRpXSpMjQVDmsJcQgHjWI5DHrcDsxE93K9HVnPc/md1XCC9rjrDPPswL+npTg5Zd7mvW/RnQnXwAHtaEkmxeC64a08EzDHVVG9l0xssV1MFHRvjv+zGxUKasIkoDm927qekYi3j8Og0TEiAmnrHUoQPkU01NLaxz0N2MBtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14PS9Dl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14PS9Dl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D268C4CEC3;
	Mon, 21 Oct 2024 10:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507144;
	bh=kC9f8U6kvT29SEYXaC1wA50oDKXMv2BCsZXMfjV5iyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14PS9Dl33NXm+vg6RuJWI3985A5xvW91pGldroajLCgUHrt/Und7355+pGPVKhlR2
	 NVhqH3lDIjvUt5Zblnui/ITXAVZhiAmGqp3Y7Ca2dgBtBICDIqVOqhdsKghBau/42/
	 LBtdepEdTKSFGL6vA5mZK00uMDpuuhryF7Tiosro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Allen <john.allen@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.6 105/124] x86/CPU/AMD: Only apply Zenbleed fix for Zen2 during late microcode load
Date: Mon, 21 Oct 2024 12:25:09 +0200
Message-ID: <20241021102300.779703805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Allen <john.allen@amd.com>

commit ee4d4e8d2c3bec6ee652599ab31991055a72c322 upstream.

Commit

  f69759be251d ("x86/CPU/AMD: Move Zenbleed check to the Zen2 init function")

causes a bit in the DE_CFG MSR to get set erroneously after a microcode late
load.

The microcode late load path calls into amd_check_microcode() and subsequently
zen2_zenbleed_check(). Since the above commit removes the cpu_has_amd_erratum()
call from zen2_zenbleed_check(), this will cause all non-Zen2 CPUs to go
through the function and set the bit in the DE_CFG MSR.

Call into the Zenbleed fix path on Zen2 CPUs only.

  [ bp: Massage commit message, use cpu_feature_enabled(). ]

Fixes: f69759be251d ("x86/CPU/AMD: Move Zenbleed check to the Zen2 init function")
Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240923164404.27227-1-john.allen@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/amd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1374,7 +1374,8 @@ void amd_check_microcode(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return;
 
-	on_each_cpu(zenbleed_check_cpu, NULL, 1);
+	if (cpu_feature_enabled(X86_FEATURE_ZEN2))
+		on_each_cpu(zenbleed_check_cpu, NULL, 1);
 }
 
 /*


