Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65694EBACB;
	Fri,  9 Oct 2026 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557134; cv=none; b=QfVfXv4czZeq5/kXdoExawQzZQuvndBtZThJn02hiOANEBoKqEKmJEzJ7PWqG5/DhGTsGKB8vXzY3n9XZ8+PDhrDSNFg8YBkd3Yg76F3K7VAi2A7hMhRWih1hlyqrWpHWzYGS1q+IM/Xd+OMccxoFPWx6ednbTZ4QUN/VC9/mx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557134; c=relaxed/simple;
	bh=MJ9dOJgRDi2Vip9y32YHyCdzuGo2RCgRqhM5zLn24nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLSgsVsdl8MN87Ibtemxi1bNXz0JzayR045mPEVPNSi1DPy5aChkJOCb2JPd/4TiiiFXmXGbUj21Ysu0ulWeuPohtnM5x0/ZxIfDbC1P8YH+M4eGRtpjsbAu1uT/7Nqr13nDWqO/bqLCCAy3iFW5Sw8oBk9zvoGKZEp8yAg+bVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTu0CR60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTu0CR60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED651F000FF;
	Fri,  9 Oct 2026 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557132;
	bh=mLQS5NfMuk4o+o7HSybJAa6Kjj2WNPR6WuDyitZnUDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTu0CR600G7PO0b6uxJr+A3czAbLxQvE/aEgqomZ+7d7ywZptsiICF8y41AW8NK0C
	 uSLwRWgvyBsJ3BGFucGf9LiWoqnfa39FKq5EM2TX8aSXooaHKPUEK07wydFSSSl8w2
	 ytO4TmPWMZXDhmjRbh4x0vIzgFtHBPKKcsRleQq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@suse.de>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.2 301/428] nvmet: copy the hostid into the ctrl before creating PR pc_refs
Date: Fri,  9 Oct 2026 16:10:38 +0200
Message-ID: <20261009140952.726277296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

commit 5211fed41d7ec90e9ab7239dc4bffffe4d0b2b62 upstream.

Commit 6202783184bf ("nvmet: Improve nvmet_alloc_ctrl() interface and
implementation") added a second uuid_copy() of args->hostid near the end
of nvmet_alloc_ctrl(), and commit 7b658153f1b8 ("nvmet: Remove duplicate
uuid_copy") removed the original copy that sat before
nvmet_ctrl_init_pr() instead of the new one.

Since then nvmet_ctrl_init_pr() snapshots ctrl->hostid into the
per-controller per-namespace reservation refs while the uuid_copy()
from the connect data runs later, after the controller is published.
The ctrl is allocated with kzalloc(), so every pc_ref created on this
path stores the nil UUID.

pc_ref->hostid has a single consumer: nvmet_pr_set_ctrl_to_abort()
matches it against the preempted registrant's hostid to kill and drain
the victim's in-flight I/O for Preempt and Abort.  The match can never
hit with the nil UUID, so whenever a namespace with reservations
enabled exists before a host connects, which includes every reconnect,
Preempt and Abort silently degrades into a plain Preempt: the
preempting host sees success while the victim's in-flight I/O is still
in the air.

Copy the hostid where the rest of the connect data is consumed, before
the controller is published and before nvmet_ctrl_init_pr() takes its
snapshot.

Fixes: 7b658153f1b8 ("nvmet: Remove duplicate uuid_copy")
Cc: stable@vger.kernel.org
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1641,6 +1641,8 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(stru
 	INIT_DELAYED_WORK(&ctrl->ka_work, nvmet_keep_alive_timer);
 
 	memcpy(ctrl->hostnqn, args->hostnqn, NVMF_NQN_SIZE);
+	if (args->hostid)
+		uuid_copy(&ctrl->hostid, args->hostid);
 
 	kref_init(&ctrl->ref);
 	ctrl->subsys = subsys;
@@ -1699,9 +1701,6 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(stru
 
 	nvmet_start_keep_alive_timer(ctrl);
 
-	if (args->hostid)
-		uuid_copy(&ctrl->hostid, args->hostid);
-
 	dhchap_status = nvmet_setup_auth(ctrl, args->sq, false);
 	if (dhchap_status) {
 		pr_err("Failed to setup authentication, dhchap status %u\n",


