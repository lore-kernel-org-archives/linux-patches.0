Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF5639C00E;
	Thu, 30 Jul 2026 14:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422802; cv=none; b=AddyDvmBaiwjANCA0HZ6zKV19H7SgicLmm5IPX28jEm+JLLYTmXxO9sY7tCxrxgdMETEL/MArqeuu4jUf/VeJ5c10WhUDXB9a2hu9pbGrjPnGPqf7HaOhNNUrtBZ5W953zwHenoeJ3DB3OYevkuBizemsUN/b8WJo8rfMVoIifg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422802; c=relaxed/simple;
	bh=F1HEP6NdT1D0+hrMDzmN6yMVfPNogT6/4Bv2EIzekDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Se4bqw1Y495xocFmc0gAMpo/IoVkb2PueG5X5sCMO7q5vNIe++rmvlFu3ORYiH4dmktXhud7A7PqFGQOSdeiZTkLp1yv2DmzXcIQyW3IN36esRBGbSAS//NYLt8jTI1XGrx8jMlI4EZVekGpu9zKc6mbVEY3bglWHXfp9YatLN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Drk+Cg8l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Drk+Cg8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0141F000E9;
	Thu, 30 Jul 2026 14:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422801;
	bh=YTmq6ZfxnV5HunbzLVICJiG158h/oJuAbIkQm9afp3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Drk+Cg8lf+VW1c3WJd2a1g5loe19xtKWb3iX7e48pDv3jZoySAIgFLqVBTLYIXsea
	 X503yikib5OufXZCVgy4yDIoidBU8YEFmtssTY0PqjDsqoBq4I4cJmkwbO5mbVcIBN
	 g7WYw+/o69gO1gwZbJMBGFyofldK6Ona8Ux1yww4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	Xi Ruoyao <xry111@xry111.site>,
	Zixing Liu <liushuyu@aosc.io>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.1 562/744] platform/loongarch: laptop: Explicitly reset bl_powered state when suspend
Date: Thu, 30 Jul 2026 16:13:55 +0200
Message-ID: <20260730141456.229212012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


