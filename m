Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062387;
	b=M0yGWPYmWja+njwL2ree1CZDje3TLwylqjEuRa/hCydxsfknzkFcUwhcSp6b8b3A7TIG
	 remmSVzsVe2KvoHY0u8dqRLrM893xTHnJfRKZ13fkmeUlMj6WKFYylNr3oOICIiq/oq6X
	 ezS8IMQ89ojX1Pu4n2PRPqKQKDjsX9PSDgjWKwelaaCY8lENv/bnJlrDEMRgBiBtPacnL
	 SzhzjG3oweezFMjoW2S+WnCKAlg40TOLSNG2pS3MP1Bk3N/wL0w5ZGKpqVbwwNpSNgxaj
	 aAW7Z8oev8V7r50ppJsySDK2R2tv9emrakoY/5v8PBOvhPdZxwLk19ZsACFlOiOltDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AczrpitbVQGNDRJEU1eciG8kVVPgYSMJvMLDzYIXz3s=;
	b=aHu3pNz6c+o2EQXkTMB4fckdEXD5rkFWblB1uRb3oyrBvHp+Z4IIqrv2uySv3oQ23VQM
	 RBDVZ8+jAi+lldEUWYbtJZZwQpeWHNZKkCZDFoC+4ZPxNESbtutvP7f3+Ah37rV7gAf5a
	 Nc73y3ctiQY3jzDMyTQ7SYRHN5CLeXnL5lA3PLllldFjPF4DVboJQA4+uR4PQySzQYjJw
	 Sne6q4tMA4L/OaaGctl4s6eKTghzviT5oGGiS7KxdxhlNc+z5m9oAiT0hAz7oh0BJTIcG
	 sO029uU3fz3yDhGZq09CpiWKka9DLINt/QEC6ghXtYBaECl2hWR1Om3Z+QHvqm4JIiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCqbWx7b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1B6606EE87;
	Sat,  7 Nov 2026 14:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCqbWx7b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5924E1F0089F;
	Sat,  7 Nov 2026 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062386;
	bh=AczrpitbVQGNDRJEU1eciG8kVVPgYSMJvMLDzYIXz3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCqbWx7bqbuBMdGdaNNZDDvxufRL5elz047DeOJgrP0xLoHWw5/FhXl6IC7sI4iXf
	 eoex16sGgxWzm0zEvbyydOsXq3QApQvMi8d3LEdbtZAHwnv9KyNAYfCPjUWBXmRD/J
	 zeSWn6QVdoywUkeY9muaBUOrisY52uDYVjcvuwjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1306/1536] crypto: qat - fix use of destroyed vf2pf_lock on VF restart
Date: Sat,  7 Nov 2026 08:55:22 -0500
Message-ID: <20261107135034.472087593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f7cabb37056d..58b7ea7793fe3 100644
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



