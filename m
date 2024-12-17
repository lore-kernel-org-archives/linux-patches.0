Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D04140E38;
	Tue, 17 Dec 2024 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456384; cv=none; b=HNQMun41gcaFKSgswf/ZUeCBgaseZwdW5YAZExCo10fMtiMP2Yb4zU+rf6qOQRtSwJ7oYcospzNq/R4XHlIv71WmoJTPqvXwWRJtvHgQocGw4Ou7izWtVutL0Vxr3xNVPhJRZhqQFe55JE9WozYw7HpE8dA22oZ5zLEGRZugMww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456384; c=relaxed/simple;
	bh=NlBvde220NmW8C8EPsKzu8J09Ktei1S6DhI8VfXefME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sy0NB98vi6jqHkv+4bB6C2pbd6JWTIda0LrTmBMOvqQjGbyqZycyiOWazNRfGRpTjrFspUHUw6XGTaVpBZWiv5wmOBuYLlVYJUxPawBnvygW+QcpURF1FP0v5FC9TGgI5cfJ+7p53aimr0uA39ge/sOcz6lqMaJWSyd474P1444=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK+h8SkT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK+h8SkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F16C4CED3;
	Tue, 17 Dec 2024 17:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456384;
	bh=NlBvde220NmW8C8EPsKzu8J09Ktei1S6DhI8VfXefME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK+h8SkTwvu6qDJD5N+b+Vr/9ujO6/AzYueuP439BjWiwEWFj28zONArI4DlGfBZ/
	 MEkKuq9gVC+U9FXehG6ZGhduSz5U9k2Io2tGfz1DILkkdy8wcdMx47WuvOprFHQIf/
	 G8DK1OlBbywn7UQBMtjoOEWBaAaMQnA6p3x7GFuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.12 015/172] riscv: Fix wrong usage of __pa() on a fixmap address
Date: Tue, 17 Dec 2024 18:06:11 +0100
Message-ID: <20241217170546.884264949@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ghiti <alexghiti@rivosinc.com>

commit c796e187201242992d6d292bfeff41aadfdf3f29 upstream.

riscv uses fixmap addresses to map the dtb so we can't use __pa() which
is reserved for linear mapping addresses.

Fixes: b2473a359763 ("of/fdt: add dt_phys arg to early_init_dt_scan and early_init_dt_verify")
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Link: https://lore.kernel.org/r/20241209074508.53037-1-alexghiti@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -227,7 +227,7 @@ static void __init init_resources(void)
 static void __init parse_dtb(void)
 {
 	/* Early scan of device tree from init memory */
-	if (early_init_dt_scan(dtb_early_va, __pa(dtb_early_va))) {
+	if (early_init_dt_scan(dtb_early_va, dtb_early_pa)) {
 		const char *name = of_flat_dt_get_machine_name();
 
 		if (name) {


