Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D533793D2;
	Tue, 21 Jul 2026 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648646; cv=none; b=Nb4ZwHcPJhlgh2F/4D794FYelB+xZdgBLVe9SRQ9DwYwibHyU/5ArwWoEsjXbY3Lcgn0hb5N9lVAo1IY+jrJlP1kLt2l0Iz0XjIQ7Au2UdXMJ5gKFhyf7EOFOxhOpC5PTu7qa9du8vC1DnOUpT8aJSw0kd9Ajb7UrBELkny/eQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648646; c=relaxed/simple;
	bh=zxnFjN1KNC8uLi8MThf+OjY/DhVcG6VCYxumODMDlNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO1mmg9O2dhUM1qocXROJFOCmG9ZDE+DzrL0Sxg7Kleugk5kl8JueEqmSbXjlXvQ2YEIrn+CiWu+KP23CLkXCab5U7Y/ytyrz1hV3BFkUe8r7HijyzdObgzZyEbnhMgg7QHXofuAL57zo4eGqnykBxoRJuWyQIZaa0IQ6l42Vz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlnoVGjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlnoVGjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DCD1F00A3D;
	Tue, 21 Jul 2026 15:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648645;
	bh=ibxVNCb8qi9vpQ8XR0bsCokF4waDER39NxgUdeGQ5FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlnoVGjvN6xGxiluj63UhF88/OcCPA56KdoTuFAtG7fNpkyPVt0NRIOVDYI5PkNqJ
	 zzh80/52hij2jM927WWGGTZSU2/IcPMM4Ld4IXMyRJkkJid9U+9MaHQzeEa6dUIEE6
	 yQqNmE70jD8aSS8YidbbpQKP4v4jozd3aqAHfeJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0279/2077] device property: fix fwnode reference leak in fwnode_graph_get_endpoint_by_id()
Date: Tue, 21 Jul 2026 16:59:12 +0200
Message-ID: <20260721152559.262847038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit 9582485a65eacfd7245ec7f0a9d7e2c34749d669 ]

When called with FWNODE_GRAPH_ENDPOINT_NEXT, the function walks every
endpoint under the requested port and, for any endpoint whose ID is
greater than or equal to the requested one, may store a fwnode
reference in best_ep via fwnode_handle_get(). If a later iteration
finds an exact-ID match, the function returns that endpoint directly
without dropping the reference held by best_ep, leaking it.

Drop the saved candidate before returning the exact-match endpoint.

This affects callers that use FWNODE_GRAPH_ENDPOINT_NEXT to ask for
the next endpoint with ID >= the requested one (used by a number of
media drivers, e.g. imx7/8, sun6i CSI, omap3isp, xilinx-csi2,
stm32-csi). Each leak retains a fwnode reference until reboot/unbind.

Fixes: 0fcc2bdc8aff ("device property: Add fwnode_graph_get_endpoint_by_id()")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260514171455.27271-1-sozdayvek@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 8e0148a37fffb4..e08eadd66f4f9f 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1277,8 +1277,10 @@ fwnode_graph_get_endpoint_by_id(const struct fwnode_handle *fwnode,
 		if (fwnode_ep.port != port)
 			continue;
 
-		if (fwnode_ep.id == endpoint)
+		if (fwnode_ep.id == endpoint) {
+			fwnode_handle_put(best_ep);
 			return ep;
+		}
 
 		if (!endpoint_next)
 			continue;
-- 
2.53.0



