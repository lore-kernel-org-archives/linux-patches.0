Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549D435AC3E;
	Sat, 12 Sep 2026 08:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203153; cv=none; b=D91qxSPmlAPkWQ1PeCbrB3LuqcUJpCHRhrnXS4YaGA3vCfQNdJHjH7L/NrDsL5FNxDG/5HUzQStycqJP4D6VZCehu5Qk3JJVwfbvNION5tjZXiXnPBD8EZnvUuVQvv1mXkPob34I2aigQBuTKdNgbuUAQ3XWA9D+O6T+D1oTTXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203153; c=relaxed/simple;
	bh=gyHofU2kCFky0g1kgZHtzwbQJdsvw5NphDsRvlPLVCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnB6KYz9VCuzqebFlpR8TlEF7LaHmi4+uy5yweuG3m2rEO5ar3R4BnsqxZJ8dMAVcbe0ss6SGG/lQvwNyTSu4b2swYAKeQ3qByE2kf7k2dJXKyM5jiVT02mZmKOAG387uao1FoxPDV7dHl4C7CaK/BqeKP3AOPqRW7F2kR7fxhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4kcxwVI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4kcxwVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714341F000FF;
	Sat, 12 Sep 2026 08:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203152;
	bh=fPnSo1VQoUpEdDaSQs7qmClEO0PdVHc4uBLuzLfoPuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4kcxwVI35gx4TTSVI80FMFoYR/vGfayB7PIJ/HAQeROza+iqanWxR+h0PXfCe+Ip
	 soRb+Vn7yLmsk42YO3kMeGah+piCJOHrG30CPtGuzsAhmKlLUIr/jGetWj2NX/1HTY
	 RJgeP/gACKSBJori6QaYO28IBNl1VS+rBGFnYOoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Dave Tian <daveti@purdue.edu>,
	Weidong Zhu <weizhu@fiu.edu>,
	Chao Shi <coshi036@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1350/1815] nvme: reject passthrough of driver-managed Set Features
Date: Sat, 12 Sep 2026 08:51:40 +0200
Message-ID: <20260912065720.718089200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Shi <coshi036@gmail.com>

[ Upstream commit 1161be71d1ecf7dc785382114c71afed0349531e ]

