Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036602;
	b=thgdFP7wZBxTeFemxMsI9i8WdGzjusUuhdSiI8h2rAWAVcr6sUtDm/p0JYoygF+Egl73
	 syMYkidbZ0m/52t4iZRkFuKvGVuC+wwCl8YedTZ33M5MZs61Nszir0L7YmRqy0YsIglL5
	 IWc2DHbiDXN3TpgXfOQtc2KfSeKGGNKvhsZDilZDI3M+qW3t5Ay4CLyusawrhAmK+0FQH
	 yu8EdKBYfCTFFnkq7JpsY8Xp697UaTx5VLWfBLU97g2GeWIh94nkezo30rI67wOqPFpB/
	 6jYFsd6UDR5ncKht8uxjDQDVj6ainUMLvu9eLEhaN9lVTdIb3PVZdAtebSmo9/CzS1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vDJxDpDv3V4bWnfalcpblpT5hKRsHDKsC4QgjqoPseA=;
	b=qGjpjMPXHjC/fIXIdUR0FTstYFujy8zsyowIkWXGPeSnOeT/XDGmKyHS3aGi6O19C959
	 FD/eajS0mQ7ul9BXvy6G6htDvF0yu8RKgdM1VuRvyiz2giFKhis50TfulSz5YWeeWaVb8
	 Vl62YbYZs9Jx98wWat6m1vln6NMa0dROdUFTnJh5jaku0T3vaeACmxQxuOeV09nQzsgwI
	 6ml5hNxQ+h1hLDSqC7U8EJ33NcN3NGGIltwBGjueVWeluv9C06JDVlLSNHRAZ2dKxsYjW
	 57S44Ig+K6j3VBjjgiMnaP9WGnrcyNuB2/lvdT/HWAiNKO8ajIy5hAYiv2pNwrED8pA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWOs2qHV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19357606A320;
	Wed, 18 Nov 2026 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWOs2qHV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711951F000C4;
	Wed, 18 Nov 2026 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036602;
	bh=vDJxDpDv3V4bWnfalcpblpT5hKRsHDKsC4QgjqoPseA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWOs2qHVmTONIWr29jO34eMlCp3Qag72f5T9cp5ls3MXypLBNwu2cC1zNHtLTLhCC
	 scO9Fak9EwMDYBweJqQ5Rak8auR1pwmK4dTG3FGeeSPocrFXXHICvpi5Y8Ca0xMt2l
	 b2Nl4coNdGjPXJNk1EpmUVRO2Xbee+91o+0HOvIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1119/3318] crypto: qat - initialise state_lock on every path in adf_devmgr_add_dev()
Date: Wed, 18 Nov 2026 15:29:01 +0100
Message-ID: <20261118150353.596519856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 4ad7c1bd5f3dcd3fd6efbb068d6ee2a68dddfece ]

state_lock is initialised at the end of adf_devmgr_add_dev(), but the VF
on host path whose id mapping already exists returns earlier via
'goto unlock'. That mapping outlives the VF, so this path is taken every
time a VF is recreated on a BDF that already hosted one, e.g.:

	echo 0 > sriov_numvfs
	echo 32 > sriov_numvfs

accel_dev is freshly allocated on each probe, so state_lock is left zeroed
and adf_dev_up() takes an uninitialised mutex. With CONFIG_DEBUG_MUTEXES
this is reported on a dh895xcc with 32 host-bound VFs:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: kernel/locking/mutex.c:159 at mutex_lock+0x171/0x1c0
  Call Trace:
   adf_dev_up+0x27/0xe0 [intel_qat]
   adf_probe+0x700/0xa80 [qat_dh895xccvf]
   local_pci_probe+0xd5/0x190

The same happens on teardown when adf_dev_down() locks it again.

Initialise the lock next to the other per-device state, before the tables
are updated, so it is done on every path.

Fixes: 1bdc85550a2b ("crypto: qat - fix concurrency issue when device state changes")
Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index 9bdfa5b1614fe..98aebbe044d56 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -137,6 +137,7 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 
 	mutex_lock(&table_lock);
 	atomic_set(&accel_dev->ref_count, 0);
+	mutex_init(&accel_dev->state_lock);
 
 	/* PF on host or VF on guest - optimized to remove redundant is_vf */
 	if (!accel_dev->is_vf || !pf) {
@@ -210,7 +211,6 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		map->attached = true;
 		list_add_tail(&map->list, &vfs_table);
 	}
-	mutex_init(&accel_dev->state_lock);
 unlock:
 	mutex_unlock(&table_lock);
 	return ret;
-- 
2.53.0



