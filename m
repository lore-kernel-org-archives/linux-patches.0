Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062058;
	b=d+/Zwm0Ey2LzEnv/GKOXJ89Bb0tcFkIO6a32nexGVjJMaZGEBI3/j6A+Ql1ios4/5Rpr
	 oh/Zh5BB3FMyUtpAQ9obJarS3yTNhHcyyjbALohV/zVBT1JNYzSB7adBsrNNv72vHPOff
	 +XMsmhsAfCEJE7SlitqK014pQET4eWd7yWeVSUxxv8eeF9Q3yJauk2CEcD3pcO/vWuvS+
	 UMoqyeNvdALB9no4xK2d5r+JeiREkpzSkYzHjeJGiGHsnXYRIAmYIw7Lr7Bp9xmBiqs1A
	 OQWKagmFl3daHUtC/nBdyJ75sX66w4xD3uXSmd/qqeQry6sNqxQQYMj37A8H9GKNEuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zn5olvCFCP4m0V/3uuBvKqjo9Mhd7d7E0TKizipFuQU=;
	b=PtO6lrbhXrKRvJBX4buREW+rp17wURQRtfJAGc+v9548CiHUxZkkuDKgwhR96Xir5xpp
	 uxpVpozhDIjOgyGRdl64T4cVecjzL+tF/oE7AnA9OjFmyJp6nENH/cy8ysr+iV947ZX9Y
	 zegPDoXQxad3L3inf3i3QE99E+CJrHzIuzB5wdpaWwd7LjCCZr/crrTH0/OYgUrrCOUAa
	 2t/ETqWPC5CZv8Cg56HR+GwhVIn4qYY1Sj5kVsvAtYSQPbUtTscTdpFlUudofkOBZARzi
	 5TibOLoxEYyClHdOzBZ0mR07Hb5ZPt4UxwerXwXfcBGQ81tvhigDzQST+fbKitiOKPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ys+w+VXm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D4606A332;
	Sat,  7 Nov 2026 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ys+w+VXm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F3E1F0089F;
	Sat,  7 Nov 2026 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062057;
	bh=Zn5olvCFCP4m0V/3uuBvKqjo9Mhd7d7E0TKizipFuQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ys+w+VXmibiF4aJBK3W/lkU/qmp54PiaHps8RXOBfI99bxxrcrrvNZXBZBf8FGpIb
	 WJ/eWnf9M9ocqFsP3cjOC0VkOf+gs4DWLvSSLwisonZS4o6eElp6mqCejUE2xzEsGi
	 g6PrKTNz09D15jJ9+HcWBVQ0y/CE37Nr+brFtSTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1039/1536] crypto: qat - zero the VF migration state buffer on save
Date: Sat,  7 Nov 2026 08:50:55 -0500
Message-ID: <20261107135026.857035586@linuxfoundation.org>
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
index a62eb5e8dbe6a..d9f96b02c9401 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_vf_mig.c
@@ -836,6 +836,9 @@ static int adf_gen4_vfmig_save_state(struct qat_mig_dev *mdev)
 		return ret;
 	}
 
+	memset(mdev->state + mdev->setup_size, 0,
+	       mdev->state_size - mdev->setup_size);
+
 	adf_mstate_mgr_init(vfmig->mstate_mgr, mdev->state + mdev->setup_size,
 			    mdev->state_size - mdev->setup_size);
 	if (!adf_mstate_preamble_add(vfmig->mstate_mgr))
@@ -933,6 +936,8 @@ static int adf_gen4_vfmig_save_setup(struct qat_mig_dev *mdev)
 	if (mdev->setup_size)
 		return 0;
 
+	memset(mdev->state, 0, mdev->state_size);
+
 	adf_mstate_mgr_init(vfmig->mstate_mgr, mdev->state, mdev->state_size);
 	if (!adf_mstate_preamble_add(vfmig->mstate_mgr))
 		return -EINVAL;
-- 
2.53.0



