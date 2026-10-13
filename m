Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0F94F4D0C;
	Tue, 13 Oct 2026 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893832; cv=none; b=uia3SaU5TIx1WBymHnS9wDTHTPxfvkZppF/VIduSD7pZnwczim3cXlY0qd7l/w12kiIY3XAfH25muf2peHcT8GwwdqNLhCmbDrfbxXx8013TxPhYykgFlLdXVQauuSPD8ZKB61S4TCj6xqMxLGMBneIF1Jf0eEQ1+h/P85tIAPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893832; c=relaxed/simple;
	bh=EBlciVJUz/M/5s1hv9x6tCRHx+wODQl6mvxKJUIysWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvYgnMZKva9C/OALCrlBXhNUMQhx0UWhXzxmQX/695SlnfTTEqXQ5/kyr/wQZXnFbKDjkPwDiNSFY6Eb9fn5BJtEtZkOKeFnb+XOLs+qqUqUpdNCkKGw8ZKmrpJUkuPt3m8IjW8GG0e63MG/opt0vKrZGSCbKZAWbwJ6w/DdSX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duPF+PMw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duPF+PMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B311F000FF;
	Tue, 13 Oct 2026 12:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893830;
	bh=HojvQSwzQh20q8b/1VSyvHAyHKGXTgWShNPfIMYADDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duPF+PMwbYRMivzrdImpCklfd37ZyGvvlUJ92M7oE6GRJTHNJ19Zffxoz0Vm1EMIJ
	 MwbRw6t9Ebvy+sMa7o1wcMtNLtlfiluIVSIESjTvCOWJRsGWrOJazmwQgfGJGklVZY
	 zyg0yegX7AZ92IqtD6vr/qg6BKRs9taO+OcDMbYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 358/621] idpf: bound interrupt-vector register fill to the allocated array
Date: Tue, 13 Oct 2026 13:35:53 +0200
Message-ID: <20261013112929.345250706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index ee93987f90185..1df5e3f75606b 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_dev.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_dev.c
@@ -88,7 +88,7 @@ static int idpf_intr_reg_init(struct idpf_vport *vport,
 	if (!reg_vals)
 		return -ENOMEM;
 
-	num_regs = idpf_get_reg_intr_vecs(vport, reg_vals);
+	num_regs = idpf_get_reg_intr_vecs(vport, reg_vals, total_vecs);
 	if (num_regs < num_vecs) {
 		err = -EINVAL;
 		goto free_reg_vals;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
index bc47e194fbd25..9617911a87302 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
@@ -87,7 +87,7 @@ static int idpf_vf_intr_reg_init(struct idpf_vport *vport,
 	if (!reg_vals)
 		return -ENOMEM;
 
-	num_regs = idpf_get_reg_intr_vecs(vport, reg_vals);
+	num_regs = idpf_get_reg_intr_vecs(vport, reg_vals, total_vecs);
 	if (num_regs < num_vecs) {
 		err = -EINVAL;
 		goto free_reg_vals;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 5b22779f4dfac..7d9c46ab0ca5f 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -1310,11 +1310,12 @@ idpf_vport_init_queue_reg_chunks(struct idpf_vport_config *vport_config,
  * idpf_get_reg_intr_vecs - Get vector queue register offset
  * @vport: virtual port structure
  * @reg_vals: Register offsets to store in
+ * @num_vecs: number of entries the @reg_vals array can hold
  *
  * Returns number of registers that got populated
  */
 int idpf_get_reg_intr_vecs(struct idpf_vport *vport,
-			   struct idpf_vec_regs *reg_vals)
+			   struct idpf_vec_regs *reg_vals, int num_vecs)
 {
 	struct virtchnl2_vector_chunks *chunks;
 	struct idpf_vec_regs reg_val;
@@ -1338,7 +1339,7 @@ int idpf_get_reg_intr_vecs(struct idpf_vport *vport,
 		dynctl_reg_spacing = le32_to_cpu(chunk->dynctl_reg_spacing);
 		itrn_reg_spacing = le32_to_cpu(chunk->itrn_reg_spacing);
 
-		for (i = 0; i < num_vec; i++) {
+		for (i = 0; i < num_vec && num_regs < num_vecs; i++) {
 			reg_vals[num_regs].dyn_ctl_reg = reg_val.dyn_ctl_reg;
 			reg_vals[num_regs].itrn_reg = reg_val.itrn_reg;
 			reg_vals[num_regs].itrn_index_spacing =
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h
index dc2d50cfb3383..f58be7329a4fa 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.h
@@ -104,7 +104,7 @@ int idpf_vc_core_init(struct idpf_adapter *adapter);
 void idpf_vc_core_deinit(struct idpf_adapter *adapter);
 
 int idpf_get_reg_intr_vecs(struct idpf_vport *vport,
-			   struct idpf_vec_regs *reg_vals);
+			   struct idpf_vec_regs *reg_vals, int num_vecs);
 int idpf_queue_reg_init(struct idpf_vport *vport,
 			struct idpf_queue_id_reg_info *chunks);
 int idpf_vport_queue_ids_init(struct idpf_vport *vport,
-- 
2.53.0



