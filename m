Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D38EC8EB;
	Wed, 23 Apr 2025 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419599; cv=none; b=klNRPks09FBBNA630+nDyqdECCQsU/zz9LtiTO5TCpgmZyuiHBM/OupIIqSfgNP3v8C8TgAPC16SKNKOJAkvoUC7pO/cqJ+b2Uj//i9g2TwaLUzFSzI2VtkZCwXZ86tLBspCbN/gqxJ32A+1hnXgc7CIk6/MpbMxSOXwhCml1Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419599; c=relaxed/simple;
	bh=2heZO1M83XAwHDe+P8Rjf958t2yCjlc2hYr6cdldgAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P98A06d+wmMrVhPez0M9q1ZbSyhaA4ujDzhy38EaSLUKbVfXNN7bF7wLwBoRdgSJIlssc7GoAPbA/N49xgll2VD4NSK696bRBbh7rXh/TUH80AnRfJR1lMdOTfHf1dAMyEtcKxPA9CEAc0Z0TlIN3N32uWU/N0ueNQUgc7FpvN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWh/XO/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWh/XO/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BCAC4CEE2;
	Wed, 23 Apr 2025 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419599;
	bh=2heZO1M83XAwHDe+P8Rjf958t2yCjlc2hYr6cdldgAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWh/XO/JPNb9xlgyTOvs8YdgGLKPaoo/EJDVFsdbzi0Y8L2oUnbUMCeMeggfRShog
	 s8VuWUkWq/mlDyPabQNetME9DJjQiFrIx3Qgq1e0R8xkbCe0ivY1HR/cA7+O6cH3e7
	 0QDBt0oDMzS3XN3O1PY0XeXo8durABQ1HJKaU8wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Ming Lei <ming.lei@redhat.com>,
	Daniel Wagner <wagi@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/223] driver core: bus: add irq_get_affinity callback to bus_type
Date: Wed, 23 Apr 2025 16:41:19 +0200
Message-ID: <20250423142617.420331149@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit fea4952df0eeec4e1a295ebaac9f61c0065fae87 ]

Introducing a callback in struct bus_type so that a subsystem
can hook up the getters directly. This approach avoids exposing
random getters in any subsystems APIs.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Link: https://lore.kernel.org/r/20241202-refactor-blk-affinity-helpers-v6-1-27211e9c2cd5@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: a2d5a0072235 ("scsi: smartpqi: Use is_kdump_kernel() to check for kdump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device/bus.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/device/bus.h b/include/linux/device/bus.h
index cdc4757217f9b..b18658bce2c38 100644
--- a/include/linux/device/bus.h
+++ b/include/linux/device/bus.h
@@ -48,6 +48,7 @@ struct fwnode_handle;
  *		will never get called until they do.
  * @remove:	Called when a device removed from this bus.
  * @shutdown:	Called at shut-down time to quiesce the device.
+ * @irq_get_affinity:	Get IRQ affinity mask for the device on this bus.
  *
  * @online:	Called to put the device back online (after offlining it).
  * @offline:	Called to put the device offline for hot-removal. May fail.
@@ -87,6 +88,8 @@ struct bus_type {
 	void (*sync_state)(struct device *dev);
 	void (*remove)(struct device *dev);
 	void (*shutdown)(struct device *dev);
+	const struct cpumask *(*irq_get_affinity)(struct device *dev,
+			unsigned int irq_vec);
 
 	int (*online)(struct device *dev);
 	int (*offline)(struct device *dev);
-- 
2.39.5



