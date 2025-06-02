Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66922229B26;
	Mon,  2 Jun 2025 14:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873194; cv=none; b=RPqgOs63G38vlOOTK5FG03uhirdGFVic/eVkNtmv83wAMQuDGaM6lXqp3JFXHvqsBQClhbHvK5Ko4ripZuOk+3e7J6fgk27bFvZf//wnpOu9h9snhkD23629W5xh6BONbIQLn1dgZ+LRR/ljLol2+A9gN0qP7ov+5fZb1DR5xvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873194; c=relaxed/simple;
	bh=WfxRRMSHwS6Bcf0jlVIaybV7LPhMuHWo/qOYdJDj6vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu8Fb0WZMryWyoP1qyoFm7Zq8tBI4lZAihuhOFuIfOlAEkgFKXMFJ1pv9hz+BsdlGEDLEzcvl8XOvZlrGcz+2dkjvOXOXaFqC3wDk84XDebH804R0npAaepk/TL4c/XnmwSinLr6CdvXbeuIXiTh9d8Pqbh90/fOnbTuifxVgxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+PBIjhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+PBIjhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED95CC4CEEB;
	Mon,  2 Jun 2025 14:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873194;
	bh=WfxRRMSHwS6Bcf0jlVIaybV7LPhMuHWo/qOYdJDj6vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+PBIjhNpN9U48/Sq3+3XWyn3MPJuLnANJNXa6oriHtXFvOQymyNnXHsXn4JRbTXE
	 dcZxmh8+u726ScgB+DO5n7zvnKsBNIsMktEhatBKLHn66m1hpOAbAyAay2UuSclrzL
	 OhUi7FpvN3HYo4jgkzXk4ntqEivXiCGgGwJv/dO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/444] libnvdimm/labels: Fix divide error in nd_label_data_init()
Date: Mon,  2 Jun 2025 15:42:11 +0200
Message-ID: <20250602134343.636599481@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <rrichter@amd.com>

[ Upstream commit ef1d3455bbc1922f94a91ed58d3d7db440652959 ]

If a faulty CXL memory device returns a broken zero LSA size in its
memory device information (Identify Memory Device (Opcode 4000h), CXL
spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
driver:

 Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
 RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]

Code and flow:

1) CXL Command 4000h returns LSA size = 0
2) config_size is assigned to zero LSA size (CXL pmem driver):

drivers/cxl/pmem.c:             .config_size = mds->lsa_size,

3) max_xfer is set to zero (nvdimm driver):

drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);

4) A subsequent DIV_ROUND_UP() causes a division by zero:

drivers/nvdimm/label.c: /* Make our initial read size a multiple of max_xfer size */
drivers/nvdimm/label.c: read_size = min(DIV_ROUND_UP(read_size, max_xfer) * max_xfer,
drivers/nvdimm/label.c-                 config_size);

Fix this by checking the config size parameter by extending an
existing check.

Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/20250320112223.608320-1-rrichter@amd.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/label.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 082253a3a9560..04f4a049599a1 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -442,7 +442,8 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
 	if (ndd->data)
 		return 0;
 
-	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0) {
+	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0 ||
+	    ndd->nsarea.config_size == 0) {
 		dev_dbg(ndd->dev, "failed to init config data area: (%u:%u)\n",
 			ndd->nsarea.max_xfer, ndd->nsarea.config_size);
 		return -ENXIO;
-- 
2.39.5



