Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F62374745;
	Tue, 13 Oct 2026 12:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895313; cv=none; b=DH9BRIitC5qE+TgWtEb1HTv/mzGXam5t9u+7xOjJcItmts27Es2uaqGYsC7znTu/fSqqRgAO66i2F24DG2IczT/V5DoKxUJAPt+QPL+ARvaWhrcDBfaTp+kms/KSkdGEx7uf0Bj/IGPnNtoFU2Jsg0M46ulM6IfmKAoZQdJD/V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895313; c=relaxed/simple;
	bh=ZhHQ+aqPmhIXf9DV79AsuaME01iegVKHn7eAh+VBXV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGfbQNFXoYYmupyf7YJUrXcOqt/ikStlV7dWsXa53uFGvDWkS8JATWyK5rFBnZdwmzAbSzxQlL16x3ZS6OwQJK1q2nlTTfRStdJgarZlwZIzjBu9euQle2SEga67EVR16BKIMQz507DOG1J/eSRTMYYZb1DnbhV+Lu3DYFBHBoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8UoeAGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8UoeAGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B4E1F000FF;
	Tue, 13 Oct 2026 12:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895312;
	bh=lsWDNaFG+HhFsg1XYIKeiS1j2wvebTdRbisrteZ1RPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8UoeAGRUUFpQL635jKKtFXJRUqMl+IQG3nJQcO32lRcTRci1SXSkeIWkpM+2UAEA
	 DTgX8Vme5zwN2F+rtZH90qgky2jhQhlVGNXKfOWqRFJOUlCVpwV5QVAA3za6qgiI3+
	 D6fb7xX8btTjLlkMG+gGwGHJ2/ru6LOozAN4LhYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 178/497] EDAC/altera: Fix memory leak on dci allocation failure
Date: Tue, 13 Oct 2026 13:35:45 +0200
Message-ID: <20261013112912.115101975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

commit 3e4a10a4718e3d963ee4d6c5f26bc5ad57c1d2b1 upstream.

Sashiko reports:

"If devres_open_group() fails, the function returns -ENOMEM without freeing the
dci structure allocated earlier with edac_device_alloc_ctl_info()."

Free the dci structure if devres_open_group() fails.

Fixes: c3eea1942a16 ("EDAC, altera: Add Altera L2 cache and OCRAM support")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # 6.18+
Link: https://patch.msgid.link/20260911120627.2634225-4-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1534,8 +1534,10 @@ static int altr_portb_setup(struct altr_
 	altdev = dci->pvt_info;
 	*altdev = *device;
 
-	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL))
+	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL)) {
+		edac_device_free_ctl_info(dci);
 		return -ENOMEM;
+	}
 
 	/* Update PortB specific values */
 	altdev->edac_dev_name = ecc_name;


