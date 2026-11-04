Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827035;
	b=26T+yvvEo6kdVP3U/Fd74o/rZUzhHtKJEDb5vY4wVYVal0LFyS1xaXuWO0ngyQ1b6lX1
	 B5l/PDKn8xHmIdcC158mF7t7xK+wVkIV2CcCpD/L0CXjf7A95NDuTpjICkiCqZ+R3lTD4
	 +ax3FyqxrpmVgTN5nhPv9yhaOtnVOaR4Yxv/2eNPGybXBoCSFZvKUmdGD9gbnYZx46qvY
	 +Pqh1zYtzH55zLJAGZG+hq0cOfaoF5g+HWqi+g2dNnQe8z2C6XboKnwjawJjFMKhXTqfu
	 Fq7oQ/5P1o62F8stSdqQM58J5z6EUeoQzD1im0ntU2NA5UqgYlv+FTpEDsOwAuW2Yug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dAGkAkdZSo+vHMHNUH0HTDf16u1ywvTAjA2RF9nqo0w=;
	b=hDo3OeLTWH36sbjdNEkt0Y6AnWZG/49L4VRz8aFuj1KSTiM4tGTgU/Gaafx5Nzzkondm
	 aEsr5eoUsGrpEfTWZ99e308Ofu5TESHpGMXdYihoYJujrnosGnfRR9CJ4sem93BCTKSG+
	 l+azJeqxWr/7QanzNI8xmryd9DcFdFTDGOLde3yvWkM0UwnZdp2ZZmFvMCfWIe1hsr1vE
	 27wU/iho0AGH73NbAYmmSqH73a5mt277adjbjEwhu3LOWdrlYDCEW++xE0AF5rnakFMnM
	 iYbwU8YHjYt78sGhEyXzH+lUcmO6Pv/ZXD7rVhVaeyeFGLJzNvtu3dM6cqLL5lbc/Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFquyZsW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE055606AB10;
	Wed,  4 Nov 2026 21:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cFquyZsW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F021F000C1;
	Wed,  4 Nov 2026 21:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827034;
	bh=dAGkAkdZSo+vHMHNUH0HTDf16u1ywvTAjA2RF9nqo0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cFquyZsW9Ms7gDKxXfxn6QUHDy76z4dVdI3dme3BrvN6pj+RQyqxRwBifVeptFHK5
	 mqpuFw227lK64CJcuhgraZh2tbJiRrptr129xIqodNpItBGzev8TJkTpAEyhTULrE0
	 DPgEupnUjSc7qC+QbPtvHBulL7t7OlpwCJ0zv3/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.3 155/547] iommufd: Fix event queue release use-after-free
Date: Wed,  4 Nov 2026 16:05:39 -0500
Message-ID: <20261104211042.563576367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmoy Das <nirmoyd@nvidia.com>

commit 440ca8a4b69f40088065b9e05ef11373292a254e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommufd/eventq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -396,9 +396,11 @@ static __poll_t iommufd_eventq_fops_poll
 static int iommufd_eventq_fops_release(struct inode *inode, struct file *filep)
 {
 	struct iommufd_eventq *eventq = filep->private_data;
+	/* eventq may be freed once the users reference is dropped. */
+	struct iommufd_ctx *ictx = eventq->ictx;
 
 	refcount_dec(&eventq->obj.users);
-	iommufd_ctx_put(eventq->ictx);
+	iommufd_ctx_put(ictx);
 	return 0;
 }
 


