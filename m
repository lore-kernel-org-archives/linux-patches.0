Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F3F13C3F5;
	Tue, 23 Jul 2024 18:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759778; cv=none; b=jOm+ES20aBJeWnQbC+RzsK9cHFUy4OHy2DQbFdh5opEU2NLb+KSOBCEErsjV7PsXfl6qTWlHaajsxWoHW621/jNoLf6K/EGiWBBz2gOQbLXMusHxoCbeBAWqkWNIhYkiD74sJ21XkQN20JYhQGVoddSbFhw/857fi7wofqfO8TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759778; c=relaxed/simple;
	bh=rRczQ2fcGcfcuwDonzMgDkmWnTuVKwAvlMo7yXZYM8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3NFOMz3Iiqu5ACTln/IZIgFNyWN9jo1JaOxyR2vshq8KDTs5dF2OJBJBgvMYhunpX2kqOixBYAoLY0my+6Xis6QFieh+iPqNy4JMf0jpWWhooqRYzSSX0JcvZEIxbxplM7khnraK1q/izQ5lWJiqw+5BSg3oaOroqbpipvx9tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHPK0a5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHPK0a5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78314C4AF09;
	Tue, 23 Jul 2024 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759777;
	bh=rRczQ2fcGcfcuwDonzMgDkmWnTuVKwAvlMo7yXZYM8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHPK0a5XhOhg29MqYz+EbAOOJx3FgHIxDCC8VhGFJQjb300neLARbEB+NOdEvnG+m
	 bBHtrZo8T12fJERyBXB13Ufj7fmYlhxoINOcCuTG5u26mLga3EcaPaGe9svkiGMWr6
	 vaj527+l86aNF3CBvU6t+YoSjPYBSzxwUDPb0VVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Zigotzky <chzigotzky@xenosoft.de>,
	Marc Zyngier <maz@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.6 123/129] of/irq: Disable "interrupt-map" parsing for PASEMI Nemo
Date: Tue, 23 Jul 2024 20:24:31 +0200
Message-ID: <20240723180409.544697309@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


