Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E87E4D7D30;
	Tue, 13 Oct 2026 11:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892244; cv=none; b=tKgpAqND0WHrX9mnFBtJrAz10vfvpb45t1QQ/6HpEs7JrlgI9nBHjg+IW/PqVN2rJQjONYVNbP9emMLV0kZskmnaXT0LgF6qXERH/qZ950FCJXzQg6ymqNYPRbM6O9OCISaK84xqEyLR7OTYM09mPWVkND38aebOo2ibMvBGF3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892244; c=relaxed/simple;
	bh=ysPumMEfxLsbhsUK8bOuAqfaKKGcGbmvi/9b8inMVi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHXjgn/tdLNmxGg92miecJQFo3qSaeGu9SZNOuVG+SoVCWZPpTXQEzW1H5YpgLE9A3HequGpyiKNdaWS8kA1C3UsbGFmU1Cy9VNM0HJ/HhQ8h/Sjxq0LTwO/c18F94VxGe8pYhmdDv9CJX0ZP/sEJsZtbqhOSeAuZmOBvDx4znY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VicpnAxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VicpnAxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406511F000FF;
	Tue, 13 Oct 2026 11:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892242;
	bh=JamRcXvjwR0n6QA0PdqZjcbn4/t6PnAdV6kbJ/aKPqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VicpnAxDjUdDG/xQjzLcastTnOs6VKEc+PrXBtAH40A9HW9KCbgxMz0R5zmMcp/P2
	 VX0mc4RHVOqX7kE7SVfdyeKn4dt38LGGZ3IXySjpa/83VCBLZEXVcZQr1TGNrILNu3
	 cn/0VSFUXcMTELDvwOl/UH5DKqv/arGcd5xk7jk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 7.2 107/281] riscv: errata: select RISCV_ALTERNATIVE_EARLY for THEAD GHOSTWRITE
Date: Tue, 13 Oct 2026 13:37:03 +0200
Message-ID: <20261013112857.740488880@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

commit 298510bbc7c3017c0faf481c6ea66f1065b657b4 upstream.

errata_probe_ghostwrite() only marks the CPU as vulnerable when it is
called at the RISCV_ALTERNATIVES_EARLY_BOOT stage, and the mitigation
in ghostwrite_enable_mitigation() only takes effect if the vulnerable
state was recorded before the boot alternatives are patched.

The early boot stage is only executed when CONFIG_RISCV_ALTERNATIVE_EARLY
is enabled, which currently is only selected by ERRATA_THEAD_MAE. In a
kernel built with ERRATA_THEAD_GHOSTWRITE=y but ERRATA_THEAD_MAE=n, the
early alternatives never run, so ghostwrite_state is never set to
VULNERABLE: ghostwrite_enable_mitigation() returns false, xtheadvector
remains enabled, and sysfs reports "Not affected" on a vulnerable
T-Head C9xx CPU.

Select RISCV_ALTERNATIVE_EARLY from ERRATA_THEAD_GHOSTWRITE so that the
vulnerability is detected in the early boot stage and the default
mitigation is applied.

Fixes: 4bf97069239b ("riscv: Add ghostwrite vulnerability")
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://patch.msgid.link/20260917074843.52716-1-min_halo@163.com
Cc: stable@vger.kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Kconfig.errata |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/riscv/Kconfig.errata
+++ b/arch/riscv/Kconfig.errata
@@ -146,6 +146,7 @@ config ERRATA_THEAD_PMU
 config ERRATA_THEAD_GHOSTWRITE
 	bool "Apply T-Head Ghostwrite errata"
 	depends on ERRATA_THEAD && RISCV_ISA_XTHEADVECTOR
+	select RISCV_ALTERNATIVE_EARLY
 	default y
 	help
 	  The T-Head C9xx cores have a vulnerability in the xtheadvector


