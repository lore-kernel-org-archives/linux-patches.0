Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E2014C5B0;
	Tue, 23 Jul 2024 18:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759425; cv=none; b=A/5Nsnt/2iXTbT0wWJDufLlgKEUNvOjmqGHrmSxWOZZh5dkYVCr59PfAF0BMVF4/pVL7KXt9I3Nz0KIUjdJSyS5lPrxDUjohUjyZdMUtfmEZQnQYHhxReY8THgpMNh+ds2FnAZsmIoWhOB2yUV/je1UNMmkXY8d9FtK9nqDQJsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759425; c=relaxed/simple;
	bh=V/fzo9oHqJ/4ybNgPOxp6kSHJEO/nRe/1Fho2Ui2CGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrJdgGtJXUO3i7n4FGNVlzq1ua/xkzmVLyzIelN6fLDUEp20ohZulgyH519FYX3zE/Q2qmh2VV57/DvvD/OvmuyYi3s+NK7j+b8V2ct/QApZwkIJJRZ3S+Ruaez8+DOGRTzLWwhIv2R5JX4beOS30zVD+iwo1Ujo8q16NViycEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoXxXFxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoXxXFxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB30C4AF0B;
	Tue, 23 Jul 2024 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759424;
	bh=V/fzo9oHqJ/4ybNgPOxp6kSHJEO/nRe/1Fho2Ui2CGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoXxXFxXXqoApw90xeBUl6IFR5J+bqgTBnQa7EOBlMu2n4ClANeDjwdaeUMLOgWDr
	 gHaEsR6hYXMoaJsrl4AK4ZuXEd55tAb1CFcdlko7zhBTm6ffkcQJaWImpOlSMQBqxr
	 mc5XMWg2GGNm2r98xPMUFE2YXV4QLoMHh4gi19Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>,
	Marc Zyngier <maz@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.1 100/105] of/irq: Disable "interrupt-map" parsing for PASEMI Nemo
Date: Tue, 23 Jul 2024 20:24:17 +0200
Message-ID: <20240723180407.097775159@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 2cf6b7d15a28640117bf9f75dc050892cf78a6e8 upstream.

Once again, we've broken PASEMI Nemo boards with its incomplete
"interrupt-map" translations. Commit 935df1bd40d4 ("of/irq: Factor out
parsing of interrupt-map parent phandle+args from of_irq_parse_raw()")
changed the behavior resulting in the existing work-around not taking
effect. Rework the work-around to just skip parsing "interrupt-map" up
front by using the of_irq_imap_abusers list.

Fixes: 935df1bd40d4 ("of/irq: Factor out parsing of interrupt-map parent phandle+args from of_irq_parse_raw()")
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/86ed8ba2sp.wl-maz@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -81,7 +81,8 @@ EXPORT_SYMBOL_GPL(of_irq_find_parent);
 /*
  * These interrupt controllers abuse interrupt-map for unspeakable
  * reasons and rely on the core code to *ignore* it (the drivers do
- * their own parsing of the property).
+ * their own parsing of the property). The PAsemi entry covers a
+ * non-sensical interrupt-map that is better left ignored.
  *
  * If you think of adding to the list for something *new*, think
  * again. There is a high chance that you will be sent back to the
@@ -95,6 +96,7 @@ static const char * const of_irq_imap_ab
 	"fsl,ls1043a-extirq",
 	"fsl,ls1088a-extirq",
 	"renesas,rza1-irqc",
+	"pasemi,rootbus",
 	NULL,
 };
 
@@ -293,20 +295,8 @@ int of_irq_parse_raw(const __be32 *addr,
 			imaplen -= imap - oldimap;
 			pr_debug(" -> imaplen=%d\n", imaplen);
 		}
-		if (!match) {
-			if (intc) {
-				/*
-				 * The PASEMI Nemo is a known offender, so
-				 * let's only warn for anyone else.
-				 */
-				WARN(!IS_ENABLED(CONFIG_PPC_PASEMI),
-				     "%pOF interrupt-map failed, using interrupt-controller\n",
-				     ipar);
-				return 0;
-			}
-
+		if (!match)
 			goto fail;
-		}
 
 		/*
 		 * Successfully parsed an interrupt-map translation; copy new


