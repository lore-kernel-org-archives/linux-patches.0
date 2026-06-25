Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F68A2EC086;
	Thu, 25 Jun 2026 13:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393144; cv=none; b=RIIRUkch1mZfKnDQki0A6MjIrSIeV9Y4EP59v2Zf8IP/lbOg2ztkXWECeqe8QU/JlPneoAqQ/7n/Tv566IBdt6cxft77z2EisZEhEVxRBXCAwCa9PwBAX5/oWZcDuiYFiAYsFhGXHz9HmkMbKAbiYDQMOqgfrPtD/Wgl66EqcK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393144; c=relaxed/simple;
	bh=hXZ5IXxBJ4/vNwN3xxVxdcdyigQL3aBaGVe+XaZyIzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNVripz2mDh+WOmF1yK54LAoRY9+oSzhMppujbtrsykZt4hjUoeh/nBzySkOtudv+wLuD0Vwuh3nZ/dsklHwBtgQoYLTAoMeRk7YXNyAgcRTPICS7+LeuOWp4DPW8mwgMJf9PtJjm94ZQhm50Rj+KT+XDrJhW462hl4JCd7yzWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQ4AcjWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQ4AcjWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46EC1F00A3A;
	Thu, 25 Jun 2026 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393143;
	bh=O3gJm5ho+sprxgHCxyg2tUmI+m1xUcoWFUG0Hde/3Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQ4AcjWOosioOYevsQMTnuO4OEozknM/MoHFXAW4GdgojL2uj7CU/nKYvGrTYV9PV
	 QDELdLic5qP0TRJF0dQy91YuWenXPAm07UTLBmYk91r2ClZnnAyIX2nIx4GwnzQ6m0
	 GFP6DfqYCg+GZGbY8OB8frGiKuRHk8/D61GlsCzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 09/21] Input: rmi4 - fix type overflow in register counts
Date: Thu, 25 Jun 2026 14:04:01 +0100
Message-ID: <20260625125614.543002211@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit a0a87e441238e07c5f7e3de133ef77a9d4229f01 upstream.

The number of registers in the RMI4 register descriptor is populated
by counting the bits in the presence map using bitmap_weight(). Since
the presence map can contain up to 256 bits (RMI_REG_DESC_PRESENSE_BITS),
storing this count in a u8 can overflow to 0 if all 256 bits are set.

Change the num_registers field in struct rmi_register_descriptor
from u8 to u16 to prevent potential integer overflow and ensure safe
processing of devices reporting large descriptors.

Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-3-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/rmi4/rmi_driver.h
+++ b/drivers/input/rmi4/rmi_driver.h
@@ -65,7 +65,7 @@ struct rmi_register_desc_item {
 struct rmi_register_descriptor {
 	unsigned long struct_size;
 	unsigned long presense_map[BITS_TO_LONGS(RMI_REG_DESC_PRESENSE_BITS)];
-	u8 num_registers;
+	u16 num_registers;
 	struct rmi_register_desc_item *registers;
 };
 