Since commit b58da2d270db ("nvme: update keep alive interval when kato
is modified"), a Set Features (KATO) passthrough command lets userspace
start keep-alive on any transport. nvme_keep_alive_work() allocates with
BLK_MQ_REQ_RESERVED, but nvme_alloc_admin_tag_set() reserves admin tags
only for fabrics, so on other transports the allocation trips
WARN_ON_ONCE() in blk_mq_get_tag() and fails:

  nvme nvme0: keep-alive failed: -11

Several Set Features change controller state the driver manages itself
and cannot react to when set behind its back. Reject these in
nvme_admin_cmd_allowed():

  - KATO on non-fabrics (keep-alive is only armed for fabrics; on PCIe
    it has no reserved tag and harms idle power states)
  - Host Behavior Support, Host Memory Buffer, Number of Queues, and
    Autonomous Power State Transition (all driver-managed)

Keep Alive on fabrics is unchanged; I/O commands are unaffected as the
check is confined to the admin path (ns == NULL).

Link: https://lore.kernel.org/linux-nvme/20260523225629.3964037-1-coshi036@gmail.com/

Fixes: b58da2d270db ("nvme: update keep alive interval when kato is modified")

Found by FuzzNvme.

Acked-by: Sungwoo Kim <iam@sung-woo.kim>
Acked-by: Dave Tian <daveti@purdue.edu>
Acked-by: Weidong Zhu <weizhu@fiu.edu>
Signed-off-by: Chao Shi <coshi036@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/ioctl.c | 111 ++++++++++++++++++++++++--------------
 1 file changed, 72 insertions(+), 39 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 752d7b2490009..76596cb2ded2d 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -14,45 +14,54 @@ enum {
 	NVME_IOCTL_PARTITION	= (1 << 1),
 };
 
-static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
-		unsigned int flags, bool open_for_write)
+static bool nvme_admin_cmd_allowed(struct nvme_ctrl *ctrl,
+				   struct nvme_command *c)
 {
-	u32 effects;
-
-	/*
-	 * Do not allow unprivileged passthrough on partitions, as that allows an
-	 * escape from the containment of the partition.
-	 */
-	if (flags & NVME_IOCTL_PARTITION)
-		goto admin;
-
-	/*
-	 * Do not allow unprivileged processes to send vendor specific or fabrics
-	 * commands as we can't be sure about their effects.
-	 */
-	if (c->common.opcode >= nvme_cmd_vendor_start ||
-	    c->common.opcode == nvme_fabrics_command)
-		goto admin;
-
 	/*
 	 * Do not allow unprivileged passthrough of admin commands except
 	 * for a subset of identify commands that contain information required
 	 * to form proper I/O commands in userspace and do not expose any
 	 * potentially sensitive information.
 	 */
-	if (!ns) {
-		if (c->common.opcode == nvme_admin_identify) {
-			switch (c->identify.cns) {
-			case NVME_ID_CNS_NS:
-			case NVME_ID_CNS_CS_NS:
-			case NVME_ID_CNS_NS_CS_INDEP:
-			case NVME_ID_CNS_CS_CTRL:
-			case NVME_ID_CNS_CTRL:
-				return true;
-			}
+	switch (c->common.opcode) {
+	case nvme_admin_identify:
+		switch (c->identify.cns) {
+		case NVME_ID_CNS_NS:
+		case NVME_ID_CNS_CS_NS:
+		case NVME_ID_CNS_NS_CS_INDEP:
+		case NVME_ID_CNS_CS_CTRL:
+		case NVME_ID_CNS_CTRL:
+			return true;
 		}
-		goto admin;
+		break;
+	case nvme_admin_set_features:
+		/*
+		 * Reject Set Features that change controller state the driver
+		 * manages itself; setting them behind the driver's back from
+		 * userspace leaves it unable to react correctly. Keep Alive is
+		 * only armed for fabrics - on other transports it has no
+		 * reserved tag and harms idle power states.
+		 */
+		switch (le32_to_cpu(c->features.fid) & 0xff) {
+		case NVME_FEAT_KATO:
+			if (ctrl->ops->flags & NVME_F_FABRICS)
+				break;
+			fallthrough;
+		case NVME_FEAT_HOST_BEHAVIOR:
+		case NVME_FEAT_HOST_MEM_BUF:
+		case NVME_FEAT_NUM_QUEUES:
+		case NVME_FEAT_AUTO_PST:
+			return false;
+		}
+		break;
 	}
+	return capable(CAP_SYS_ADMIN);
+}
+
+static bool nvme_ns_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
+				bool open_for_write)
+{
+	u32 effects;
 
 	/*
 	 * Check if the controller provides a Commands Supported and Effects log
@@ -61,7 +70,7 @@ static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
 	 */
 	effects = nvme_command_effects(ns->ctrl, ns, c->common.opcode);
 	if (!(effects & NVME_CMD_EFFECTS_CSUPP))
-		goto admin;
+		return capable(CAP_SYS_ADMIN);
 
 	/*
 	 * Don't allow passthrough for command that have intrusive (or unknown)
@@ -70,7 +79,7 @@ static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
 	if (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC |
 			NVME_CMD_EFFECTS_UUID_SEL |
 			NVME_CMD_EFFECTS_SCOPE_MASK))
-		goto admin;
+		return capable(CAP_SYS_ADMIN);
 
 	/*
 	 * Only allow I/O commands that transfer data to the controller or that
@@ -79,11 +88,34 @@ static bool nvme_cmd_allowed(struct nvme_ns *ns, struct nvme_command *c,
 	 */
 	if ((nvme_is_write(c) || (effects & NVME_CMD_EFFECTS_LBCC)) &&
 	    !open_for_write)
-		goto admin;
+		return capable(CAP_SYS_ADMIN);
 
 	return true;
-admin:
-	return capable(CAP_SYS_ADMIN);
+}
+
+static bool nvme_cmd_allowed(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
+			     struct nvme_command *c, unsigned int flags,
+			     bool open_for_write)
+{
+	/*
+	 * Do not allow unprivileged passthrough on partitions, as that
+	 * allows an escape from the containment of the partition.
+	 */
+	if (flags & NVME_IOCTL_PARTITION)
+		return capable(CAP_SYS_ADMIN);
+
+	/*
+	 * Do not allow unprivileged processes to send vendor specific or
+	 * fabrics commands as we can't be sure about their effects.
+	 */
+	if (c->common.opcode >= nvme_cmd_vendor_start ||
+	    c->common.opcode == nvme_fabrics_command)
+		return capable(CAP_SYS_ADMIN);
+
+	if (!ns)
+		return nvme_admin_cmd_allowed(ctrl, c);
+
+	return nvme_ns_cmd_allowed(ns, c, open_for_write);
 }
 
 /*
@@ -261,7 +293,7 @@ static int nvme_submit_io(struct nvme_ns *ns, struct nvme_user_io __user *uio,
 	c.rw.lbat = cpu_to_le16(io.apptag);
 	c.rw.lbatm = cpu_to_le16(io.appmask);
 
-	if (!nvme_cmd_allowed(ns, &c, flags, open_for_write))
+	if (!nvme_cmd_allowed(ns->ctrl, ns, &c, flags, open_for_write))
 		return -EACCES;
 
 	return nvme_submit_user_cmd(ns->queue, &c, io.addr, length, metadata,
@@ -311,7 +343,7 @@ static int nvme_user_cmd(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
 	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
 
-	if (!nvme_cmd_allowed(ns, &c, 0, open_for_write))
+	if (!nvme_cmd_allowed(ctrl, ns, &c, 0, open_for_write))
 		return -EACCES;
 
 	if (cmd.timeout_ms)
@@ -358,7 +390,7 @@ static int nvme_user_cmd64(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	c.common.cdw14 = cpu_to_le32(cmd.cdw14);
 	c.common.cdw15 = cpu_to_le32(cmd.cdw15);
 
-	if (!nvme_cmd_allowed(ns, &c, flags, open_for_write))
+	if (!nvme_cmd_allowed(ctrl, ns, &c, flags, open_for_write))
 		return -EACCES;
 
 	if (cmd.timeout_ms)
@@ -453,6 +485,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	const struct nvme_uring_cmd *cmd = io_uring_sqe128_cmd(ioucmd->sqe,
 							       struct nvme_uring_cmd);
 	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
+	bool open_for_write = ioucmd->file->f_mode & FMODE_WRITE;
 	struct nvme_uring_data d;
 	struct nvme_command c;
 	struct iov_iter iter;
@@ -483,7 +516,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	c.common.cdw14 = cpu_to_le32(READ_ONCE(cmd->cdw14));
 	c.common.cdw15 = cpu_to_le32(READ_ONCE(cmd->cdw15));
 
-	if (!nvme_cmd_allowed(ns, &c, 0, ioucmd->file->f_mode & FMODE_WRITE))
+	if (!nvme_cmd_allowed(ctrl, ns, &c, 0, open_for_write))
 		return -EACCES;
 
 	d.metadata = READ_ONCE(cmd->metadata);
-- 
2.53.0



