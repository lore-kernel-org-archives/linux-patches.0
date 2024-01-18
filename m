Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F6C22EF7;
	Thu, 18 Jan 2024 10:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575210; cv=none; b=qL2HMSrIrhGyWTPstmXV5hjTBO/7PG0CF29arIRq/5Shq1+N72sPgJdAg/NitE03M5tRC0LmRIotU5N8ub85ectkNlvCkpZZuZJicvu4NICVH3BeFsB+9sf+++Jaa2FlG4eFwB3EHvQGhFQWMq8LM9ZQ72yY5nwQsRKhHalH65Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575210; c=relaxed/simple;
	bh=qwNkPKYL5IGdDUjs1knR0sBSRDTy2GgFn45k7wJfvLQ=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=GdNQY3xgq439rOcfzRNGffPHjX+HB982f48vvrGzvuHyZtBGV1vsjCM/RvRwK66+SWDFCOxbvDMh5I+Woub6A5XPvrjXdyJQjcNrURgl8T5LnJOII1kWRA/fqKZsQN6OfE0aMmeT8pgDygxhb8z8YcHMv9O4yNAnJJ9m7v0rNOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tk8QVzAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tk8QVzAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6148C433C7;
	Thu, 18 Jan 2024 10:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575210;
	bh=qwNkPKYL5IGdDUjs1knR0sBSRDTy2GgFn45k7wJfvLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tk8QVzAuSITTTN9f18Ub1Bif7s32BO7WZULdwOay9zlTEP2rtwbpR2sWTnKwA5gR6
	 ZzlXU2slrlDvRwEDxL6mGr1QzUnKmB9BJP1Gi2gnqf0KpUX5qzP/rBKXumorvlY6+8
	 mYK4NBBBQ6mcL59x/GkgXoFfvRi4hakP3YRKSj14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/150] pds_vdpa: set features order
Date: Thu, 18 Jan 2024 11:47:52 +0100
Message-ID: <20240118104322.319026732@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit cefc9ba6aed48a3aa085888e3262ac2aa975714b ]

Fix up the order that the device and negotiated features
are checked to get a more reliable difference when things
get changed.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Message-Id: <20231110221802.46841-4-shannon.nelson@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/pds/vdpa_dev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 9fc89c82d1f0..25c0fe5ec3d5 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -318,9 +318,8 @@ static int pds_vdpa_set_driver_features(struct vdpa_device *vdpa_dev, u64 featur
 		return -EOPNOTSUPP;
 	}
 
-	pdsv->negotiated_features = nego_features;
-
 	driver_features = pds_vdpa_get_driver_features(vdpa_dev);
+	pdsv->negotiated_features = nego_features;
 	dev_dbg(dev, "%s: %#llx => %#llx\n",
 		__func__, driver_features, nego_features);
 
-- 
2.43.0



