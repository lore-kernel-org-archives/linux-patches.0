Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4151D2135AA;
	Thu, 13 Feb 2025 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458348; cv=none; b=A3b6JTS8x6SyJBgG5gHuaSm1kBTR+ot9CXsts1s+zZvTBO2mzO2eTKDwn5m8a/1NlNIccodlanUCLSliWNzkkG0UzaPHpvTd+XHQtLHQRh9P+Om5vkfMf+uTOgrLzqvyMq73iG1atrezfZ+dmURg/RS02GwrGz1tGWImuccQnvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458348; c=relaxed/simple;
	bh=RdH3b7assx0Z8rz3oCYzYeD0QRswrdFb5hhcbQ9NHBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paDTPWIPZVOKk23+EygkTtogxbvTipqfkXgdXb85BeFnkOCRWrQ23no9YwIU/L9E28/cHmJanvY6cQ5f7PfUFkuLa/eb2EjETkXjvnBhW9lcRFjlrFEnfTms6xOaaK/+bD2tMPQvEu4VoBp8ozF4TS5wJV7FV1bigEriVKHvmkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRpVuKZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRpVuKZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A101DC4CED1;
	Thu, 13 Feb 2025 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458348;
	bh=RdH3b7assx0Z8rz3oCYzYeD0QRswrdFb5hhcbQ9NHBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRpVuKZxBKuiDzZTTWQpCiwv2EBGcP7MDmfAr9JQ3Lr6+WErex+ICxMfutEepir+Q
	 yMX+WC2z7UxoQxgKdbP+CauGCK0NC4MivpeMTDlk1866St6h0D317/XegPeq2VXK6t
	 tOtenvd+cIKFL8qD0R253HSxzgawGnrikdYcJLxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 332/422] media: i2c: ds90ub960: Fix UB9702 VC map
Date: Thu, 13 Feb 2025 15:28:01 +0100
Message-ID: <20250213142449.365787546@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

commit 5dbbd0609b83f6eb72c005e2e5979d0cd25243c8 upstream.

The driver uses a static CSI-2 virtual channel mapping where all virtual
channels from an RX port are mapped to a virtual channel number matching
the RX port number.

The UB960 and UB9702 have different registers for the purpose, and the
UB9702 version is not correct. Each of the VC_ID_MAP registers do not
contain a single mapping, as the driver currently thinks, but two.

This can cause received VCs other than 0 to be mapped in a wrong way.

Fix this by writing both mappings to each register.

Cc: stable@vger.kernel.org
Fixes: afe267f2d368 ("media: i2c: add DS90UB960 driver")
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ds90ub960.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ds90ub960.c
+++ b/drivers/media/i2c/ds90ub960.c
@@ -2533,7 +2533,7 @@ static int ub960_configure_ports_for_str
 				for (i = 0; i < 8; i++)
 					ub960_rxport_write(priv, nport,
 							   UB960_RR_VC_ID_MAP(i),
-							   nport);
+							   (nport << 4) | nport);
 			}
 
 			break;


