Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9831A44685A;
	Thu, 30 Jul 2026 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427406; cv=none; b=SQDYfeEnXQp4kg/3D3ltgioDe1xp7cJgh97eT2cke0CefA+j3w0eHltKNCNpteWJHSAFID68NxX+odCw5IxwH/l5/tTwKVgPftZnBGstig/Hh7LN4a3g3DFgrTajd57ZHPujkbadX/cOFj1T+L5DVo8lGoyg78L1TqXRjIcX5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427406; c=relaxed/simple;
	bh=SJuYWevUHZd4YjtODv+/ctzyFHg0JYnLq7Bz0OMBvfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEliNlPR/pF6V0FGAOYUzh1OTTfr9Z8Kg8TTmeIU7H+pUP0jwZ3Zt1TmfSxcLp4syOw19JNUO1Q1Jf+mr7ScBpemjpLLT7AGZaffbg0agd2GZ3XbnJ4w3vFjyyXF+bQh1IHm5YaAa8js/uSfnY2BDEOjvBnsWSJNbHurQw3WgXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnr25Qu8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnr25Qu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17431F00A3A;
	Thu, 30 Jul 2026 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427405;
	bh=9eKCvuRd6/JEI+uW/Fp2XzT5C8WhM/OcZYAdTRZ+HIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnr25Qu8i8td65QJyrIzNOpXIdNnvmnfDNkZYCkaJ4cGCtmxQ/SrSsf25X6SnGhin
	 KxeWXnKTcyDuSCoUiuc99vzJ8XZQixB/KG4dZ2RW1wIjDxRzpIO4uJTN5zsOv89WpR
	 mErLIq26UUkqrdARFY3vMXrIazYYtR6DEY564X3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 159/484] pds_core: reject component parameter in legacy firmware update
Date: Thu, 30 Jul 2026 16:10:56 +0200
Message-ID: <20260730141426.921058690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 3144bad75a4df5..9939296145b522 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -88,6 +88,12 @@ int pdsc_dl_flash_update(struct devlink *dl,
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



