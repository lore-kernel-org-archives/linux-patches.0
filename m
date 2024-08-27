Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9057E1C6F5B;
	Tue, 27 Aug 2024 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772452; cv=none; b=tQHTdETs+J31R1utk43gKwy0NQoyObJudbkL6fDfUmEtDWcDYqP/sV2b4fX8t3S/uORzMe9YmKF2Bzb89ek3BluLLQb7lLMXd4uKlBGaRPqxhyfKNYPjDUQdebSUAJEy1yCHNKUoyo3ei9Js09b0+K9zwhess2A2SQcAs+OPk90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772452; c=relaxed/simple;
	bh=FkrQxsMCrUl4p3OMxFlk8yF8c/l1W99Y1B1nMQIrOZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfDckA93EEcAaAkEF98v/up5Y9i8XPbR3Ma9cw8IdlnOguDKa3nn2pEbodj7qsnOYMi7nNBB0Lpx9gJ2P5oUvUEDpX/Zr7Ce2HEsAPgtpJNzfcyw7huER2oisGVtLoEQaza09u5YS62kEbX5y/GKfENyu9wyUT9aFB9pn7BTvRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utLIllPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utLIllPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00734C61040;
	Tue, 27 Aug 2024 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772452;
	bh=FkrQxsMCrUl4p3OMxFlk8yF8c/l1W99Y1B1nMQIrOZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utLIllPOlIJDpo1reSexZmPObt5VTsbxeWw9md4eoLIQgNZmzEm+YPnnBRxK4FoN1
	 N2fGQv2Y/X4ZylqourQ+J1C8cHGvsMU+Q7hcDlnIniIhUlpnAqIe4pStX7u5fThNNQ
	 64F2uN8bN3IMbDf3jLq1Shcwds3aWycSQgUxPglw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <julia.lawall@inria.fr>,
	Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 202/321] fbdev: offb: replace of_node_put with __free(device_node)
Date: Tue, 27 Aug 2024 16:38:30 +0200
Message-ID: <20240827143845.922698611@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>

[ Upstream commit ce4a7ae84a58b9f33aae8d6c769b3c94f3d5ce76 ]

Replaced instance of of_node_put with __free(device_node)
to simplify code and protect against any memory leaks
due to future changes in the control flow.

Suggested-by: Julia Lawall <julia.lawall@inria.fr>
Signed-off-by: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/offb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
index 91001990e351c..6f0a9851b0924 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -355,7 +355,7 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 			par->cmap_type = cmap_gxt2000;
 	} else if (of_node_name_prefix(dp, "vga,Display-")) {
 		/* Look for AVIVO initialized by SLOF */
-		struct device_node *pciparent = of_get_parent(dp);
+		struct device_node *pciparent __free(device_node) = of_get_parent(dp);
 		const u32 *vid, *did;
 		vid = of_get_property(pciparent, "vendor-id", NULL);
 		did = of_get_property(pciparent, "device-id", NULL);
@@ -367,7 +367,6 @@ static void offb_init_palette_hacks(struct fb_info *info, struct device_node *dp
 			if (par->cmap_adr)
 				par->cmap_type = cmap_avivo;
 		}
-		of_node_put(pciparent);
 	} else if (dp && of_device_is_compatible(dp, "qemu,std-vga")) {
 #ifdef __BIG_ENDIAN
 		const __be32 io_of_addr[3] = { 0x01000000, 0x0, 0x0 };
-- 
2.43.0



