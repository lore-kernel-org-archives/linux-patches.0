Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4F3D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C847C433D2;
	Mon, 12 Jun 2023 10:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566919;
	bh=mGZrr/LPsl6t8Pk7sFPaz+obT8vrPqAyzdieYWFz4CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r76ynGyj93Um3TpaO9SrzklvxCmN0qKHEoE7FBtT1T8H96DukoB+0lkJAwaizXURU
	 PdjA1yHNggRC/fsjuoqcibYZcfvbmRNdnpp7n9sAsyVQMgsFVaVzinabrooz07XnX7
	 zTzBPO/osibB2MVM1+XK1leh6lCojHnrWM8SlCWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH 6.3 053/160] ice: make writes to /dev/gnssX synchronous
Date: Mon, 12 Jun 2023 12:26:25 +0200
Message-ID: <20230612101717.451239201@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit bf15bb38ec7f4ff522da5c20e1673dbda7159938 ]

The current ice driver's GNSS write implementation buffers writes and
works through them asynchronously in a kthread. That's bad because:
 - The GNSS write_raw operation is supposed to be synchronous[1][2].
 - There is no upper bound on the number of pending writes.
   Userspace can submit writes much faster than the driver can process,
   consuming unlimited amounts of kernel memory.

A patch that's currently on review[3] ("[v3,net] ice: Write all GNSS
buffers instead of first one") would add one more problem:
 - The possibility of waiting for a very long time to flush the write
   work when doing rmmod, softlockups.

To fix these issues, simplify the implementation: Drop the buffering,
the write_work, and make the writes synchronous.

I tested this with gpsd and ubxtool.

[1] https://events19.linuxfoundation.org/wp-content/uploads/2017/12/The-GNSS-Subsystem-Johan-Hovold-Hovold-Consulting-AB.pdf
    "User interface" slide.
[2] A comment in drivers/gnss/core.c:gnss_write():
        /* Ignoring O_NONBLOCK, write_raw() is synchronous. */
[3] https://patchwork.ozlabs.org/project/intel-wired-lan/patch/20230217120541.16745-1-karol.kolacinski@intel.com/

Fixes: d6b98c8d242a ("ice: add write functionality for GNSS TTY")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c |  2 +-
 drivers/net/ethernet/intel/ice/ice_common.h |  2 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c   | 64 ++-------------------
 drivers/net/ethernet/intel/ice/ice_gnss.h   | 10 ----
 4 files changed, 6 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index c2fda4fa4188c..b534d7726d3e8 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -5169,7 +5169,7 @@ ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
  */
 int
 ice_aq_write_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
-		 u16 bus_addr, __le16 addr, u8 params, u8 *data,
+		 u16 bus_addr, __le16 addr, u8 params, const u8 *data,
 		 struct ice_sq_cd *cd)
 {
 	struct ice_aq_desc desc = { 0 };
diff --git a/drivers/net/ethernet/intel/ice/ice_common.h b/drivers/net/ethernet/intel/ice/ice_common.h
index 8ba5f935a092b..81961a7d65985 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.h
+++ b/drivers/net/ethernet/intel/ice/ice_common.h
@@ -229,7 +229,7 @@ ice_aq_read_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
 		struct ice_sq_cd *cd);
 int
 ice_aq_write_i2c(struct ice_hw *hw, struct ice_aqc_link_topo_addr topo_addr,
-		 u16 bus_addr, __le16 addr, u8 params, u8 *data,
+		 u16 bus_addr, __le16 addr, u8 params, const u8 *data,
 		 struct ice_sq_cd *cd);
 bool ice_fw_supports_report_dflt_cfg(struct ice_hw *hw);
 #endif /* _ICE_COMMON_H_ */
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 8dec748bb53a4..12086aafb42fb 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -16,8 +16,8 @@
  * * number of bytes written - success
  * * negative - error code
  */
