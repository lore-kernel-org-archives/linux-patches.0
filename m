Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CF08F77;
	Tue, 29 Apr 2025 18:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949611; cv=none; b=OomKM3iqTfajw3coUriDihyWVLyuUe+jnfVts4z35c2D395ZLFIliadefxktSGRDAOYpcMykHmoGB8MtWMqC1QGbQHQ8e+N+mJIvbz25TVztdKY7lbYKwIIhp3Iv7hg8zMSPS+TxK86ouLcofCHDrQbx+zZsWCG0JMwq16NoExU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949611; c=relaxed/simple;
	bh=kiUGcCc4RnpgsZJYsVK1GzxW50DHRUDwjo5EB5agD/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFHUOSugAbHTIGncetU5DJNVi5edRXU6Mg/4aq0gci282mJByG9iZf5fw3XRzxfk3Kjvn23CFIuRTYiQX+TThIdHtvkRK+xgdvz+OGHlVtlsIPGHr4csYa/X952de89NM53PUdT/ytcM4dS0ZISNxYbUMTe0A7mVNcKY8Wqhdro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNxxXmQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNxxXmQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48973C4CEE3;
	Tue, 29 Apr 2025 18:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949610;
	bh=kiUGcCc4RnpgsZJYsVK1GzxW50DHRUDwjo5EB5agD/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNxxXmQZZQbKK7f5/8Tiewl7cWge/fEQ4zZYU1rBdP4nHz/LkfoCqrTGZ4VK3s9HZ
	 AcwOhe4uhmW+/oCYXMeG1FRlP/fut9yL52z3R6AlCoEaNfO7raMTTeHsmSig8WtWLF
	 ESUOEBvFeuPuU4G1rAZwHchHoJIvDeGXF2BW7PX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/373] nvme: re-read ANA log page after ns scan completes
Date: Tue, 29 Apr 2025 18:43:43 +0200
Message-ID: <20250429161137.365698527@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 85d965fe8838c..68d4546dda3bb 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4225,6 +4225,11 @@ static void nvme_scan_work(struct work_struct *work)
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



