Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25CC16A956;
	Tue, 30 Sep 2025 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245898; cv=none; b=Xn2bsSdie6c9pv+P7OqSe7WZBlbPq+x7UVp2luyCVLJmGBSr+3QM584uOm1xYgN1U9v1RVGuOfOuIyCtgdxzfunQcbopUCI+YkZlEBTEOuzZoUpnD77yLfZT+8OtgG2yHiRpYfwfLDZ+qg+l7M+leeHmeowpSMH5Hrh+eTOJS2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245898; c=relaxed/simple;
	bh=BvhApp6KqXsBG0Z8UgrKsjv+mVuT4hUt10Bqny8uA7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZrYwt1fLPu9k6Qht9p7vNukIE7HEN7lGLoTY/KOV7lOKUxbOgoBKf7GAf+zIQRJ7zNuG6u18qiwPv8BnqkCNfmt4P0HjcU7T9xBxEZ9nHOv/PdvCCI/K1neGd6RHnDOl2QJGDuwDq32PJ2JNiydWCrwzh1GeNp30XW7l+Fwapo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDUZATD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDUZATD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B57FC4CEF0;
	Tue, 30 Sep 2025 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245897;
	bh=BvhApp6KqXsBG0Z8UgrKsjv+mVuT4hUt10Bqny8uA7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDUZATD2t35w77Vri/ttzRFSF/FiQ7YpCuRLsx9JBTc77xiYNy9wuPMhOsE98DSPM
	 EDCbAFMy7zFR5lMEL/PeJ8fPj73/F89FXFYpR8WKdc1cjCFU4rkukChCIaG/47uiQD
	 fBQ6HyeBL9ihD13GLPi0OXFrozxfx0qi/xz9bKVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <David.Laight@aculab.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eliav Farber <farbere@amazon.com>
Subject: [PATCH 6.6 82/91] minmax: dont use max() in situations that want a C constant expression
Date: Tue, 30 Sep 2025 16:48:21 +0200
Message-ID: <20250930143824.582925602@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit cb04e8b1d2f24c4c2c92f7b7529031fc35a16fed ]

We only had a couple of array[] declarations, and changing them to just
use 'MAX()' instead of 'max()' fixes the issue.

This will allow us to simplify our min/max macros enormously, since they
can now unconditionally use temporary variables to avoid using the
argument values multiple times.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c         |    2 +-
 drivers/input/touchscreen/cyttsp4_core.c       |    2 +-
 drivers/irqchip/irq-sun6i-r.c                  |    2 +-
 drivers/net/can/usb/etas_es58x/es58x_devlink.c |    2 +-
 fs/btrfs/tree-checker.c                        |    2 +-
 lib/vsprintf.c                                 |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -708,7 +708,7 @@ static const char *smu_get_feature_name(
 size_t smu_cmn_get_pp_feature_mask(struct smu_context *smu,
 				   char *buf)
 {
-	int8_t sort_feature[max(SMU_FEATURE_COUNT, SMU_FEATURE_MAX)];
+	int8_t sort_feature[MAX(SMU_FEATURE_COUNT, SMU_FEATURE_MAX)];
 	uint64_t feature_mask;
 	int i, feature_index;
 	uint32_t count = 0;
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -871,7 +871,7 @@ static void cyttsp4_get_mt_touches(struc
 	struct cyttsp4_touch tch;
 	int sig;
 	int i, j, t = 0;
-	int ids[max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
+	int ids[MAX(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
 
 	memset(ids, 0, si->si_ofs.tch_abs[CY_TCH_T].max * sizeof(int));
 	for (i = 0; i < num_cur_tch; i++) {
--- a/drivers/irqchip/irq-sun6i-r.c
+++ b/drivers/irqchip/irq-sun6i-r.c
@@ -270,7 +270,7 @@ static const struct irq_domain_ops sun6i
 
 static int sun6i_r_intc_suspend(void)
 {
-	u32 buf[BITS_TO_U32(max(SUN6I_NR_TOP_LEVEL_IRQS, SUN6I_NR_MUX_BITS))];
+	u32 buf[BITS_TO_U32(MAX(SUN6I_NR_TOP_LEVEL_IRQS, SUN6I_NR_MUX_BITS))];
 	int i;
 
 	/* Wake IRQs are enabled during system sleep and shutdown. */
--- a/drivers/net/can/usb/etas_es58x/es58x_devlink.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
@@ -215,7 +215,7 @@ static int es58x_devlink_info_get(struct
 	struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
 	struct es58x_sw_version *bl_ver = &es58x_dev->bootloader_version;
 	struct es58x_hw_revision *hw_rev = &es58x_dev->hardware_revision;
-	char buf[max(sizeof("xx.xx.xx"), sizeof("axxx/xxx"))];
+	char buf[MAX(sizeof("xx.xx.xx"), sizeof("axxx/xxx"))];
 	int ret = 0;
 
 	if (es58x_sw_version_is_valid(fw_ver)) {
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -614,7 +614,7 @@ static int check_dir_item(struct extent_
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
-			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+			char namebuf[MAX(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
 
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1079,7 +1079,7 @@ char *resource_string(char *buf, char *e
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
 #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
-	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+	char sym[MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
 
 	char *p = sym, *pend = sym + sizeof(sym);


