Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831467;
	b=Bu7hUTCu1T2sHfj1j+aHPfKvG39dCJwC7MhJdfNnC3IR/kGxrm6oWNqChKgTg2kXgXeR
	 m5bUr68JOSdIcQUhftMlfeWA9irzB1w0464ZG7tzcGKjLnnIUpJ8k71BV8g0PnyUhbI05
	 7FE3b/3duTwM/zek249jJEGCQ2nEvI1yVq3lmmrYtiULVdPHFYVegVTnY70eXAJ2URQ26
	 Eqa6LoH0ArhrE5Ncds96hXgKKaI6T3exnKgRRFz6k8v+lfIoypXCI0KOcZ9tT8XIcH84i
	 JiI9WoDd27LUXp628ea+uhDTY7c4rZPE3a7XDM3qTIRTPvfCa/ZSPAu9cr+3Me9gcMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=082d0UNRm75HELP+vmE4Qo56IemPB8O0W58fYCmXpx4=;
	b=o8ZPZW/jQ98pkt8W4FI07wal/tDTvNeTfP3NVfQP7setAQZDf0WMETq4faJOQQIjFcBQ
	 qy7BIq+1y0yMiiSE/PqbXwT087mR843vexUwzAbiB0NrjfibBDMDzMe1L7COqhX6ZE4e2
	 91F97EWzh+xLWhp9+8pIf6N6gd9wl9/4njmozQ7QZV/IyEQslwiDiSpAvF78o2ehQHTyd
	 nKAoTqQ7CbdOV602zDtoWJR/gTnEdEroJzoVsrboiehS0b7ukGdMFDo9LvHzMcENeMSdz
	 YCtyu5drE6HHnUm4yo+ge+1ZnnWZngV1wdCDm2M7F4RUEH81TGcajZ8tQ1OwwYCShHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8p8Zral;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16AF606AC2E;
	Wed,  4 Nov 2026 22:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v8p8Zral
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF681F00A02;
	Wed,  4 Nov 2026 22:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831466;
	bh=082d0UNRm75HELP+vmE4Qo56IemPB8O0W58fYCmXpx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8p8ZralHxhX5T04NYMH/v+eF2cXH6t29C9JVgZR09XC/ZBW8KvwxHD2RAgqbF9sa
	 UoDkPtj9h3viCfB//oc6zhvTya+flsmOk+o7PNaOQ5r3EBMmpdJydwnkS9La/RFNwN
	 MYtbPbEkq/BRK7xoYFtUYVaVLw9ZVVclrG1YLxfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.18 0671/1005] iommufd: Fix event queue release use-after-free
Date: Wed,  4 Nov 2026 16:06:44 -0500
Message-ID: <20261104211102.448874363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
 


