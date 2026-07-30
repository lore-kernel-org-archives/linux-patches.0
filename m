Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D5241DED0;
	Thu, 30 Jul 2026 15:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425853; cv=none; b=mKUukmTwrWD9Yb0mr65BdtUNSbX4iFfOkBvfXMLaxUCu+TesqoIHBG8NvjX/x/L85gQa+78qpUCV8ib9RLf4mCunkdnOgCEQsw1GdueA1flRu+gueIbvZfdGk4MbwGohLld1xAFyHF9w4dMz30JxEzzTaE//jzUzq9S5cRUth3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425853; c=relaxed/simple;
	bh=ViHKDrQlg894O9PqcV0PdH2ANHXZ5Ut8my4cTVo9mvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQwXjKfMtwCapQjHTDrtLeV0aEqy/sQeFgOzrm4ywwHvSBOhNgc/sjLys0WMacPIt1dOSNtot3G8aCY7SXIWAmd4P5c645mJf5vV4RR46LmtPyye3Hcj0V1VNn7/HojWNQAGLTw60bjlXlHc9u8Goc/EHGalhmGCulI5B5vIzEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXh+5WpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXh+5WpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD751F000E9;
	Thu, 30 Jul 2026 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425852;
	bh=s2F4fy6EP6H8wBXCkXiJscjxFTpNN/Yh/2S+28M7VB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SXh+5WpBVvuhf0ahGbqwPI552G1x4K1ocvD8ymvvS3Ls03k0cCbjrA+F00liWYPkJ
	 ZqL5W/vYkW9aBK4BRtiXQGL2FJYNwyFDTZt1WLQyU2UqwX8NySQ2XI011TKaaKsWfH
	 1H8vI1qj91mlmBfiFkF8dVVpS2ZKm8eeESCNsXiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/602] pds_core: reject component parameter in legacy firmware update
Date: Thu, 30 Jul 2026 16:09:39 +0200
Message-ID: <20260730141439.891193681@linuxfoundation.org>
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
index 621791a3c543be..e35572f099c884 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -89,6 +89,12 @@ int pdsc_dl_flash_update(struct devlink *dl,
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



