Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B47200A3;
	Mon,  6 Jan 2025 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177939; cv=none; b=cihIGKy3H15loPDNOL03H/cWlf2gqD+Nc+5WLy8OPeTjzZAqwUHv1mYoH2adsko7RDkJ3wSU3aR8oThbZxktoMSCcU+7u4FW2/Ch73G10RwKUvc/3GXFLepPE4sstnfrC0F9+qkG/ZYAAayDCe1eza4h/hMpb3y8SqVFKDH2IkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177939; c=relaxed/simple;
	bh=mhcIcCncg9JoJA1sId5/PAIiihfVEwhwRnRE+3CYGO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj5K8Lm9yEMj9ECNdhnF+yYcw7/FIf4udXQvos1M7K8v0z6b94Ea4r9J5SNT9uGv9yZYW+Nr/QZ62sH/6VhfO360+erG9qBZCxSdx0PyfZevdRlQsqXpp/a5Cwce1Hrtdq8Hmq98CV4m06hkeD7OD+zaYsFDpcm10/DOjPc/Ss0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PL+o+wnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PL+o+wnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781C8C4CED2;
	Mon,  6 Jan 2025 15:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177938;
	bh=mhcIcCncg9JoJA1sId5/PAIiihfVEwhwRnRE+3CYGO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL+o+wnAsLNPoQKjspCe3xtwp+sCf38UAiQHF1DE9Wtzt9hrKfq7Bov6ibM5wG2/4
	 LTLEGoYqx5PAKMWxFbgnts/LabkfZkA1mzWYCetS1VNbQjQnVJcrE7Kcj2Eb0lzO9r
	 +T6iQrXmGlKHFzebyVMpAWsfPUmXaIE6+dEeLG2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/156] scripts/mksysmap: Fix escape chars $
Date: Mon,  6 Jan 2025 16:16:33 +0100
Message-ID: <20250106151145.759427224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 7a6c355b55c051eb37cb15d191241da3aa3d6cba ]

Commit b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
changed the invocation of the script, to call sed directly without
shell.

That means, the current extra escape that was added in:
commit ec336aa83162 ("scripts/mksysmap: Fix badly escaped '$'")
for the shell is not correct any more, at the moment the stack traces
for nvhe are corrupted:
[   22.840904] kvm [190]:  [<ffff80008116dd54>] __kvm_nvhe_$x.220+0x58/0x9c
[   22.842913] kvm [190]:  [<ffff8000811709bc>] __kvm_nvhe_$x.9+0x44/0x50
[   22.844112] kvm [190]:  [<ffff80008116f8fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4

With this patch:
[   25.793513] kvm [192]: nVHE call trace:
[   25.794141] kvm [192]:  [<ffff80008116dd54>] __kvm_nvhe_hyp_panic+0xb0/0xf4
[   25.796590] kvm [192]:  [<ffff8000811709bc>] __kvm_nvhe_handle_trap+0xe4/0x188
[   25.797553] kvm [192]:  [<ffff80008116f8fc>] __kvm_nvhe___skip_pauth_save+0x4/0x4

Fixes: b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/mksysmap | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/mksysmap b/scripts/mksysmap
index c12723a04655..3accbdb269ac 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -26,7 +26,7 @@
 #  (do not forget a space before each pattern)
 
 # local symbols for ARM, MIPS, etc.
-/ \\$/d
+/ \$/d
 
 # local labels, .LBB, .Ltmpxxx, .L__unnamed_xx, .LASANPC, etc.
 / \.L/d
@@ -39,7 +39,7 @@
 / __pi_\.L/d
 
 # arm64 local symbols in non-VHE KVM namespace
-/ __kvm_nvhe_\\$/d
+/ __kvm_nvhe_\$/d
 / __kvm_nvhe_\.L/d
 
 # lld arm/aarch64/mips thunks
-- 
2.39.5



