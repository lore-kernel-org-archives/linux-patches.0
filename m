Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E3D56B68;
	Tue, 23 Jan 2024 00:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970028; cv=none; b=i0GjOsz52/Ah7Bz3HasgwwuVldIS7PirV79u5Ml1XHGgPRV5lzq5xvS8XQmGUlGFfH7jSJVl/iCnyT614ns5W3evqo0/qLye1q9Qmpg3OZ9pQiAhIiaIKiv08YYgpHETJtI6HI29nr1bkO+i8gjDpCfPi9RZlKEDZVZWi1rYnHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970028; c=relaxed/simple;
	bh=kBVhwdGRQhBoqBvfmp8Nd70XvSrKJCygc68WuEzlaE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e973L00Nqm1KlHcfCF3DZZJ5WJBu7vYdYwEtTOBl7O0qziHolyY0dVp7J/yBIvYZhVOsu/co03GN6EE4rviYg2oMd59ZPlVhDCNUIbskenvkIAYzWqekeLIr6XBE1/CwXssrni+DT3SdK68CnMSIFW6n+4tTNW38ywRi+w2slb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ev6sqZvQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ev6sqZvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA1FC433C7;
	Tue, 23 Jan 2024 00:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970028;
	bh=kBVhwdGRQhBoqBvfmp8Nd70XvSrKJCygc68WuEzlaE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ev6sqZvQVCS+frwNHhmt7PZLXDKKQ74pcDyXEwnJb5LOHBM98v9/g7csI94F4YbL9
	 wx8ooUWwEn90E4mZx4tCktSpj1aDkWlb2M2woi/cqnf9ukS7PS5/9UJXLQdfMuwgQr
	 91MyUkE08KReZ1r5lfc9AO564PLGGQH/lvbbgTlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 568/641] cxl/port: Fix missing target list lock
Date: Mon, 22 Jan 2024 15:57:52 -0800
Message-ID: <20240122235835.935281636@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 5459e186a5c9f412334321cff58d70dcb0e48a04 ]

cxl_port_setup_targets() modifies the ->targets[] array of a switch
decoder. target_list_show() expects to be able to emit a coherent
snapshot of that array by "holding" ->target_lock for read. The
target_lock is held for write during initialization of the ->targets[]
array, but it is not held for write during cxl_port_setup_targets().

The ->target_lock() predates the introduction of @cxl_region_rwsem. That
semaphore protects changes to host-physical-address (HPA) decode which
is precisely what writes to a switch decoder's target list affects.

Replace ->target_lock with @cxl_region_rwsem.

Now the side-effect of snapshotting a unstable view of a decoder's
target list is likely benign so the Fixes: tag is presumptive.

Fixes: 27b3f8d13830 ("cxl/region: Program target lists")
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 22 +++++++---------------
 drivers/cxl/cxl.h       |  2 --
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 57495cdc181f..6b386771cc25 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -172,14 +172,10 @@ static ssize_t target_list_show(struct device *dev,
 {
 	struct cxl_switch_decoder *cxlsd = to_cxl_switch_decoder(dev);
 	ssize_t offset;
-	unsigned int seq;
 	int rc;
 
-	do {
-		seq = read_seqbegin(&cxlsd->target_lock);
-		rc = emit_target_list(cxlsd, buf);
-	} while (read_seqretry(&cxlsd->target_lock, seq));
-
+	guard(rwsem_read)(&cxl_region_rwsem);
+	rc = emit_target_list(cxlsd, buf);
 	if (rc < 0)
 		return rc;
 	offset = rc;
@@ -1633,7 +1629,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_mem_find_port, CXL);
 static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 				    struct cxl_port *port, int *target_map)
 {
-	int i, rc = 0;
+	int i;
 
 	if (!target_map)
 		return 0;
@@ -1643,19 +1639,16 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 	if (xa_empty(&port->dports))
 		return -EINVAL;
 
-	write_seqlock(&cxlsd->target_lock);
+	guard(rwsem_write)(&cxl_region_rwsem);
 	for (i = 0; i < cxlsd->cxld.interleave_ways; i++) {
 		struct cxl_dport *dport = find_dport(port, target_map[i]);
 
-		if (!dport) {
-			rc = -ENXIO;
-			break;
-		}
+		if (!dport)
+			return -ENXIO;
 		cxlsd->target[i] = dport;
 	}
-	write_sequnlock(&cxlsd->target_lock);
 
-	return rc;
+	return 0;
 }
 
 struct cxl_dport *cxl_hb_modulo(struct cxl_root_decoder *cxlrd, int pos)
@@ -1725,7 +1718,6 @@ static int cxl_switch_decoder_init(struct cxl_port *port,
 		return -EINVAL;
 
 	cxlsd->nr_targets = nr_targets;
-	seqlock_init(&cxlsd->target_lock);
 	return cxl_decoder_init(port, &cxlsd->cxld);
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 687043ece101..62fa96f8567e 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -412,7 +412,6 @@ struct cxl_endpoint_decoder {
 /**
  * struct cxl_switch_decoder - Switch specific CXL HDM Decoder
  * @cxld: base cxl_decoder object
- * @target_lock: coordinate coherent reads of the target list
  * @nr_targets: number of elements in @target
  * @target: active ordered target list in current decoder configuration
  *
@@ -424,7 +423,6 @@ struct cxl_endpoint_decoder {
  */
 struct cxl_switch_decoder {
 	struct cxl_decoder cxld;
-	seqlock_t target_lock;
 	int nr_targets;
 	struct cxl_dport *target[];
 };
-- 
2.43.0



