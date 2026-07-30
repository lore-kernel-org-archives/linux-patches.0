Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C6B442131;
	Thu, 30 Jul 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423974; cv=none; b=gGzUhSdnqXmTdCZNi0vLojhvDWyxySqybfFM0BKnJSeHVFomvfJkUjFt9Q7a/BOq307UlMEMy3e6zX1g2BDLoo5oRNs6fj7toWZ2GJlW+lXj60yjaIZw/9SX3LB5r6w9mziSr7+w9X+j2rg/iMj7M2iOumkZNm5KuSCp9WBG8FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423974; c=relaxed/simple;
	bh=Gj4PmBc3wKLQmh8gIvVrzJuPbMq/c4YPKIgvEbQ5fS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmPKmI5xi17P2fjqXV2i1i7ulX+sCU9denFd3ZxhN+9w5wEwswOktE41RNP6/FuzWrLH/Jo6aGwAqy+lkATVYeTCxkA4IMHyKMAQ5nn4Z77rQXiVFzYfjV4WRdjJQ/AVX9oxYAP9lnLyysniJKHFZJt3tdgXR+OOZkj/awOFnSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1s4UoZi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1s4UoZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34B61F000E9;
	Thu, 30 Jul 2026 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423973;
	bh=1dz80WXw7/9vh7aPYx7+X0STi0CG2ec6cGJrjI2Vtx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1s4UoZi5OwFmcvquV/KveDZee/o8UX9nuDaxbIvnUKXwEb09YFLjpondyuKl0/WY
	 JNk18aVnxDwlzT8DEC2d/yq2xtJvJCFXl7LgBxUAllxYjm8HyYowUZjcnrjRRIi+i1
	 HcpfwOgUX9DtJZ7j8UNpdmaPOUEqdYzt56a7T+94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 232/675] pds_core: reject component parameter in legacy firmware update
Date: Thu, 30 Jul 2026 16:09:22 +0200
Message-ID: <20260730141450.067524257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



