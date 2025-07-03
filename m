Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F77F2EACE1;
	Thu,  3 Jul 2025 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554594; cv=none; b=QCpLDuz4tbwRDuGC8pYWHEDjGuhCGvpIanIAV8lVkE/HbpGviIf2gkm2A5S6hhC8QftEjiqhmc/E2FnUPSvkJnzQs7NYsjOYPEXueFLyjLCD+pSCy+Zc7Ma2OlGSSR1SPPeycVA6OKDqAb7HZVtQ8RIWtdGPfPbjrSrIq/9VdVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554594; c=relaxed/simple;
	bh=1ybA2YKoVKxtkiep5o0aNp5zR9FOYTtcZkh0KyEcKlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRPIdAo8yVFjsyIuUOPfKSBj+wZLlOr7Sc6zfDP5YDZo2AZ0AfI3u6eSeyli354sFxx1R3y0y3krEQ9iyiGx070rYYGhh3GBpPpmi4qgApPNOIF3H/pRez8npZ64dAPmtkxjr1A+KjIR8Dl/cEK9h5eBcVrMNTY40cmTvZyfLDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqTufh1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqTufh1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33C8C4CEE3;
	Thu,  3 Jul 2025 14:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554594;
	bh=1ybA2YKoVKxtkiep5o0aNp5zR9FOYTtcZkh0KyEcKlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqTufh1ZDFyRNK6Yi4lO+muDzo9Z9bwdkNzitnwLtxZp7IU2tdFs3ClOunQ9anE4t
	 iaxgiSQI9c80RaHrH3C/PNj7zlICexB20HsLiakElPk7dhd91UcCph/Soa0qWxbmlN
	 FmpLVe8JIYEv8wro4aBYA5MeysfWS9wqfIR851VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 019/263] cxl: core/region - ignore interleave granularity when ways=1
Date: Thu,  3 Jul 2025 16:38:59 +0200
Message-ID: <20250703144005.064149810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry@gourry.net>

[ Upstream commit ce32b0c9c522e5a69ef9c62a56d6ca08fb036d67 ]

When validating decoder IW/IG when setting up regions, the granularity
is irrelevant when iw=1 - all accesses will always route to the only
target anyway - so all ig values are "correct". Loosen the requirement
that `ig = (parent_iw * parent_ig)` when iw=1.

On some Zen5 platforms, the platform BIOS specifies a 256-byte
interleave granularity window for host bridges when there is only
one target downstream.  This leads to Linux rejecting the configuration
of a region with a x2 root with two x1 hostbridges.

Decoder Programming:
   root - iw:2 ig:256
   hb1  - iw:1 ig:256  (Linux expects 512)
   hb2  - iw:1 ig:256  (Linux expects 512)
   ep1  - iw:2 ig:256
   ep2  - iw:2 ig:256

This change allows all decoders downstream of a passthrough decoder to
also be configured as passthrough (iw:1 ig:X), but still disallows
downstream decoders from applying subsequent interleaves.

e.g. in the above example if there was another decoder south of hb1
attempting to interleave 2 endpoints - Linux would enforce hb1.ig=512
because the southern decoder would have iw:2 and require ig=pig*piw.

[DJ: Fixed up against 6.15-rc1]

Signed-off-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20250402232552.999634-1-gourry@gourry.net
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 24b161c7749f9..7585f0302f3a2 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1446,7 +1446,7 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 
 	if (test_bit(CXL_REGION_F_AUTO, &cxlr->flags)) {
 		if (cxld->interleave_ways != iw ||
-		    cxld->interleave_granularity != ig ||
+		    (iw > 1 && cxld->interleave_granularity != ig) ||
 		    !region_res_match_cxl_range(p, &cxld->hpa_range) ||
 		    ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)) {
 			dev_err(&cxlr->dev,
-- 
2.39.5



