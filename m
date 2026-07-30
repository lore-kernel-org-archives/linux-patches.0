Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA1B30C143;
	Thu, 30 Jul 2026 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426737; cv=none; b=sOUmlds17+5Lon23HvQCfBeJ9Y5er1JRnUudAHVWI66CC+F5GChse3GeM7rdaInqSL2uHCy6gMw9mHz7Ryrv2A+Z1tSBLI3pIkK0t3Av1FCp2+iZM2OBfCDbpIJ+EZsUbz9dPSHuPBjw7l5y2NC3bj2H6/qzmlva9OYHwOcsVS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426737; c=relaxed/simple;
	bh=mqnpiSkrghLkqpG3f1FbS4JtZdw428YAYYOnJ2z2Xos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WckjHZsfvQ/GP0q4ItI2ZyzCly1iJ9+NgRtM5IUV6mdbbdEmYeZbMATtesIb5G9qUsxcuKxiaUpVKeRUnNvbQ6UG2YWPB/8HeYiHIDYrDb4F7dBehWjVBRmSDFFGaYKA3CeKqBu/HJMuOBtx+P2f64/JhAd7Q6Q0MdCVLU6kcrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Xmurzuy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Xmurzuy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 570A71F000E9;
	Thu, 30 Jul 2026 15:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426735;
	bh=nhi2deoXuU73q1v5qF5TNEBQmHsEMVWS7bYBBn3H620=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0XmurzuylXl0ecaHf7aNTH3LD/1CVthjKfI2/3qN2xNcMJ4e+q/KyamVpUfyRoFIE
	 A7T/M7Sjn9f1W635ewSBwX/Y7Jl4RgD+qQIZWNaOy17AIYVYXDyHCS6UCT70808Ddx
	 s9YkYAF/166yPqExztN+w98AsDJbFC5tYis+PXQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 525/602] thunderbolt: Keep XDomain reference during the lifetime of a service
Date: Thu, 30 Jul 2026 16:15:17 +0200
Message-ID: <20260730141447.042832367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 8b4060998637f06975fceee9b73845d8672d411e ]

This is needed because we release the service ID in tb_service_release()
and the ID array is owned by the parent XDomain.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1008,6 +1008,7 @@ static void tb_service_release(struct de
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
+	tb_xdomain_put(xd);
 }
 
 const struct device_type tb_service_type = {
@@ -1116,7 +1117,7 @@ static void enumerate_services(struct tb
 		svc->id = id;
 		svc->dev.bus = &tb_bus_type;
 		svc->dev.type = &tb_service_type;
-		svc->dev.parent = &xd->dev;
+		svc->dev.parent = get_device(&xd->dev);
 		dev_set_name(&svc->dev, "%s.%d", dev_name(&xd->dev), svc->id);
 
 		tb_service_debugfs_init(svc);


