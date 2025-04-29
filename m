Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF78224234;
	Tue, 29 Apr 2025 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950740; cv=none; b=gzGiZA4gYPAQdZ31UDwA1POYt3Kr590JV3pQdFgupV4e7Ir8rTh5azVIaI61i3StDsG3JSFBcCuWxd2tVG1JNKd1jSFMycvpAsCZPS86q/lP/FpbJdL3TRWv1y56PiO8qwnWPAkpP62dCEfpNRLm8UmUqsKZaBpXs2ng/A8wCp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950740; c=relaxed/simple;
	bh=L41ACuxOtcULNcPtyStOE5FKa6kwqoD0MwR040dbvJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYSfCZWhQVopllJINzheKZ96BWsmSijcByeXpl4i9WGzyG8HGBIn4AfNuOPJ7p07MLxb/4zR4lxqsgEuZZsIH5FtWWHKMeWr/Twoocp0uB0tR3jb1FLYHJnPHXi/U+aGjSCQX031Q+K1I34YMDQM31jcgmXFeTH4iMB7X6saLSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjgWUHyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjgWUHyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0BAC4CEE3;
	Tue, 29 Apr 2025 18:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950740;
	bh=L41ACuxOtcULNcPtyStOE5FKa6kwqoD0MwR040dbvJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjgWUHytVnKGDHQwCu/Z15guQ2vCWR0H7f/pvlBxrjf/171fyTorDSLPlIvJQeEUy
	 nGr98NEnDL9JWBajmqUujl5tno8IzrJc5TWYZPPTQ7L16K4rxdmywjNxDW1yGcNn6F
	 aeSsDBKLSIkIahSQ0+bSbuuzxKmfVEGcjGeDQFuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/204] nvme: re-read ANA log page after ns scan completes
Date: Tue, 29 Apr 2025 18:44:10 +0200
Message-ID: <20250429161106.040608542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 62baf70c327444338c34703c71aa8cc8e4189bd6 ]

When scanning for new namespaces we might have missed an ANA AEN.

The NVMe base spec (NVMe Base Specification v2.1, Figure 151 'Asynchonous
Event Information - Notice': Asymmetric Namespace Access Change) states:

  A controller shall not send this even if an Attached Namespace
  Attribute Changed asynchronous event [...] is sent for the same event.

so we need to re-read the ANA log page after we rescanned the namespace
list to update the ANA states of the new namespaces.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e36c6fcab1eed..8827614ab8c63 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3976,6 +3976,11 @@ static void nvme_scan_work(struct work_struct *work)
 	/* Requeue if we have missed AENs */
 	if (test_bit(NVME_AER_NOTICE_NS_CHANGED, &ctrl->events))
 		nvme_queue_scan(ctrl);
+#ifdef CONFIG_NVME_MULTIPATH
+	else
+		/* Re-read the ANA log page to not miss updates */
+		queue_work(nvme_wq, &ctrl->ana_work);
+#endif
 }
 
 /*
-- 
2.39.5



