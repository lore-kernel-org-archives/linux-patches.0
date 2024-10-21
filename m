Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CCEA16F27E;
	Mon, 21 Oct 2024 10:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506770; cv=none; b=NxpFQmVw6CKhH2MNjCW12kfIFQbXyJd8984hJ+atVBh15ieziHQdKn+Xbv4I8nlWINwvMyStcGWwTEno3G5YOIOrijq+hy+B6kW18z4SRbSxtX7+fsMAoJrVhgwxFEQm+hVGUKwt+XkijIudFpBtJpc9rSl8WGE4nMpvrEXknfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506770; c=relaxed/simple;
	bh=6HsR8ih4uUNQOALd1Pej6XfWfdtAakpyHPpL7RXR5bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAHtqnQFaF6t+H85pLYf+D3lcT8KF6/dszGi9jAycgV9qbpbWnw9Rib06JunQ33WSjYglwBO4B3mMzFS0eM3MiWs0VQbyV2a393WwNo9blNsmQzPJe9ZgbtiYidUOBVq1bMBtykc01OcavfRbbfFNhHKFiqfekrp3/6Zi9WCELI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mZ3SaG2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mZ3SaG2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2A1C4CEC3;
	Mon, 21 Oct 2024 10:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506769;
	bh=6HsR8ih4uUNQOALd1Pej6XfWfdtAakpyHPpL7RXR5bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZ3SaG2BK4h43vEd2hwNLZr51/0TKhG/jKeMvUOAcfLYSMBh2fkn92gkHT1113MXf
	 ByM0ZMsaSngWAgrwdWUPHsu/WNZFRR0W4dY1zK/DVDr3g5s1JwtEq55M5ORKLaSp+7
	 CwGpEyVxCtrPDTMgxD6APnq0HyM7cawaD6DKiWjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Allen <john.allen@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.11 116/135] x86/CPU/AMD: Only apply Zenbleed fix for Zen2 during late microcode load
Date: Mon, 21 Oct 2024 12:24:32 +0200
Message-ID: <20241021102303.866943899@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1218,5 +1218,6 @@ void amd_check_microcode(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD)
 		return;
 
-	on_each_cpu(zenbleed_check_cpu, NULL, 1);
+	if (cpu_feature_enabled(X86_FEATURE_ZEN2))
+		on_each_cpu(zenbleed_check_cpu, NULL, 1);
 }


