Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBF24EBAD7;
	Tue, 13 Oct 2026 12:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893056; cv=none; b=OkKK8MX7BVH6n5jcgIIDo5aFMPCQqCTHxPiaJGkcXPyyDZ7/hGQLsDsn+Wk9LPwvEXwW8A2VuRBaEndFKUggKlf3M+VDunAvo8oajvclqJewg8tw/wSXke14elW5nDx/cWJBvGcwx39mPxFQWEEQHQVmpHHQY952cOump9i6HPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893056; c=relaxed/simple;
	bh=khmIgSYRqZGukivWTI/IyOpgPkHc6kdfaayVPqPRSew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbM8RoUeuArfWQJc9UiSmSQTuAOVj1cerXbXMwEDe3aXr8q2Qlxh7K2mCZ/ADvK6G1ecb4KYr+yfA3TFYiBGBDWtC0meYymlv+rg8QakeizbVjtdn6mssDOwFeAEvTrv6Qciu9/fpCV0xbwX+HjbM6lVWN+LxQ3xZNih714KngI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0FYR+8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0FYR+8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384691F000FF;
	Tue, 13 Oct 2026 12:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893055;
	bh=eIlqR+IuCKCB9tyHBCP63n9srcMUTh3cJ2RdfSguCdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0FYR+8FyDVGVJ3wTXE7yCukMbvxQ3d6ZImhRowvVOXDjzS6xEflkSFAXBJ/tT5vP
	 UN/03VmYnNzp8MTIVttZht11ihv04nloYaePaweun7fY/UFRyNueNpCVBUd9+//WfH
	 n5/A06nteLAF2geQyYNdfpzeljsTxcvuWbWVe4Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 097/621] riscv: errata: select RISCV_ALTERNATIVE_EARLY for THEAD GHOSTWRITE
Date: Tue, 13 Oct 2026 13:31:32 +0200
Message-ID: <20261013112923.151729127@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,6 +145,7 @@ config ERRATA_THEAD_PMU
 config ERRATA_THEAD_GHOSTWRITE
 	bool "Apply T-Head Ghostwrite errata"
 	depends on ERRATA_THEAD && RISCV_ISA_XTHEADVECTOR
+	select RISCV_ALTERNATIVE_EARLY
 	default y
 	help
 	  The T-Head C9xx cores have a vulnerability in the xtheadvector


