Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AD835E92B;
	Thu, 30 Jul 2026 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427884; cv=none; b=UUpzuUQw4Kz6umAU8r0dmPANC0McmeuqXDHZmVcbGqhgRuutm6uYbtAO1rvGhZmhtEPQy2O7T8plysd+lWey2uVBX3Q+mTFes1rwpZdrAoRCNtR9I9t0cuZXC1qkHKBTboOf/sykiC9Is96uhgOU9YZKFycZZ0C1HTYf58D5ECA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427884; c=relaxed/simple;
	bh=7AU7fUx3/wv/uqcwvH7zQ8D7QYXcoac9yXaQz3eBxko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRMZoVdMP4yq5FOnGDq3gw/bX++WJd5aHbpzYK/jBs+QGjFT5q8lVRRctOB+MqxKeEZUevaDmM7ZCJ4HqxNmlyhotjf2hZmzgJefrrgusa3qZ/IgpZF3DQq/+5FtKiDaQCNw+ZutASvSmjWdiOyDbQYletztUiSHEjNfJUs9ebQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvwoK5b4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvwoK5b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A851F000E9;
	Thu, 30 Jul 2026 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427883;
	bh=KP9M7TEw61MFg2jhLWdvDhv7Pt6t29xzqzvMm8u5Gr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvwoK5b4fqLfcYhBEbSW9JB612sgZ2WnB3dtbA+eylYVVjOtWTwFWxveZafyMz3H4
	 VXyMMfMIRg+1dKVcvOblFLMOX49YwsNHLUS8ORLialBcdhnR19ljw8X0XpHgLjazo+
	 ic364ZYjX2KnvhrL7/jU1wvwd1wph31loC7I8xGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	Xi Ruoyao <xry111@xry111.site>,
	Zixing Liu <liushuyu@aosc.io>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 282/484] platform/loongarch: laptop: Explicitly reset bl_powered state when suspend
Date: Thu, 30 Jul 2026 16:12:59 +0200
Message-ID: <20260730141429.616773153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
 


