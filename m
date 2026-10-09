Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7034E50D6;
	Fri,  9 Oct 2026 14:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556217; cv=none; b=Jg/MURPHnwNCEbky4sgqip+bjh8NfT0eXqj/flkLNo02nYnIkMx46rRlKmXx7AavZ30Pbu2Xb+RqIrqMqpP8DnDk6W3i9+VxDM7Wg46ItQJlxzV8Oxc2Q4Cv9K1Bx64YsLfXjLQMkjAosiJwUN8cyitytqF8YvgL9drUzKXHe1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556217; c=relaxed/simple;
	bh=dFbDLV9VyzICyptEZX+vWUNDWw0hbo2E9k+E+12KQGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adwOKRSk8OOrXc9ZP0LVSfpKBkuV76X7JhCp+KPGtVswZo6uPotqJj/mkrVtqIgSs2zVyJ4NV5anwdV+1FdPV4FIu9O47zfjq0dAbhBq6uAoeFY+snhyT4BbUeADvU0ldoa8eLWABSfJRJGFgPgzW1ycl5d73lk6VSkfOboDYFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlwMmsMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlwMmsMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCCB1F000FF;
	Fri,  9 Oct 2026 14:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556215;
	bh=4cXO5al0tCRiHLgJBQ3w9xUKzRZPImgKBmlKAGMoZgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlwMmsMtMjVrz0PXD7XUzrzh8AG85Rj1oBFqjC3AbhFlQPaP6aC7Ivx9HPrVOeAFQ
	 UEbJLLBeVY726QJVywsudKYXUj5dJLbSkteZeMRTaovkO/7w9plUAmVX02TGeZFbpP
	 i6L92XDE3rkSUfOFUBOFNHC4TY8GOhE7eHAz7Iyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihisa Yamamoto <yoshihisa.yamamoto.xn@renesas.com>,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 139/428] net: pcs: rzn1-miic: Clear MIIC protection state before unprotect sequence
Date: Fri,  9 Oct 2026 16:07:56 +0200
Message-ID: <20261009140949.231545836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihisa Yamamoto <yoshihisa.yamamoto.xn@renesas.com>

[ Upstream commit 8b9993437429c66d11430ae61ffa5937a6abb4ae ]

On RZ/T2H and RZ/N1D MIIC, writing 0x0000 to the MIIC protection
register clears the protection state machine.

The initial protection state cannot be assumed to be constant,
as it may be influenced by previous activity before the driver
takes ownership of the hardware.

Clear the protection state before issuing the unprotect sequence
so that register access always starts from a known state, regardless
of any previous activity.

Fixes: 7dc54d3b8d91 ("net: pcs: add Renesas MII converter driver")
Signed-off-by: Yoshihisa Yamamoto <yoshihisa.yamamoto.xn@renesas.com>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/TYCPR01MB74815955A10817B64BD6FB93A4812@TYCPR01MB7481.jpnprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-rzn1-miic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-miic.c
index cb74861e823c8..3aa5134670609 100644
--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -270,6 +270,9 @@ static struct miic_port *phylink_pcs_to_miic_port(struct phylink_pcs *pcs)
 
 static void miic_unlock_regs(struct miic *miic)
 {
+	/* Clear protection state */
+	writel(0x0000, miic->base + MIIC_PRCMD);
+
 	/* Unprotect register writes */
 	writel(0x00A5, miic->base + MIIC_PRCMD);
 	writel(0x0001, miic->base + MIIC_PRCMD);
-- 
2.53.0



