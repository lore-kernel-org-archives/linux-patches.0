Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3774E34040F;
	Thu, 28 May 2026 19:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998296; cv=none; b=awKjAN3mrbNsIZP3VOkJQqQOSUofhfQxvMORStMIzzrY1+OlDNSorWbmljx2Zf59aQxvmr0RTnykGRGMuOMbB4h/m2dHr9hmaJejmJfuhgt2M0yUN7Rxs9JCqLmdkEc/XRMRTsniaMLcQRkMK3Obz8B8Ykfx52c5Jhn2IPdBpPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998296; c=relaxed/simple;
	bh=Q09E5pgzT4mpjjbRalxTPlkkWlt95ipSwfX2rT1G17g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iszAwd6y6RFNgNDrfxyXWvfsJDLZTxHnQ7YXKxYavYoiSkEXot9lGGFULvXCtQscMAmOE2JDXUDO214UwGEpvlecodQ5aVwJCyfdygFYS8fyJlofvleGvJODuBl78GR72F4Jpi+5IonNuS7Fo3VeKdS/s/LctNf1S+LY0FCg+WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fDdDAQqq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fDdDAQqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EE71F000E9;
	Thu, 28 May 2026 19:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998295;
	bh=CqWolaGS2vqdFTGKC+Lp78Eg7SHfnA4l2vqLZ4NiD6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDdDAQqq6wGfbMbz5lbGO1sYLDU+LORb/eHM3RsuLUGLj4XeXKr2jbudQrKY64phL
	 2Hena55TH/oCTUEJWSkZt1rQSLoKiNlnE4HdQajiL1CXk2YOIPMhNoEIPHvj6Ak/iE
	 8kXXj1lAJkvaMOxIKgkJ/I2IKoX+4mHUiIxh6qt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heechan Kang <gganji11@naver.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.0 124/461] fwctl: pds: Validate RPC input size before parsing
Date: Thu, 28 May 2026 21:44:13 +0200
Message-ID: <20260528194650.571663501@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heechan Kang <gganji11@naver.com>

commit e7537735028c3ad4b0bfc02ff8fa2a1a28aa04fe upstream.

The fwctl core allocates the device-specific RPC input buffer with
fwctl_rpc.in_len and passes that buffer to the driver callback.

pdsfc_fw_rpc() casts the buffer to struct fwctl_rpc_pds and then calls
pdsfc_validate_rpc(), which reads fields from that structure before
checking that the input buffer is large enough to contain it. A short
in_len can make pds_fwctl read beyond the allocation.

Reject pds RPC buffers that are smaller than struct fwctl_rpc_pds before
parsing any pds-specific fields.

Fixes: 92c66ee829b9 ("pds_fwctl: add rpc and query support")
Link: https://patch.msgid.link/r/20260517062232.1858747-1-gganji11@naver.com
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Heechan Kang <gganji11@naver.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fwctl/pds/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/fwctl/pds/main.c
+++ b/drivers/fwctl/pds/main.c
@@ -362,6 +362,9 @@ static void *pdsfc_fw_rpc(struct fwctl_u
 	void *out = NULL;
 	int err;
 
+	if (in_len < sizeof(*rpc))
+		return ERR_PTR(-EINVAL);
+
 	err = pdsfc_validate_rpc(pdsfc, rpc, scope);
 	if (err)
 		return ERR_PTR(err);


