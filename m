Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3D433CC2;
	Fri, 24 Nov 2023 19:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iijspgcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6D8C433C7;
	Fri, 24 Nov 2023 19:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852551;
	bh=KjGacXoOLeQo9ZQgo8180g5jIdAW7jFiyzfRZ6mWPBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iijspgcJ7YtOo5s4UhVmUmzzfeLee+JXArmEia147OrWNXi3rJKP53cxvXnHx8cZ+
	 vr1a3C5IDouHcrsD8wltBZLj+Oncv+IiN1mjr0nwTqC2+vW1ONrwMshquBTZ0UejIr
	 0gZEwaxEjB74EnKFse3sUl/rGPuVAIll/9RfxPx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Jialin <lujialin4@huawei.com>,
	Guo Zihua <guozihua@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/193] crypto: pcrypt - Fix hungtask for PADATA_RESET
Date: Fri, 24 Nov 2023 17:52:35 +0000
Message-ID: <20231124171948.319140184@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Jialin <lujialin4@huawei.com>

[ Upstream commit 8f4f68e788c3a7a696546291258bfa5fdb215523 ]

We found a hungtask bug in test_aead_vec_cfg as follows:

INFO: task cryptomgr_test:391009 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Call trace:
 __switch_to+0x98/0xe0
 __schedule+0x6c4/0xf40
 schedule+0xd8/0x1b4
 schedule_timeout+0x474/0x560
 wait_for_common+0x368/0x4e0
 wait_for_completion+0x20/0x30
 wait_for_completion+0x20/0x30
 test_aead_vec_cfg+0xab4/0xd50
 test_aead+0x144/0x1f0
 alg_test_aead+0xd8/0x1e0
 alg_test+0x634/0x890
 cryptomgr_test+0x40/0x70
 kthread+0x1e0/0x220
 ret_from_fork+0x10/0x18
 Kernel panic - not syncing: hung_task: blocked tasks

For padata_do_parallel, when the return err is 0 or -EBUSY, it will call
wait_for_completion(&wait->completion) in test_aead_vec_cfg. In normal
case, aead_request_complete() will be called in pcrypt_aead_serial and the
return err is 0 for padata_do_parallel. But, when pinst->flags is
PADATA_RESET, the return err is -EBUSY for padata_do_parallel, and it
won't call aead_request_complete(). Therefore, test_aead_vec_cfg will
hung at wait_for_completion(&wait->completion), which will cause
hungtask.

The problem comes as following:
(padata_do_parallel)                 |
    rcu_read_lock_bh();              |
    err = -EINVAL;                   |   (padata_replace)
                                     |     pinst->flags |= PADATA_RESET;
    err = -EBUSY                     |
    if (pinst->flags & PADATA_RESET) |
        rcu_read_unlock_bh()         |
        return err

In order to resolve the problem, we replace the return err -EBUSY with
-EAGAIN, which means parallel_data is changing, and the caller should call
it again.

v3:
remove retry and just change the return err.
v2:
introduce padata_try_do_parallel() in pcrypt_aead_encrypt and
pcrypt_aead_decrypt to solve the hungtask.

Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Signed-off-by: Guo Zihua <guozihua@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/pcrypt.c | 4 ++++
 kernel/padata.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 9d10b846ccf73..005a36cb21bc4 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -117,6 +117,8 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
+	if (err == -EBUSY)
+		return -EAGAIN;
 
 	return err;
 }
@@ -164,6 +166,8 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
 	if (!err)
 		return -EINPROGRESS;
+	if (err == -EBUSY)
+		return -EAGAIN;
 
 	return err;
 }
diff --git a/kernel/padata.c b/kernel/padata.c
index 7d500219f96bd..fdcd78302cd72 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -207,7 +207,7 @@ int padata_do_parallel(struct padata_shell *ps,
 		*cb_cpu = cpu;
 	}
 
-	err =  -EBUSY;
+	err = -EBUSY;
 	if ((pinst->flags & PADATA_RESET))
 		goto out;
 
-- 
2.42.0



