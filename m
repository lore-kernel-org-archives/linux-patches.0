Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4E729B776;
	Mon, 17 Aug 2026 15:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979459; cv=none; b=jW8raH0jQyRwbGecTVhCHDVNpflcZcQ1ppyKI1NeRdHPnh55gcWBA3otRaVezugxaR3Abs7PObb7GD9GAd+VNLUPZGU1+NRuixftKHuoq49AUlb19ck1UAAKxqR9ehhR2xnZ5vuNJA8D2lCVHTdL1DJr/gz4JT/V4/xFyMYWuhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979459; c=relaxed/simple;
	bh=YyoKmhCGZ1FRo5MCXzNIIe7JzOVn5pjwsKnLWZdrP0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CD6so0Yz9g9EidM9f6d6Af8LDk/8a2+1bwR274SDLpg4fyKSvsvdVUcSEbJQg8ZabLqz1q0DeO/tnOlYqP1joDipIkjcUVskQ/+nBlMxDXnLHyprELFTh8hFxOS90vZgaMcqLJ4xzxN3TtiTmPJR0yAoC3e47gBAC1nryWkrP2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emvt/tc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emvt/tc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EBD1F000E9;
	Mon, 17 Aug 2026 15:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979458;
	bh=ZcVW0bLGRnxsSJ2D+zgIPhfkokizAUhSxUIrABv7iCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emvt/tc5BVBCnvS2SPy4mi1R8CS2x3awZU7x1wv8i3njEy3Hdw68Os6E8oMHqaOvb
	 DXgPO8vdpTRHOoIe3/AjDlcLg8oF4y4ZgTt2mBS8v9GsivuZtI5qNKD6gPdCv2b4ZY
	 JmAKckuXeOe8KpmFLSntkVAJ07gSEJ2MTVcv/Ll8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	Xi Ruoyao <xry111@xry111.site>,
	Zixing Liu <liushuyu@aosc.io>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 231/609] platform/loongarch: laptop: Explicitly reset bl_powered state when suspend
Date: Mon, 17 Aug 2026 15:28:47 +0200
Message-ID: <20260817132551.820979834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zixing Liu <liushuyu@aosc.io>

commit 91a70492c03040d51b36f595530d6491d5d6c541 upstream.

On EAECIS NL60R with EC firmware version 1.11, resuming from S3 has a
very high chance (>90%) of causing the EC to lose the previous backlight
power state. When this happens, the laptop resumes normally from S3, but
the backlight remains off (when shining on the screen with a flash light,
we can see the screen contents are updating normally).

Since there is no generic way to query the EC's backlight state on
Loongson laptop platforms, assume the worst-case scenario and restart
the backlight power inside the kernel each time the system resumes.

Cc: stable@vger.kernel.org
Fixes: 53c762b47f72 ("platform/loongarch: laptop: Add backlight power control support")
Tested-by: Yao Zi <me@ziyao.cc>
Tested-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Zixing Liu <liushuyu@aosc.io>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/loongarch/loongson-laptop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/loongarch/loongson-laptop.c
+++ b/drivers/platform/loongarch/loongson-laptop.c
@@ -189,6 +189,7 @@ static int __init setup_acpi_notify(stru
 
 static int loongson_hotkey_suspend(struct device *dev)
 {
+	bl_powered = false;
 	return 0;
 }
 


