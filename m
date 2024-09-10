Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55C21940B5;
	Tue, 10 Sep 2024 10:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964144; cv=none; b=QzQSayFp4l0G021UDjwEPVvNyXvnP6GqHY6Srp3GcuU2Mqj2MiEz+9BWcAkdPLPjHDZBkEnhDBY5Cq8KSfcWEVcz1sfAm1J4H/oEJSomTyQbs7xUWgCbKLfkVXKDi2SsqJ2RBv7eB0HvUe03H4NdmCdfoR+1R/69BahT7YbI0B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964144; c=relaxed/simple;
	bh=XLwDIa8L6ZukjuZd0pMQeTXPnWbhwQg5wKcmiMoW5wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac7eZCfNdIbcGT+TpJ8GAu3hQ6FAdYNyKMCI1fvkSj6kGtbN3t6l+XkgSOkH75yhB7tXJtf7TwK0/+CoyDahXmuDLtzER4bGE1TQIcs8ypxyO4/YjqrIwC5qK+crKi1uTBrvkM29eA5QL9hTVi55Ig631aQefFSIEZIKxfjo1TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7YfzQEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7YfzQEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68799C4CEC3;
	Tue, 10 Sep 2024 10:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964143;
	bh=XLwDIa8L6ZukjuZd0pMQeTXPnWbhwQg5wKcmiMoW5wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7YfzQEMlyZWMRIA20OZF27Y66ohJdvtXK7lXcvWPsuQ9KPXNCXV0gPCzCBUy9B0j
	 FbzWgpjBFDSynYV3z3ocZARWloD24IjOK1GQF2DbDqdk+rmDHK9ZWus+4qlsfQNCny
	 SsU1MoObpeFbQ4jGo74MiUokX0USWg4RvydLLIp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/269] usb: gadget: aspeed_udc: validate endpoint index for ast udc
Date: Tue, 10 Sep 2024 11:31:09 +0200
Message-ID: <20240910092611.119640701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit ee0d382feb44ec0f445e2ad63786cd7f3f6a8199 ]

We should verify the bound of the array to assure that host
may not manipulate the index to point past endpoint array.

Found by static analysis.

Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20240625022306.2568122-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed_udc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/udc/aspeed_udc.c b/drivers/usb/gadget/udc/aspeed_udc.c
index fc2ead0fe621..4868286574a1 100644
--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -1009,6 +1009,8 @@ static void ast_udc_getstatus(struct ast_udc_dev *udc)
 		break;
 	case USB_RECIP_ENDPOINT:
 		epnum = crq.wIndex & USB_ENDPOINT_NUMBER_MASK;
+		if (epnum >= AST_UDC_NUM_ENDPOINTS)
+			goto stall;
 		status = udc->ep[epnum].stopped;
 		break;
 	default:
-- 
2.43.0



