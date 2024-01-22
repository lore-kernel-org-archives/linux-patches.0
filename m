Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29D012F59D;
	Tue, 23 Jan 2024 01:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971760; cv=none; b=hwek9/VXiJVz4bN0IqyHeTLoe7k5d70WcT4UN++AVAvnLnE5xpl3yfCpAm+CGhNPTRZmcQuw2I4pefohS79Ps1W46TJ47NK8u7ngSnhWTLuxSvbBhvjcy1FQDQHYEXeWxf/n7tsszfjRO/qscxZjiu97yHuTKDXgHJhpgsnTrV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971760; c=relaxed/simple;
	bh=qhHxDubtN+Ka1POXkGVdukPk7V2kRTfZmG8wkNojZYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0+mYkzrRCLvm+c7ET/f6w5fO1Cf1GNstMgV1EzUwKKAuRKMlFtrpEWXEf/VelgBow/vS53MH+NiSJMGV5/4FMe6fNvBhR4YuXKZsaUHAzS7wbjskLhwtMQcLUKGIq/1k0JdN3OyaH9y8kK3jpBkvS88bFlAk6CRsHm5foY0H84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5OJLmX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5OJLmX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487FDC433C7;
	Tue, 23 Jan 2024 01:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971760;
	bh=qhHxDubtN+Ka1POXkGVdukPk7V2kRTfZmG8wkNojZYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5OJLmX82TFTokCOnfVqs56zehgGvVfARdu8rQkcd4+dq/PeQ9hzNxLdwVCfjMCm3
	 En4Em3bb+dwxDU1oauZZpT9WSLDc4+GT8cY7BJY+F6sbx0nHO8hsU7iP+vY0rOBQd9
	 1RyX3ftKTVQLvm4QpllhOZyrhvr4uNIWMJMflS/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Huang, Ying" <ying.huang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Huang
Subject: [PATCH 6.1 312/417] cxl/port: Fix decoder initialization when nr_targets > interleave_ways
Date: Mon, 22 Jan 2024 15:58:00 -0800
Message-ID: <20240122235802.626880036@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1403,7 +1403,7 @@ static int decoder_populate_targets(stru
 		return -EINVAL;
 
 	write_seqlock(&cxlsd->target_lock);
-	for (i = 0; i < cxlsd->nr_targets; i++) {
+	for (i = 0; i < cxlsd->cxld.interleave_ways; i++) {
 		struct cxl_dport *dport = find_dport(port, target_map[i]);
 
 		if (!dport) {


