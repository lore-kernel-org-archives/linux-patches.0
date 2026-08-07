Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8BA38C2C0;
	Fri,  7 Aug 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116881; cv=none; b=B6gD0QMrg1Nl12wWXk3B4AvRxOOxzge8+kWnPUkz0XGF1EunHKV2WQYyJj9c19PP4V6+dbYbxh9kb513YsyBlv03WKWL+ErkiJ/oqAsjKXrdJdVNplLHgJcfudsdB+bEuZQUi+HTB77Fq8XoemUulcwOShXJtigxp+tltTrLaB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116881; c=relaxed/simple;
	bh=bV4BTV/HXAeb9xnsJfHkKL2M/p8c6vSvcTgEYJu8QAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=icERYM3CQPEMV1uSHyCXs0rwGVc5as3YJ05X0iwbrWMP4y5HCqiZzk1tRPe0u1JDcKDKPVWdqVDW7XMqf48mzMQxS3eqFyAZra2LT27n6T5sVgXX/5ytTL2K2Y8USIlR7+TkX1SRGFrU++rxkxdpFUqrYj+3XyG1XOtNGl6uyFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuW1L1gU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuW1L1gU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C5C1F000E9;
	Fri,  7 Aug 2026 15:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116880;
	bh=ErJbsq6gpMOrZGVgMU4davWEFFNVWsQs1KVlMzF32/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuW1L1gUxpr/mkWYbDSth26S2hOkIjVWEav8a9B8zZzyh+MhDL4+j9Deh5bU8TsTl
	 Mx67Xlv9KCFgCEEfehx/dgmB2zPwSNO3GoSVFubZ+v9/5ORNrJKbyoSeLLy0BioEzk
	 ClkAuGsDUN2wwtFCO7j6kfF1MkQbRu5Bu2dKZw2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 124/438] idpf: bound interrupt-vector register fill to the allocated array
Date: Fri,  7 Aug 2026 16:35:20 +0200
Message-ID: <20260807143430.638502760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 9f7007ee9858c99aa43101bc8352c672fee85644 ]

idpf_get_reg_intr_vecs() fills the caller-allocated reg_vals[] array from
the VIRTCHNL2_OP_ALLOC_VECTORS reply in adapter->req_vec_chunks, bounding
its inner loop only by the per-chunk num_vectors. The array is sized
separately: idpf_intr_reg_init() allocates
kzalloc_objs(struct idpf_vec_regs, total_vecs) from
caps.num_allocated_vectors and only checks the returned count after the
fill. The sum of per-chunk num_vectors is never reconciled against
total_vecs, so a reply with a small num_allocated_vectors but chunks
summing higher writes past the end of reg_vals[].

Impact: a control plane (a PF or hypervisor device model) that returns a
VIRTCHNL2_OP_ALLOC_VECTORS reply whose per-chunk num_vectors sum exceeds
num_allocated_vectors writes struct idpf_vec_regs entries past the end of
the reg_vals kmalloc allocation (KASAN slab-out-of-bounds write).

Bound the fill loop to the array capacity passed in by the callers,
mirroring the sibling idpf_vport_get_q_reg(). The existing
num_regs < num_vecs check then rejects an undersized reply without the
out-of-bounds write happening first.

Fixes: d4d558718266 ("idpf: initialize interrupts and enable vport")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_dev.c      | 2 +-
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c   | 2 +-
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c | 5 +++--
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.h | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_dev.c b/drivers/net/ethernet/intel/idpf/idpf_dev.c
index 1a0c71c95ef12..4079a787657f1 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_dev.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_dev.c
@@ -87,7 +87,7 @@ static int idpf_intr_reg_init(struct idpf_vport *vport,
 	if (!reg_vals)
 		return -ENOMEM;
 
-	num_regs = idpf_get_reg_intr_vecs(adapter, reg_vals);
+	num_regs = idpf_get_reg_intr_vecs(adapter, reg_vals, total_vecs);
 	if (num_regs < num_vecs) {
 		err = -EINVAL;
 		goto free_reg_vals;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
index a07d7e808ca9b..6726084f6cfa0 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
@@ -86,7 +86,7 @@ static int idpf_vf_intr_reg_init(struct idpf_vport *vport,
 	if (!reg_vals)
 		return -ENOMEM;
 
-	num_regs = idpf_get_reg_intr_vecs(adapter, reg_vals);
+	num_regs = idpf_get_reg_intr_vecs(adapter, reg_vals, total_vecs);
 	if (num_regs < num_vecs) {
 		err = -EINVAL;
 		goto free_reg_vals;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index dc5ad784f456f..8bd6cca64c9bf 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -1318,11 +1318,12 @@ idpf_vport_init_queue_reg_chunks(struct idpf_vport_config *vport_config,
  * idpf_get_reg_intr_vecs - Get vector queue register offset
  * @adapter: adapter structure to get the vector chunks
  * @reg_vals: Register offsets to store in
+ * @num_vecs: number of entries the @reg_vals array can hold
  *
  * Return: number of registers that got populated
  */
 int idpf_get_reg_intr_vecs(struct idpf_adapter *adapter,
-			   struct idpf_vec_regs *reg_vals)
+			   struct idpf_vec_regs *reg_vals, int num_vecs)
 {
 	struct virtchnl2_vector_chunks *chunks;
 	struct idpf_vec_regs reg_val;
@@ -1346,7 +1347,7 @@ int idpf_get_reg_intr_vecs(struct idpf_adapter *adapter,
 		dynctl_reg_spacing = le32_to_cpu(chunk->dynctl_reg_spacing);
 		itrn_reg_spacing = le32_to_cpu(chunk->itrn_reg_spacing);
 
-		for (i = 0; i < num_vec; i++) {
+		for (i = 0; i < num_vec && num_regs < num_vecs; i++) {
 			reg_vals[num_regs].dyn_ctl_reg = reg_val.dyn_ctl_reg;
 			reg_vals[num_regs].itrn_reg = reg_val.itrn_reg;
 			reg_vals[num_regs].itrn_index_spacing =
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h
index 6876e3ed9d1be..9b1c9c86f6eac 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h
@@ -104,7 +104,7 @@ int idpf_vc_core_init(struct idpf_adapter *adapter);
 void idpf_vc_core_deinit(struct idpf_adapter *adapter);
 
 int idpf_get_reg_intr_vecs(struct idpf_adapter *adapter,
-			   struct idpf_vec_regs *reg_vals);
+			   struct idpf_vec_regs *reg_vals, int num_vecs);
 int idpf_queue_reg_init(struct idpf_vport *vport,
 			struct idpf_q_vec_rsrc *rsrc,
 			struct idpf_queue_id_reg_info *chunks);
-- 
2.53.0



