Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEEA3EDE68;
	Tue, 12 May 2026 18:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609241; cv=none; b=ts6ItKd/LksCJtMb8Y24LB6Sz7FlF3/DD3AJKMTtQe1PWN36JhwErdwgA5ESGnt0atFZl69p9R4nBJVsdrGr6QpZDDJm2E/5MSLbLI9jdJAAPi3wMn4jSnwKSk+70+MGwmopowpjqfcsf+wV/fWVqxvhklJQY8ZyVkxyYyuf9cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609241; c=relaxed/simple;
	bh=sAq9v59Z4wEwziV6WgV6xhSuuKRGo0rJvwcfo4NRwG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5n2GPl1wfGiEWvRv2dpO7363vsuzUVt0EGiQc0bI8I1VK5/XGinfVCGYOnz8goGlOn8ak9QWAFA5X8gb3k3AXaB05uJPTdmxfMJxUgUg88727jG6sg1HkftRsvlAn/gHrqqstdx+IQ/rp2kwBrqhhMGJzY9UqY78qlc7xwwU94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiWYb0Vs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiWYb0Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04BCC2BCB0;
	Tue, 12 May 2026 18:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609241;
	bh=sAq9v59Z4wEwziV6WgV6xhSuuKRGo0rJvwcfo4NRwG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiWYb0VstW4foFG0howgMjPG1oJqlPcIgvdxheNBi5R7/WhcX8c60Mlav+B/++3S1
	 f/O8K8sX2XMCv/EiyRDH/XwuZExyUSmQBdXuUgcihVBKayxxu1rBuqebbZQqTyokyQ
	 bGmICJGiSkRoja4pvkFEtObHH6vzvUafHNtla1o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.0 068/307] LoongArch: KVM: Fix missing EMULATE_FAIL in kvm_emu_mmio_read()
Date: Tue, 12 May 2026 19:37:43 +0200
Message-ID: <20260512173941.556462605@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

commit f26faae96c411a70641e4d21b759475caa6122d5 upstream.

In the ldptr (0x24...0x27) opcode decoding path, the default case only
breaks out but without setting "ret" value to EMULATE_FAIL. This leaves
run->mmio.len uninitialized (stale from a previous MMIO operation) while
"ret" value remains EMULATE_DO_MMIO, causing the code to proceed with an
incorrect MMIO length.

Add "ret = EMULATE_FAIL" to match the other default branches in the same
function (e.g. the 0x28...0x2e and 0x38 cases).

Cc: stable@vger.kernel.org
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/exit.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -390,6 +390,7 @@ int kvm_emu_mmio_read(struct kvm_vcpu *v
 			run->mmio.len = 8;
 			break;
 		default:
+			ret = EMULATE_FAIL;
 			break;
 		}
 		break;


