Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383BC426EBB;
	Sat, 12 Sep 2026 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208237; cv=none; b=RjGB1uzBYFRP7CgQvmng0u1Id8dyedUCIPjMJeqv/jeC9qmqnkvQqg0sFG/Sq5sy8AK9hNwow/Wj0j3Rj5ixL+3aHHv/TT6JiFU7aYzxwtS6Vmb71BBcHtu7T+M64Gi/JkBKIPT2/KlmvlZX9PPN5OuqrIWp70VvbDvKtTpa/nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208237; c=relaxed/simple;
	bh=xEHER5bTJwAT2tol152dOLJdVq5ssU+LX9Q0foJtKio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eC9zqo0Wb4hNe957AK8R1dHOCTn2eVpeZMpz9M+UxB9Ka/NrcLlGSXy1qKBGjHyQOgdFmBkLGjPWqvbcH/zCh2K00Ne+xCc8jKJCoZLTiWUSfecwBFAPX93GK362hgU2T2UthiUYT+QjZ/L2FFbsSegt3LYtQP5ABVDNFCVhFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YY+aLJyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YY+aLJyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5CF1F00893;
	Sat, 12 Sep 2026 10:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208226;
	bh=Xgp0Ipj44hbT+pyyc67j6lUDuTX3roZl0kowJBBo9r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YY+aLJylOk4m9s+w4MxyJaGf+hw1343sentM8FlPwj39Tjdu/v7xbacD10iiT/hhd
	 Q6ZO3D3RXXZEFI4nRVuaUjMzeh3NSFZOhJC/FU5cjE8siDnbijqpQV5dw2mK64trKC
	 qwIIJtlJzxqkcHeuXpywq8VKVQ1r5b3MYdmDx5i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0575/1518] cxl/region: Fix use-after-free in find_pos_and_ways() error path
Date: Sat, 12 Sep 2026 08:45:44 +0200
Message-ID: <20260912065636.436730781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alison Schofield <alison.schofield@intel.com>

[ Upstream commit 15da704b732332cc1e8f121f624e5e6c05124c5d ]

The error path releases its reference to a switch decoder before
logging an error that includes the decoder name. If the released
reference is the last one, the decoder can be freed before the error
message accesses its name.

Drop the reference after the error is reported.

Fixes: d90acdf49e18 ("cxl/region: Add a dev_err() on missing target list entries")
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/10deb519b543ef693ce23148b509a03fe1c07d0c.1784931354.git.alison.schofield@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index a1141471b4586..d518d463b28c4 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1815,14 +1815,13 @@ static int find_pos_and_ways(struct cxl_port *port, struct range *range,
 			break;
 		}
 	}
-	put_device(dev);
-
 	if (rc)
 		dev_err(port->uport_dev,
 			"failed to find %s:%s in target list of %s\n",
 			dev_name(&port->dev),
-			dev_name(port->parent_dport->dport_dev),
-			dev_name(&cxlsd->cxld.dev));
+			dev_name(port->parent_dport->dport_dev), dev_name(dev));
+
+	put_device(dev);
 
 	return rc;
 }
-- 
2.53.0



