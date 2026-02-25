Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983D74369A;
	Wed, 25 Feb 2026 01:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982823; cv=none; b=CUhesKTz1EBIbbMJIjVqGNPjWzleLA2sIslw3L7Gt7flL0lFJkIaX5nvlUMLOz+TxYAuzTSc4GunJkBHyGR6PsNRE5q+N4+nE5QuKIoBTXvXnOTt8A0hHU+SXosV17KX2iTzCda3wlsvcD+cfeYWI8Dp7W/KmpMV+r+MnNTo96c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982823; c=relaxed/simple;
	bh=k8j/lUUtdlPoas6DiqpSxamwU+QFGtou/C4VC1yyOcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3j3bi6Dh+lAABUkiGvAFw0ikTjcOD4fzDS3xkYZ9cj//TkBaG33qr9BCEZKQNK+ZPCTiuV8DEH4vxXVpLYjiVwj/+fIuo+C2E8PHPiKE2Q8SPw7MGszjIf4//SrnXTtOPkwdNpPPQsS4IGp0xfdFOTd2RUQDQxV1nzS2OElv6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuSopPPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuSopPPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFDEC116D0;
	Wed, 25 Feb 2026 01:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982823;
	bh=k8j/lUUtdlPoas6DiqpSxamwU+QFGtou/C4VC1yyOcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuSopPPEj8piWsMbtokIocixDpT10Wv3PWRU27mLPvNdVH50mWdgW5Xhpp/4sGjns
	 F3JjCmybto11ZmKeef0EtheQ+w6DyT050+xw4QM2ASDkxM5WFNeSJ/jwa1sF0RqzP+
	 WK2E7uRn7IxiDAdy71ILzbZcL+qSns/aURpvlnLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 003/781] auxdisplay: arm-charlcd: fix release_mem_region() size
Date: Tue, 24 Feb 2026 17:11:52 -0800
Message-ID: <20260225012359.781738204@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit b5c23a4d291d2ac1dfdd574a68a3a68c8da3069e ]

It seems like, after the request_mem_region(), the corresponding
release_mem_region() must take the same size. This was done
in (now removed due to previous refactoring) charlcd_remove()
but not in the error path in charlcd_probe().

Fixes: ce8962455e90 ("ARM: 6214/2: driver for the character LCD found in ARM refdesigns")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/auxdisplay/arm-charlcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/auxdisplay/arm-charlcd.c b/drivers/auxdisplay/arm-charlcd.c
index a7eae99a48f77..4e22882f57c9c 100644
--- a/drivers/auxdisplay/arm-charlcd.c
+++ b/drivers/auxdisplay/arm-charlcd.c
@@ -323,7 +323,7 @@ static int __init charlcd_probe(struct platform_device *pdev)
 out_no_irq:
 	iounmap(lcd->virtbase);
 out_no_memregion:
-	release_mem_region(lcd->phybase, SZ_4K);
+	release_mem_region(lcd->phybase, lcd->physize);
 out_no_resource:
 	kfree(lcd);
 	return ret;
-- 
2.51.0



