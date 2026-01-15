Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20617399011;
	Thu, 15 Jan 2026 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498603; cv=none; b=Vp2ySXSzwWn9mw3lv4KQhJlF/UIdD+nC9dGcsaKol3aEjIHja6mRmjTke8A+lPVKJ8ppEPl+DwXywQxrI7ngQWMqCRV5Ymz1hssM19rfurk/S7FRSk+iwwMLcsTjamCx/AgaEnKCwfX57WzBt9x2fPheGoJt9f7zp5RCy7xtxzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498603; c=relaxed/simple;
	bh=Tirct1awDZx/HoXlTPSQf7nONgKp+wZsdTVNagKH6+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxLjkSk1/2gbhxtizkAp/RdP7xSpyu0teVqcS6FxswhlySlEqONMK0D2co0x0N671pCBFjBt/eXTkR3NZzLubBwc9oaszGIyud6BNqfQtpv3+1QhcAqwwxVpVbXjljfDdY0Pscsag4cYj+J/xIQwP0a8CcVVAQT2P/SWQ8cjYtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnItbc+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnItbc+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3CBC116D0;
	Thu, 15 Jan 2026 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498603;
	bh=Tirct1awDZx/HoXlTPSQf7nONgKp+wZsdTVNagKH6+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnItbc+7iS5Y3zUa3ZleyBrd73GeYcxeWRKqsKOrVkzx7Vj+BP4cliZeUlMvnaJ1V
	 QIwgAhQQUYY7wu/yBJKcRgNbuGcVV8NG5w7UvEhtVsaera8fKwOLGyzZjWMRW80bc5
	 zYniCxb3D+FcQJI+gVrWhyGW2Fn2yJy2UA6UqqRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,  linux-kernel@vger.kernel.org, llvm@lists.linux.dev, stable@vger.kernel.org,  Justin Stitt" <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Justin Stitt <justinstitt@google.com>
Subject: [PATCH 5.15 488/554] KVM: arm64: sys_regs: disable -Wuninitialized-const-pointer warning
Date: Thu, 15 Jan 2026 17:49:14 +0100
Message-ID: <20260115164303.978770121@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

A new warning in Clang 22 [1] complains that @clidr passed to
get_clidr_el1() is an uninitialized const pointer. get_clidr_el1()
doesn't really care since it casts away the const-ness anyways -- it is
a false positive.

|  ../arch/arm64/kvm/sys_regs.c:2838:23: warning: variable 'clidr' is uninitialized when passed as a const pointer argument here [-Wuninitialized-const-pointer]
|   2838 |         get_clidr_el1(NULL, &clidr); /* Ugly... */
|        |                              ^~~~~

This patch isn't needed for anything past 6.1 as this code section was
reworked in Commit 7af0c2534f4c ("KVM: arm64: Normalize cache
configuration"). Since there is no upstream equivalent, this patch just
needs to be applied to 5.15.

Disable this warning for sys_regs.o with an iron fist as it doesn't make
sense to waste maintainer's time or potentially break builds by
backporting large changelists from 6.2+.

Cc: stable@vger.kernel.org
Fixes: 7c8c5e6a9101e ("arm64: KVM: system register handling")
Link: https://github.com/llvm/llvm-project/commit/00dacf8c22f065cb52efb14cd091d441f19b319e [1]
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,3 +25,6 @@ kvm-y := $(KVM)/kvm_main.o $(KVM)/coales
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o
+
+# Work around a false positive Clang 22 -Wuninitialized-const-pointer warning
+CFLAGS_sys_regs.o := $(call cc-disable-warning, uninitialized-const-pointer)


