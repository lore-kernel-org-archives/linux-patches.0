Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18E533F59A;
	Sat, 12 Sep 2026 13:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220129; cv=none; b=kfibEPlnXt7EU5mEhimpcWXN1VnTr0WonQXIibyK9OCuHtm1+Drpzm2B8b632lD87mPR3tQXyrhimsCv3BgMtLTt5/RcmpyuEgyXLB3vubASQsCnGUpd2DsgrD3IQxOdRxEes8FCsADrkM7Q+HxgIc9lZyMKeHQiZYpdiFTzFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220129; c=relaxed/simple;
	bh=5QdQSJ3A3C9hIfseG3MhlmRz11hJAh0Wk8U8YN6FCt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL2hs323nUCPT+7z3mwm7DxQfpr/CtNQTayKZAzsHFhsfe70DoUXNnDdIrMyN0VUyiiHQBB0c+ZSVIAmBNSI+OQ5oSc4blMGszDNDNX03VgMYQJVFmlaRVsW10IRjuwxnBM2AsM+p+Edn+orDnX/QtII7Pdbudxrqizpoxmf97U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItqStDqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItqStDqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A571F000FF;
	Sat, 12 Sep 2026 13:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220128;
	bh=Dw0ZzV8+8ua4TUk7KogzL4lc7VNK1iNIHUE70omKBQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItqStDqzNO6NGNvq0igKfGxbY3LotvljVV9X7C1pWygyK8Cq8ukw40qsQMq4ZKnMO
	 Gf6+XaYJW9537ap+tZuJ8n0sH0qILdN29tni3EuIuPQZvyY8DxHDQmra+RGIGIywNL
	 2Wl/cMHa3MeClcQWBWHYgr//ThBSk0mqmXJGDOKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 6.6 0112/1424] alpha: marvel: Fix irq_set_status_flags to use correct IRQ number
Date: Sat, 12 Sep 2026 08:42:24 +0200
Message-ID: <20260912065609.814003461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

commit 3a3ac1f6c6a67b3803f2643584310f78301e58a8 upstream.

Pass base + i to irq_set_status_flags() to match the IRQ number
used in irq_set_chip_and_handler(). Previously, IRQ_LEVEL was set
on the wrong (low-numbered) IRQ descriptors rather than the IO7
IRQs at base + i.

Cc: stable@vger.kernel.org
Fixes: 08876fe8519c ("alpha: marvel: Convert irq_chip functions")
Signed-off-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260528230516.1839694-1-mattst88@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/sys_marvel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -275,7 +275,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the lsi irqs.  */
 	for (i = 0; i < 128; ++i) {
 		irq_set_chip_and_handler(base + i, lsi_ops, handle_level_irq);
-		irq_set_status_flags(i, IRQ_LEVEL);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
 	}
 
 	/* Disable the implemented irqs in hardware.  */
@@ -289,7 +289,7 @@ init_io7_irqs(struct io7 *io7,
 	/* Set up the msi irqs.  */
 	for (i = 128; i < (128 + 512); ++i) {
 		irq_set_chip_and_handler(base + i, msi_ops, handle_level_irq);
-		irq_set_status_flags(i, IRQ_LEVEL);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
 	}
 
 	for (i = 0; i < 16; ++i)