-static unsigned int
-ice_gnss_do_write(struct ice_pf *pf, unsigned char *buf, unsigned int size)
+static int
+ice_gnss_do_write(struct ice_pf *pf, const unsigned char *buf, unsigned int size)
 {
 	struct ice_aqc_link_topo_addr link_topo;
 	struct ice_hw *hw = &pf->hw;
@@ -72,39 +72,7 @@ ice_gnss_do_write(struct ice_pf *pf, unsigned char *buf, unsigned int size)
 	dev_err(ice_pf_to_dev(pf), "GNSS failed to write, offset=%u, size=%u, err=%d\n",
 		offset, size, err);
 
-	return offset;
-}
-
-/**
- * ice_gnss_write_pending - Write all pending data to internal GNSS
- * @work: GNSS write work structure
- */
-static void ice_gnss_write_pending(struct kthread_work *work)
-{
-	struct gnss_serial *gnss = container_of(work, struct gnss_serial,
-						write_work);
-	struct ice_pf *pf = gnss->back;
-
-	if (!pf)
-		return;
-
-	if (!test_bit(ICE_FLAG_GNSS, pf->flags))
-		return;
-
-	if (!list_empty(&gnss->queue)) {
-		struct gnss_write_buf *write_buf = NULL;
-		unsigned int bytes;
-
-		write_buf = list_first_entry(&gnss->queue,
-					     struct gnss_write_buf, queue);
-
-		bytes = ice_gnss_do_write(pf, write_buf->buf, write_buf->size);
-		dev_dbg(ice_pf_to_dev(pf), "%u bytes written to GNSS\n", bytes);
-
-		list_del(&write_buf->queue);
-		kfree(write_buf->buf);
-		kfree(write_buf);
-	}
+	return err;
 }
 
 /**
@@ -224,8 +192,6 @@ static struct gnss_serial *ice_gnss_struct_init(struct ice_pf *pf)
 	pf->gnss_serial = gnss;
 
 	kthread_init_delayed_work(&gnss->read_work, ice_gnss_read);
-	INIT_LIST_HEAD(&gnss->queue);
-	kthread_init_work(&gnss->write_work, ice_gnss_write_pending);
 	kworker = kthread_create_worker(0, "ice-gnss-%s", dev_name(dev));
 	if (IS_ERR(kworker)) {
 		kfree(gnss);
@@ -285,7 +251,6 @@ static void ice_gnss_close(struct gnss_device *gdev)
 	if (!gnss)
 		return;
 
-	kthread_cancel_work_sync(&gnss->write_work);
 	kthread_cancel_delayed_work_sync(&gnss->read_work);
 }
 
@@ -304,10 +269,7 @@ ice_gnss_write(struct gnss_device *gdev, const unsigned char *buf,
 	       size_t count)
 {
 	struct ice_pf *pf = gnss_get_drvdata(gdev);
-	struct gnss_write_buf *write_buf;
 	struct gnss_serial *gnss;
-	unsigned char *cmd_buf;
-	int err = count;
 
 	/* We cannot write a single byte using our I2C implementation. */
 	if (count <= 1 || count > ICE_GNSS_TTY_WRITE_BUF)
@@ -323,24 +285,7 @@ ice_gnss_write(struct gnss_device *gdev, const unsigned char *buf,
 	if (!gnss)
 		return -ENODEV;
 
-	cmd_buf = kcalloc(count, sizeof(*buf), GFP_KERNEL);
-	if (!cmd_buf)
-		return -ENOMEM;
-
-	memcpy(cmd_buf, buf, count);
-	write_buf = kzalloc(sizeof(*write_buf), GFP_KERNEL);
-	if (!write_buf) {
-		kfree(cmd_buf);
-		return -ENOMEM;
-	}
-
-	write_buf->buf = cmd_buf;
-	write_buf->size = count;
-	INIT_LIST_HEAD(&write_buf->queue);
-	list_add_tail(&write_buf->queue, &gnss->queue);
-	kthread_queue_work(gnss->kworker, &gnss->write_work);
-
-	return err;
+	return ice_gnss_do_write(pf, buf, count);
 }
 
 static const struct gnss_operations ice_gnss_ops = {
@@ -436,7 +381,6 @@ void ice_gnss_exit(struct ice_pf *pf)
 	if (pf->gnss_serial) {
 		struct gnss_serial *gnss = pf->gnss_serial;
 
-		kthread_cancel_work_sync(&gnss->write_work);
 		kthread_cancel_delayed_work_sync(&gnss->read_work);
 		kthread_destroy_worker(gnss->kworker);
 		gnss->kworker = NULL;
diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h b/drivers/net/ethernet/intel/ice/ice_gnss.h
index 4d49e5b0b4b81..d95ca3928b2ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
@@ -23,26 +23,16 @@
 #define ICE_MAX_UBX_READ_TRIES		255
 #define ICE_MAX_UBX_ACK_READ_TRIES	4095
 
-struct gnss_write_buf {
-	struct list_head queue;
-	unsigned int size;
-	unsigned char *buf;
-};
-
 /**
  * struct gnss_serial - data used to initialize GNSS TTY port
  * @back: back pointer to PF
  * @kworker: kwork thread for handling periodic work
  * @read_work: read_work function for handling GNSS reads
- * @write_work: write_work function for handling GNSS writes
- * @queue: write buffers queue
  */
 struct gnss_serial {
 	struct ice_pf *back;
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work read_work;
-	struct kthread_work write_work;
-	struct list_head queue;
 };
 
 #if IS_ENABLED(CONFIG_GNSS)
-- 
2.39.2



