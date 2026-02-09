Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C797628725B;
	Mon,  9 Feb 2026 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648610; cv=none; b=oTNpdJZJfFuapZJ9wVysDz1oQG1E3F6n+VxerA5zZI++iwedlAP5FBDuxEh29U4dupkQaWQAereLkioas/HHXx38Zjn7gstLxNzVZNoSaIe4c43MgXuCjp3jTB4a6MLD40URYS9SyQ2UkXVxneCNFa/X4RLLfWpU54XOmUccUt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648610; c=relaxed/simple;
	bh=ZEHzuE8Vwenm/F8MByqNnxZhnaihwkoQFNa5LleWYRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJx/RVKOLduoi+sOJxUibWL7PJ+BEp/0ShXhtQgbPUYXA8cHWP/T6GgmEF1IIkR+3UuG2XWnywz1cFqHkPPgardrSBkMWHmnXij95UMOkUCbytVSDTos7wBWCoxOHPOtQVVDOHZZobN+vTFsEGNCgVI9ovriVhJt3Yg83HL+AIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aK5AJp/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aK5AJp/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42983C116C6;
	Mon,  9 Feb 2026 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648610;
	bh=ZEHzuE8Vwenm/F8MByqNnxZhnaihwkoQFNa5LleWYRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aK5AJp/SgmYkgfj8NX4k0MdhMqcA6lu+227dPgWr+ies2KjHo19w/hDaw806m+OcX
	 SZX9Dn6Bp6qWdgvskAT/OupGSpZpbxwDeFJXX1pjpuBON73wZfh8cGz4y+j/SWNLdy
	 +NJQHhKgMXCBb97KSg5yMlnk+kD+xZnNll/1Ek7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 62/86] dpaa2-switch: prevent ZERO_SIZE_PTR dereference when num_ifs is zero
Date: Mon,  9 Feb 2026 15:24:25 +0100
Message-ID: <20260209142307.008660396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit ed48a84a72fefb20a82dd90a7caa7807e90c6f66 ]

The driver allocates arrays for ports, FDBs, and filter blocks using
kcalloc() with ethsw->sw_attr.num_ifs as the element count. When the
device reports zero interfaces (either due to hardware configuration
or firmware issues), kcalloc(0, ...) returns ZERO_SIZE_PTR (0x10)
instead of NULL.

Later in dpaa2_switch_probe(), the NAPI initialization unconditionally
accesses ethsw->ports[0]->netdev, which attempts to dereference
ZERO_SIZE_PTR (address 0x10), resulting in a kernel panic.

Add a check to ensure num_ifs is greater than zero after retrieving
device attributes. This prevents the zero-sized allocations and
subsequent invalid pointer dereference.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 0b1b71370458 ("staging: dpaa2-switch: handle Rx path on control interface")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/SYBPR01MB7881BEABA8DA896947962470AF91A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index cdab37e9634d4..6e3f65e3e8821 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2988,6 +2988,12 @@ static int dpaa2_switch_init(struct fsl_mc_device *sw_dev)
 		goto err_close;
 	}
 
+	if (!ethsw->sw_attr.num_ifs) {
+		dev_err(dev, "DPSW device has no interfaces\n");
+		err = -ENODEV;
+		goto err_close;
+	}
+
 	err = dpsw_get_api_version(ethsw->mc_io, 0,
 				   &ethsw->major,
 				   &ethsw->minor);
-- 
2.51.0



