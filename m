Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213203;
	b=AQKfFta5ZdBJux7DYpB5edlVXpAEmloi9z+Ouxr0ZOtjAAWvrGlmC5dDJuhKr9gSfLsy
	 7/SDdr9VqlMjlA/wsNDMgUblKAmjwvx6dhTCln2RAle9H7L5k0FDgQ4rMG7mZcoHIY/7W
	 ES356BFQjjTJfrjy9BWst/2gg7gI0d2mK+v2SflymKZkdmmUKyydTrlJPEQ/K7tIlEQzH
	 YaqLgn40g0E1Rf/GNOIRJWA1IbHQDb2qxhnwHGGHg8qIacpaY3Ex6G52E7NzFm7hQeMPr
	 GViW9zqQYGNpQQjEzrOFGq0VmihJk/a5N7RcBR11ITXYW5mH81qbGIqAxsoWeAozjjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RAtEyVOV+RAWRKHW5y7+M6xtiuCu5kDcOM4ZKf1CPbU=;
	b=I2krBAzG32ysvO8QvmTtYl644oS0UexJ1k86b46MpZcKO96dj3pSigUtodwAHC4PeR0k
	 ScQUamDdy9LZPDG3l7V8LCK53CocC1j7lpb0allamh/5XP2Tk/ih/igZmbU4yFbqqtOWG
	 NBfEyl0SWEvb12RObpp0r1p1yTtX+rmqhtjmiE9jaNrt3Aw26w4JLQYRK4eptzox6h9kS
	 gg/OS0SBx6Ylo9OoJo7vWE4SamEVCpZB5g8/r83y49RUGzTJQIWoXnCNvSKrDLLJpt6l/
	 5unV9yDhEbv86X8e/bzK0acUXmjzjvRkgELR4kI5VyhnJpW4tPVi1uprhwoVHfP9kzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yE2fuIUT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8598B606A31A;
	Wed, 28 Oct 2026 18:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yE2fuIUT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AE31F01825;
	Wed, 28 Oct 2026 18:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213203;
	bh=RAtEyVOV+RAWRKHW5y7+M6xtiuCu5kDcOM4ZKf1CPbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yE2fuIUTLK2506hrl7lbt3hKFu89Rz+H/6F+zy9odl3VmDwg3nR5XnxL9Pa4bq3GX
	 f/LuxFhIkUR2dCv9+qcU2HCELdH7ZSoooH5xcrtqTPiPsa7AO7yz0a2+L5vrVJva/V
	 Gla9+2Fax6nbigwmkY9WX6+PrWvlOXQ5106PWx04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0422/1887] scsi: lpfc: Fix use-after-free of mboxq in lpfc_sli4_driver_resource_setup()
Date: Wed, 28 Oct 2026 17:41:58 +0100
Message-ID: <20261028170508.836716892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Misiurov <andrey.misyrov@gmail.com>

The 6.1.y backport of upstream commit 1bd28625e25b ("scsi: lpfc: Fix
memory leak in lpfc_sli4_driver_resource_setup()") added the new
mempool_free() of mboxq in the wrong place. Upstream frees mboxq after
the error handling of lpfc_get_sli4_parameters(). In 6.1.y the hunk
landed before that call, right after the NVMET WWN loop:

	mempool_free(mboxq, phba->mbox_mem_pool);
	lpfc_nvme_mod_param_dep(phba);
	rc = lpfc_get_sli4_parameters(phba, mboxq);

mbox_mem_pool is created a few lines earlier in the same function, so
the pool is full and mempool_free() really kfree()s mboxq.
lpfc_get_sli4_parameters() then builds and issues a mailbox command in
freed memory. This happens on every SLI4 probe. Its error paths also
free mboxq a second time.

Move the mempool_free() to where upstream and the other stable trees
have it.

Fixes: 299f5baa1321 ("scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()")
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 13ebbe4a71c47..fc5a640b7f742 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8175,7 +8175,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			}
 		}
 	}
-	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	lpfc_nvme_mod_param_dep(phba);
 
@@ -8209,6 +8208,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			goto out_free_bsmbx;
 		}
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * 1 for cmd, 1 for rsp, NVME adds an extra one
-- 
2.53.0



