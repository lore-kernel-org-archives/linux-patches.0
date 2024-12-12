Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5727D213E9F;
	Thu, 12 Dec 2024 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022621; cv=none; b=acdeogJeEndD1DUKF9clsiMHOhTO7AF3caQVtvcYNMRXn525bX0BpQZiFTRSmAitqfF1sOKcK3PT7PfWd2HeIDw3fKil9YS/Q/3CzjpRD1/Sclqu+WWvcFehlbn52b3SCAJeULeiuNtUO/TqvNIs3RSF8p9R/AMhsQX1l1nzqVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022621; c=relaxed/simple;
	bh=Di0t90/Wrx/xyg+eDKrxjslfojlBxsURbwK5kc7VDII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDl+smNTZ6jIT8wrUOOa8wimgmkvEIaEQoefogJuW5uJmB61nyHRX4iCvAbjVyYwZRDcD67Sge03m3GHGLLfyQtL/Cn60jExeilIzaO3cB5ZYLQJ9CFii5yXOBtdXWnBkLeIYpE/9pspa59pJlfNSdzgQgn4gKFoRUCdqidMrrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWqwe5Kx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWqwe5Kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3DEC4CECE;
	Thu, 12 Dec 2024 16:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022621;
	bh=Di0t90/Wrx/xyg+eDKrxjslfojlBxsURbwK5kc7VDII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWqwe5KxPi0fL9zVfw8TnPT97mnqt/OBUDI+l4AZauu2ZXMc++PJ64g65bYytUW1z
	 zvh7e0+eoVKRwUBHhjrZuXo+DgqafXfVQc7px2DJQ5ozAjaWxWE/Nni8mbNH8j0L9l
	 iYzEIUKehMQkvPf72aCVyve9TOfxZoP78CFIPNwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/565] rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length
Date: Thu, 12 Dec 2024 15:57:36 +0100
Message-ID: <20241212144321.786179081@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 06c59d97f63c1b8af521fa5aef8a716fb988b285 ]

The name len field of the CMD_OPEN packet is only 16-bits and the upper
16-bits of "param2" are a different "prio" field, which can be nonzero in
certain situations, and CMD_OPEN packets can be unexpectedly dropped
because of this.

Fix this by masking out the upper 16 bits of param2.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241007235935.6216-1-jonathan@marek.ca
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 49f08c0fdf975..25f98490a60db 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1045,7 +1045,8 @@ static irqreturn_t qcom_glink_native_intr(int irq, void *data)
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 			break;
 		case GLINK_CMD_OPEN:
-			ret = qcom_glink_rx_defer(glink, param2);
+			/* upper 16 bits of param2 are the "prio" field */
+			ret = qcom_glink_rx_defer(glink, param2 & 0xffff);
 			break;
 		case GLINK_CMD_TX_DATA:
 		case GLINK_CMD_TX_DATA_CONT:
-- 
2.43.0



