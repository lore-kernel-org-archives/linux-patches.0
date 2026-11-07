Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061868;
	b=BrBYeEYd/rs55eTctWBWRZjrUCS+lOU+9GzaTt7l+7ztL3POlbQ+ctX0JG70molILwuL
	 unt8ejpo1nkFVIreX4Tv2TRi5uXVAjC1+M+/2GtTH7AVLZAeV/lGy3exwe+GCV659mKa+
	 vx2ix2fMie/Je+dDgIswoxb+0s/7KXL8PisZWnhRXJv301R/v6lnxYFHXI98jORNkF113
	 mWvznT0aPUJAYXvamSTMQhHA3bACZUFlBecSRnKuOkM+xpoC/aWiRqYss/4AHjFa3TwSA
	 bAsJecO/Sn62vUCbbBAcNwEXOcOHTY34jlvm5S8/ehcfweIoAKzDQsSH+5yHVvV5tHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NNj1ao9zg4ScTYejRDjqIBognm9KW0OkAGaWFkqnm3k=;
	b=ZtSVV85MyiuGMGSQuiI1bAGd9Za6WGjPwMbjOf4yQRsWiw8eKa84ITD6ay9nn2DEm1FJ
	 PpQL74ow/8GhtL/olYVkKsq/q6o/jy2bA7Vi8piFuCL9jmGTZ52Fq92ISPIBST4nyrCn3
	 r2aawGbn1+fvA6N2BTVOEWqYOilyk8twoVtsfh1dck+B3dqXzI/JzTjA2JqbZ4B1WjP/7
	 qOq/cYPFYMx2+HEp/KDagWoGneJS2PXmBMcEOPgnbxiTjtecXODcJKfkqZo/vC6yI6kAb
	 p5fKX94s1Q/m71x7mqVXjIydEVYALmXJ2RbpOEPcQ8PhGuOf6m8B+bKsvGA2TPBnKzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDLq6AYZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21506606A326;
	Sat,  7 Nov 2026 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZDLq6AYZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C223F1F0089F;
	Sat,  7 Nov 2026 14:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061868;
	bh=NNj1ao9zg4ScTYejRDjqIBognm9KW0OkAGaWFkqnm3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDLq6AYZNsKU6ZrQRlv2F0MBHLmSkRq0i5dMNoBXtgC6DvORxDtAIRYSoQpO39JJ6
	 S/66LB1E/wi9qFJBnrR4pw7YGCnHF0pftqRLdhluhavLwOkFELM09txchL1b9o/9PK
	 gnA3w/YTDIiYDjvty/WSIlG3c8eUfevEZlapEuxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0866/1536] iommufd: Fix event queue release use-after-free
Date: Sat,  7 Nov 2026 08:48:02 -0500
Message-ID: <20261107135021.872434620@linuxfoundation.org>
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

From: Nirmoy Das <nirmoyd@nvidia.com>

[ Upstream commit 440ca8a4b69f40088065b9e05ef11373292a254e ]

iommufd_eventq_fops_release() drops the file's users reference before
reading eventq->ictx. Once that reference is dropped, IOMMU_DESTROY in
another thread can remove and free the event queue, so the later load
accesses freed memory.

Read ictx while the users reference still pins the event queue, then
drop the reference and put the saved context. The context reference
taken by iommufd_eventq_init() keeps ictx valid until the put. Fault and
vEVENTQ file descriptors share this release path.

Fixes: 07838f7fd529 ("iommufd: Add iommufd fault object")
Cc: stable@vger.kernel.org
Assisted-by: LLM, Specula
Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
Link: https://patch.msgid.link/20261014133632.3440297-1-nirmoyd@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ sashal: Adapted eventq identifiers to fault identifiers in the existing fault release callback. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/fault.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
index bdaecb6e1f7a3..6e918eb0ffbf0 100644
--- a/drivers/iommu/iommufd/fault.c
+++ b/drivers/iommu/iommufd/fault.c
@@ -373,9 +373,11 @@ static __poll_t iommufd_fault_fops_poll(struct file *filep,
 static int iommufd_fault_fops_release(struct inode *inode, struct file *filep)
 {
 	struct iommufd_fault *fault = filep->private_data;
+	/* fault may be freed once the users reference is dropped. */
+	struct iommufd_ctx *ictx = fault->ictx;
 
 	refcount_dec(&fault->obj.users);
-	iommufd_ctx_put(fault->ictx);
+	iommufd_ctx_put(ictx);
 	return 0;
 }
 
-- 
2.53.0



