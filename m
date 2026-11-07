Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062939;
	b=CFTzVv4Z8tLq62OHq47xiBNxkOcCmivrh7UBHZQk+xeUpc5u4c3uSQWGjbZl9beyHp0Y
	 iB7Hbqy0tQ3UX2/125F0MxJFeTJeL1NwpVOzB5iupCGOwSVrdZl8iITxRvGDAdHvdrBkZ
	 31WUWN+wjZlNCR9j4YIerna42GSQd3XBbUsezEp4L6SKLr+MDH8q8ylc6SgxvLlF+pV0E
	 ZLfaIt4LbQZzEOEkszJylyb1L5SjDQwrEnhGk91rDVcy8fVppGas3BMhXLrCNw+WPTpjp
	 oh6w5TWaMWCW1RdN51HywQ2IDG/dKXbTvATW4CHIXDR2Ozn702spOtPuIokwu3kNKnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gt3OloNMj0Yj9d+l1k1NwGgOAExklYGzCyGwHotqmwo=;
	b=34XMm+6ilDjVx8PQ9UPTsMUtefgEcUGiY8iICYxEdfu751/ZQ8AzR5HyCHEGJIXgBYjl
	 kwdDrzG+oVEoktiAK7Z/AYngW1LUZNMKezhY78pyNDbp8nVo9A7DarkDO9XH5rGdvkZ5/
	 BhZzlouo8lqfWwSzG32SzggSwKBpenTg4EqAGAA1zvJT+3N1jetv864TPJo7W9aHuN9Zh
	 aFBZVAMkkuNtYpyjmNxs7U2o7EYNklJcuaIeNkgXxLnH2CD17kdt9+w8sNQIMS4AWQ1nY
	 8yiEjRXxb9Dq23LdYXNO5rbnJf7z0Wi4EsEgEpUtXBnO/uMr/+3d84W3j9bcvxEciXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hk35LN+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B9B606A32C;
	Sat,  7 Nov 2026 14:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hk35LN+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921601F0089F;
	Sat,  7 Nov 2026 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062938;
	bh=Gt3OloNMj0Yj9d+l1k1NwGgOAExklYGzCyGwHotqmwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hk35LN+5Raq4c6ozKERctsT3gf5cWbrsmlvzDTvcZcaeIeEHshg4a/c42p1cryn9Z
	 EfPpd62be1/2CaLaChM4LhfYu53MfLtQoI6GzWZoATO8frYxuEUjZMYjmv5Q//Vkhl
	 PExkl9+6hc0Ps5ms99ixrlGOboZ9GYtiCwCRcKPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/869] crypto: qat - zero the VF migration state buffer on save
Date: Sat,  7 Nov 2026 08:48:09 -0500
Message-ID: <20261107134859.004600903@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 5d504e65516dde8c88117378292e9c78f3d2cf58 ]

The QAT VF migration state buffer is allocated with kmalloc(), while
qat_vf_save_state() exposes all state_size bytes to userspace. The state
manager writes only the serialized sections, leaving the unused tail
unchanged. The first save can therefore disclose stale heap contents,
and subsequent saves can disclose data left by an earlier migration.

Zero the whole buffer before writing the setup data. Once the setup data
is present, preserve it and zero the remaining state area before each
state save.

Fixes: f0bbfc391aa7 ("crypto: qat - implement interface for live migration")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
index adb21656a3ba8..91eff18a505b7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
@@ -837,6 +837,9 @@ static int adf_gen4_vfmig_save_state(struct qat_mig_dev *mdev)
 		return ret;
 	}
 
+	memset(mdev->state + mdev->setup_size, 0,
+	       mdev->state_size - mdev->setup_size);
+
 	adf_mstate_mgr_init(vfmig->mstate_mgr, mdev->state + mdev->setup_size,
 			    mdev->state_size - mdev->setup_size);
 	if (!adf_mstate_preamble_add(vfmig->mstate_mgr))
@@ -934,6 +937,8 @@ static int adf_gen4_vfmig_save_setup(struct qat_mig_dev *mdev)
 	if (mdev->setup_size)
 		return 0;
 
+	memset(mdev->state, 0, mdev->state_size);
+
 	adf_mstate_mgr_init(vfmig->mstate_mgr, mdev->state, mdev->state_size);
 	if (!adf_mstate_preamble_add(vfmig->mstate_mgr))
 		return -EINVAL;
-- 
2.53.0



