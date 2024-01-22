Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3162974E09;
	Tue, 23 Jan 2024 02:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975466; cv=none; b=IU+8XKNpks0dzkob8/Onmztv2BJmemqVGcO/q6xE10AlGrlZ6vYVBcQZMWua6GpKfIuL/bN27QglQzPlFMau5hLnREQ8B934zOGACnkn3zNELVlCRCtLLi/VsNRGkZVHS/d3FQ+XE6fsud/mdArwWI7BaD3/+IY0JcVKnv6tP/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975466; c=relaxed/simple;
	bh=M5ByOedDjmyGpICglvXWyjB2EZuPydmdz34xzeI8gwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM+DsVUwamw5iMIdOTGLdXtfmMOskPTrseYpE/aevxOd7bgwk6nRmk0zRW1fhiIF7eF78Hz8bSguSlSi+PgS7a/WpWvmuFfqtuCMZLCDP2bbwRK05ml2tXyEzNTSwutjNknjNNGpw3SNojf+pcgap4Y9VxhbNThrU9I/39x8+gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpWhfyiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpWhfyiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B40C43399;
	Tue, 23 Jan 2024 02:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975466;
	bh=M5ByOedDjmyGpICglvXWyjB2EZuPydmdz34xzeI8gwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpWhfyivBdt7zsBgXXZrB2IQQOBFBhpU+5BFelTQDFcK2kSuLjYpxNwIyU/6TOjza
	 BlXERNRG7vQix0FpE5VARcc+1FJyZTfXPdSk+SwVVHN4LQd20UKeynOCgxPqkTYYHn
	 VpPJHObIUTYZRq3Y8MGmduzpT6JKVBSV/F0K44nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Huang
Subject: [PATCH 6.6 422/583] cxl/port: Fix decoder initialization when nr_targets > interleave_ways
Date: Mon, 22 Jan 2024 15:57:53 -0800
Message-ID: <20240122235824.888818941@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Huang Ying <ying.huang@intel.com>

commit d6488fee66472b468ed88d265b14aa3f04dc3bdf upstream.

The decoder_populate_targets() helper walks all of the targets in a port
and makes sure they can be looked up in @target_map. Where @target_map
is a lookup table from target position to target id (corresponding to a
cxl_dport instance). However @target_map is only responsible for
conveying the active dport instances as indicated by interleave_ways.

When nr_targets > interleave_ways it results in
decoder_populate_targets() walking off the end of the valid entries in
@target_map. Given target_map is initialized to 0 it results in the
dport lookup failing if position 0 is not mapped to a dport with an id
of 0:

  cxl_port port3: Failed to populate active decoder targets
  cxl_port port3: Failed to add decoder
  cxl_port port3: Failed to add decoder3.0
  cxl_bus_probe: cxl_port port3: probe: -6

This bug also highlights that when the decoder's ->targets[] array is
written in cxl_port_setup_targets() it is missing a hold of the
targets_lock to synchronize against sysfs readers of the target list. A
fix for that is saved for a later patch.

Fixes: a5c258021689 ("cxl/bus: Populate the target list at decoder create")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Huang, Ying <ying.huang@intel.com>
[djbw: rewrite the changelog, find the Fixes: tag]
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1590,7 +1590,7 @@ static int decoder_populate_targets(stru
 		return -EINVAL;
 
 	write_seqlock(&cxlsd->target_lock);
-	for (i = 0; i < cxlsd->nr_targets; i++) {
+	for (i = 0; i < cxlsd->cxld.interleave_ways; i++) {
 		struct cxl_dport *dport = find_dport(port, target_map[i]);
 
 		if (!dport) {


