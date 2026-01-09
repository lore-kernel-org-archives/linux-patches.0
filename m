Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4137C35A930;
	Fri,  9 Jan 2026 12:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960960; cv=none; b=HqE2fNw3P/Lm9s+YNp24qGO1iiqTIzd+cx/sHLo0GOSCdTeJ/jzuppsNDk0IxajJ1dpe4T100jKklNAutl7WrIuojasJV+cRi9B5NUUM85j0lJ5n7wB3GmtRRnDq/Kro84RZK5qN5QUB+iYW5nCLyPB1PUvbrvkAQpEaFiU05dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960960; c=relaxed/simple;
	bh=92Tay5xvwPV8fyyV699MrbeFjv8vfKjpNiQ59t9Mpq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSdr/SfVOT3oiRw9egT350Fkto6BD5vLRudbGfqw6eaVyk4gh2bfmf4Nd8fhIrZqcN3BZtRhXKef7EcPCJ1m1UrLCQRXO5pILJKfYVLRplZzEBy1CjwrSoRoib4SaBA1lZRqn4yN4/Hc6DKLzs7yP1waRPhI+3BT3qL0/ZmqR40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tA23LMsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tA23LMsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6177EC4CEF1;
	Fri,  9 Jan 2026 12:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960959;
	bh=92Tay5xvwPV8fyyV699MrbeFjv8vfKjpNiQ59t9Mpq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tA23LMsPHHmopWlwViUX6/AjT0lch14xH5jZ405v5zeday7ckIpN3HwI63EJWZJJP
	 HlYENFK09hr7IGvqUTMTObHwbfLPjfK/7/aQfAOw4RBsKuxwcWvhCBiCmejIcYJik3
	 tVm4VWy2bmsuP9NKO5c2o59iEP5m2qZnqto+zlfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 585/737] media: renesas: rcar_drif: fix device node reference leak in rcar_drif_bond_enabled
Date: Fri,  9 Jan 2026 12:42:04 +0100
Message-ID: <20260109112156.006670600@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 445e1658894fd74eab7e53071fa16233887574ed upstream.

The function calls of_parse_phandle() which returns
a device node with an incremented reference count. When the bonded device
is not available, the function
returns NULL without releasing the reference, causing a reference leak.

Add of_node_put(np) to release the device node reference.
The of_node_put function handles NULL pointers.

Found through static analysis by reviewing the doc of of_parse_phandle()
and cross-checking its usage patterns across the codebase.

Fixes: 7625ee981af1 ("[media] media: platform: rcar_drif: Add DRIF support")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rcar_drif.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/renesas/rcar_drif.c
+++ b/drivers/media/platform/renesas/rcar_drif.c
@@ -1249,6 +1249,7 @@ static struct device_node *rcar_drif_bon
 	if (np && of_device_is_available(np))
 		return np;
 
+	of_node_put(np);
 	return NULL;
 }
 


