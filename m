Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAB533D50F;
	Thu, 30 Jul 2026 14:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421890; cv=none; b=PLfMrn9CqfUToUPVEfJvX1qkQLXK53tQyCACtKNT9oP0ku8koNS9ZYj7ftgnrg1AA2PL0ZKCbQHJ/cG0qwK4yTFiX+wPRwCEw5ES+5HrezpBwuBQynstYPB0wBhyiuDE/1bSJQxQc8ywDCHLi8+RZhZgsnWUgjXpwL3oTwwfexg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421890; c=relaxed/simple;
	bh=1GIyk7pDS5ALTxf/GOSxsm5ga0pHno2++q2bgGevwRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPKhQR04Y/d+NrpoXRVHULtVD9JPkHDhfQSR2UTglyLKt36Yh4p31nEjPtWpKibePEU4GJlUXwRD7q0HdWGAtxzx/9u9yJrGJNmeGBBHEDr6Z9IFP92OdtdFuEPh82GLkd6N7ns6MnCMy8kp6vh+M0IETtPGWoBJz/U339dylYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZkmIVIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZkmIVIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733091F000E9;
	Thu, 30 Jul 2026 14:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421889;
	bh=ipRXE2K2rfTaUvRjlVNfUhI5Ombmt1lAapfV6ezUqtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZkmIVIWRPKO3j+o8X6XaZxboj35Nck9FD2VTWfqM0WGmcqs+FGblRDOQHJBrq95S
	 zwDh0uLAp+AAwm+LFPU7C2MVbqVNl2cdgyXz7F95vKkDF9EWbVzAeeMecXgggf1xi8
	 IK7ywoBO6Jy25P85r5Iob2/Hp/Y2t1UsBwVkyprI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 253/744] pds_core: reject component parameter in legacy firmware update
Date: Thu, 30 Jul 2026 16:08:46 +0200
Message-ID: <20260730141449.670085579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 7be2552e601c247a328a5aba6fc06ac844b94a16 ]

The legacy firmware update path does not support per-component updates.
If a user specifies a component parameter with devlink flash, reject
the request with -EOPNOTSUPP rather than silently ignoring the component
parameter and flashing the entire firmware image.

Fixes: 49ce92fbee0b ("pds_core: add FW update feature to devlink")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260708163649.128620-1-nikhil.rao@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/devlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 3f0e56b951bf0b..d6fccd89476a0a 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -90,6 +90,12 @@ int pdsc_dl_flash_update(struct devlink *dl,
 {
 	struct pdsc *pdsc = devlink_priv(dl);
 
+	if (params->component) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Component update not supported by this device");
+		return -EOPNOTSUPP;
+	}
+
 	return pdsc_firmware_update(pdsc, params->fw, extack);
 }
 
-- 
2.53.0



