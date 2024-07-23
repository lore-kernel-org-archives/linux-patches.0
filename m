Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2587313D600;
	Tue, 23 Jul 2024 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760264; cv=none; b=Bh9AMu4+ytSuwWPPsict5xKqzJN2qETWxysITXaXU2AiyfJXnfF1BEdhG1XXXAFDjF40XFBZCraXMdKAjT4ReZFpaxSkRSoZvNSbYf2dzxSTl/FLLVO5SuJsACLe2DdESSlr6HFRl/JCfXhaxn9mG8V8q8e3y0YwkOnadfRbNXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760264; c=relaxed/simple;
	bh=ZzXKltO3dKMbyKfdNO+bX1Q8gf1RFGRBfygBhRe0SWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZG12T6jwA6ZJ2wq84kY/H5h8tn454Peb+Fa3WOie5hUl5oPgsfuJ+4ohu38mW6y+ysBJHVSZcEDiGUYu82EclK8t2hVV5uqYawnttLg8E0AdydTIwDR/ESoF/aBNx8omTK4QqqycfcOJQIgvY1Ixa2AAV94J+HQa9YPx2CQuxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArfAB5iS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArfAB5iS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07B6C4AF0A;
	Tue, 23 Jul 2024 18:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760264;
	bh=ZzXKltO3dKMbyKfdNO+bX1Q8gf1RFGRBfygBhRe0SWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArfAB5iSKPZuJyqCSuPETPBzq9zl14EVTpP7FXGRasFozMfmfPEEipI5PMMKlMUXc
	 bwnzxeG50phXxi7mkT6nkf4CdUS1dbI6EWLNA+taBGPYwYsrQR1XQ2obALNBTDuGzN
	 gophIBvm0JuFrVqwHtfqDgToTOgkNeUErByMSWDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>,
	Marc Zyngier <maz@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.9 157/163] of/irq: Disable "interrupt-map" parsing for PASEMI Nemo
Date: Tue, 23 Jul 2024 20:24:46 +0200
Message-ID: <20240723180149.538055631@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


