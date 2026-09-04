Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE45E37C106;
	Fri,  4 Sep 2026 05:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501199; cv=none; b=BZS4UUi7cvOkX4P3oR8asvJO/eW+aKvs+T0Clt2TOQMxiXbfXqtEyaKBqn2jL9VBCC1ra057ul3V4hPecIdhHw7Xk2Ebt8d+C6eAmk8fOzaFnSV5oblK4Jcx7v4VgVOiYpoLS4NRBMzler7RXnv0yEl6ySVXqD73doaHCRpdS0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501199; c=relaxed/simple;
	bh=uBfHGEnp2gZv4Dhez1bH8gMr1XapbGkQiuwyZs9IH5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=le6pdq1Xu1BiRhEHOKoSWmFq7BW8hDuYuvNVlIF9fpNSzKsYOEzGso1Fo7Tum7v+EVTgZ5j20wATjH/WOImH+epvqkte1EantwPvAst/mkOKZFwnQLFoG1tmN9wzXn1zlv6z1uxqbVrZz9T/8MMSBoQw6gxb1hjRO2GOQUCMnZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpfhGWVM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpfhGWVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77641F00A3D;
	Fri,  4 Sep 2026 05:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501198;
	bh=xn4xPWlyjOL1HcjbxIvR8gDPWMtWfRWA3wo9C9wCKYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OpfhGWVMtGnqBpQteWeap2IEG1LXfqnUt6k34sDfT/18p0J4WfXm6od3Zc++i59/7
	 R48brmzVRJ11ltaBL2F8z8gioSoAg2f1++ZIluWvTJK1+JpEV4iX9mcS10tJb0NnvT
	 tm7OjU1ZC4ru5itbX/NOXd0CbwG6nK7d2fD/swsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 325/552] RDMA/uverbs: Add UVERBS_ATTR_UHW to UVERBS_METHOD_REG_MR
Date: Fri,  4 Sep 2026 06:58:02 +0200
Message-ID: <20260904045757.637330390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

commit 011199f46f44a9fd93a9e5ab5d7fd1328d80e9bf upstream.

The original commit missed that three drivers (mthca, irdma, siw) have UHW
data associated with reg_mr that cannot be passed through the ioctl. They
also assume that the udata cannot be NULL, so failing to pass a valid
udata can trigger a NULL udata crash in those drivers.

This never happens in real systems since in rdma-core ibv_cmd_reg_mr_ex()
does not accept a udata and those three drivers don't use it, however a
malicious userspace could trigger it.

Cc: stable@vger.kernel.org
Fixes: 5b2e45049dc0 ("IB/core: Add UVERBS_METHOD_REG_MR on the MR object")
Reported-by: Jacob Moroni <jmoroni@google.com>
Closes: https://lore.kernel.org/all/CAHYDg1TOGxRGZrS69d4Y--Shj_DZv0nJuM73iHUBwBM70g_t3Q@mail.gmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_std_types_mr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index 570b9656801d..0c72f801e0d3 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -364,7 +364,8 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_MR)(
 							dmah, attrs);
 	else
 		mr = pd->device->ops.reg_user_mr(pd, addr, length, iova,
-						 access_flags, dmah, NULL);
+						 access_flags, dmah,
+						 &attrs->driver_udata);
 
 	if (IS_ERR(mr))
 		return PTR_ERR(mr);
@@ -527,7 +528,8 @@ DECLARE_UVERBS_NAMED_METHOD(
 			    UA_MANDATORY),
 	UVERBS_ATTR_PTR_OUT(UVERBS_ATTR_REG_MR_RESP_RKEY,
 			    UVERBS_ATTR_TYPE(u32),
-			    UA_MANDATORY));
+			    UA_MANDATORY),
+	UVERBS_ATTR_UHW());
 
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	UVERBS_METHOD_MR_DESTROY,
-- 
2.55.0



