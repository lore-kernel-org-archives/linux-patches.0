Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063404;
	b=TbJ+h4TmVr22JCcwBvyepwFh5fQQnWRNXgxJsQJYlUcsmME4dhbVP+Wyf/+YVZh2pP3n
	 A7v9HiGDQ8g3l5ub2E+Fe9QftgmWNYySTpYBNjFfkxieKPrGfbmI0TsmLjodcYSZ8Rnng
	 YNolg2BgxD1HiiBSseWFY+FM2CcAOgcDYvYDCXFiMwgSj8IQrpFe8KhD9OmHJd+Dp8eFB
	 4OASueYShO4QgCfDzhalES8Dsxj3vmFIr1tsAoFuNkTxqiV125vQo6poBKoLw4AUseXlA
	 +8JSlUSo/FdoeG4uHyzzGvkY164cqdX/Z2XvAFtVpy5tSiX1Xlzy5lCNLetrqy12QNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DXfm9i1doDxUh1flUu2qvmMtWTxfnYwsRhmshm4geZY=;
	b=o7eay2UV79pLXaOt49R9SAg2w5wTMR7EM+BFS7/fJr24td2Iy2sZD88ZMfooLca2td3S
	 SSmIHHpzlYImLLzKkDX1RD1+cSowtZuh0nzNkd0Acw/cd81mO9QzNLAe2Y9w5Cn4DN8Y/
	 fVXVyzggQ0J7Wo33wKhxUFT8YOZnWjRHBVXeV3paj2CyBPCZRAItos/nu1dGxgvtmuLhS
	 OxGNBfGLwgf/kqMDzBzb4Od3k425IcSpEjug48FMXWqHEMj5lpP2EqMawXKEeyzt9sQYI
	 0d/KHb1YsBYi/7I8GMa56KeSepdFs2OTVfWQOS/39wk6tM1JGgkDeE/B+RRK16KyMSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXFb6H5v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E25A606EEA1;
	Sat,  7 Nov 2026 14:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lXFb6H5v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD611F008A4;
	Sat,  7 Nov 2026 14:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063404;
	bh=DXfm9i1doDxUh1flUu2qvmMtWTxfnYwsRhmshm4geZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXFb6H5v2J4nkmlvuriVAwbVgJ58kRorGLoTgihP3IFEFVLudcB2xB3m4wtuB+20R
	 E+ZrwPeWQFbhZDPIWpsY1zv25EnG4pQ8nSPnbSnYWj9WLtB7hFA4H3473rbPjPtvPl
	 zUlT7Vq0jw6+kGP8/s+vN1B7jiYI+8erSYGlhyr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 575/869] crypto: qat - fix use of destroyed vf2pf_lock on VF restart
Date: Sat,  7 Nov 2026 08:54:17 -0500
Message-ID: <20261107134912.712573565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 4921634ac0a9a65aaa5e41308aabda3d3f562ee3 ]

adf_dev_stop_async() sends the RESTARTING_COMPLETE message after
adf_dev_down() has returned, but adf_dev_down() already destroyed the
lock that message takes.

Both run in sequence in the same worker, so every PF restart locks a
destroyed mutex. With CONFIG_DEBUG_MUTEXES on a dh895xcc with 32 host-bound
VFs this trips on the first PF reset:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: kernel/locking/mutex.c:159 at mutex_lock+0x171/0x1c0
  Workqueue: adf_vf_stop_wq adf_dev_stop_async [intel_qat]
  Call Trace:
   adf_gen2_pfvf_send+0x210/0x530 [intel_qat]
   adf_vf2pf_notify_restart_complete+0x55/0x80 [intel_qat]
   adf_dev_stop_async+0xdb/0x140 [intel_qat]

The notification cannot move before adf_dev_down(): the PF waits for it
before its own reset and the VF must tear down its rings first.

vf2pf_lock protects the VF2PF CSR and is unrelated to the PF2VF bottom half
it is initialised alongside. Tie its lifetime to the accel device, next to
state_lock in adf_devmgr_add_dev()/adf_devmgr_rm_dev(), so it stays valid
for messages sent outside the device up/down cycle. It is only touched for
VFs, which set is_vf before adf_devmgr_add_dev() and keep it set until
adf_devmgr_rm_dev().

Fixes: 6f1b5236348f ("crypto: qat - fix recovery flow for VFs")
Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 8 ++++++++
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c  | 2 --
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index 680e6557fc946..833d3c8e4650c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -138,6 +138,12 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 	mutex_lock(&table_lock);
 	atomic_set(&accel_dev->ref_count, 0);
 	mutex_init(&accel_dev->state_lock);
+	/*
+	 * The VF2PF lock is used to send messages to the PF outside of the
+	 * device up/down cycle, so it must live as long as the accel device.
+	 */
+	if (accel_dev->is_vf)
+		mutex_init(&accel_dev->vf.vf2pf_lock);
 
 	/* PF on host or VF on guest - optimized to remove redundant is_vf */
 	if (!accel_dev->is_vf || !pf) {
@@ -257,6 +263,8 @@ void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
 		}
 	}
 unlock:
+	if (accel_dev->is_vf)
+		mutex_destroy(&accel_dev->vf.vf2pf_lock);
 	mutex_destroy(&accel_dev->state_lock);
 	list_del(&accel_dev->list);
 	mutex_unlock(&table_lock);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
index a4636ec9f9cac..9ff6f66483016 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_vf_isr.c
@@ -118,7 +118,6 @@ static int adf_setup_pf2vf_bh(struct adf_accel_dev *accel_dev)
 	tasklet_init(&accel_dev->vf.pf2vf_bh_tasklet,
 		     (void *)adf_pf2vf_bh_handler, (unsigned long)accel_dev);
 
-	mutex_init(&accel_dev->vf.vf2pf_lock);
 	return 0;
 }
 
@@ -126,7 +125,6 @@ static void adf_cleanup_pf2vf_bh(struct adf_accel_dev *accel_dev)
 {
 	tasklet_disable(&accel_dev->vf.pf2vf_bh_tasklet);
 	tasklet_kill(&accel_dev->vf.pf2vf_bh_tasklet);
-	mutex_destroy(&accel_dev->vf.vf2pf_lock);
 }
 
 static irqreturn_t adf_isr(int irq, void *privdata)
-- 
2.53.0



