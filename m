Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A428918C011;
	Wed, 19 Feb 2025 08:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953880; cv=none; b=LAZRRv+l41z2K6AyroVR4CWpmeRGCeUMSQCGjG7mG4t7rngzoAAQV/IcRMQuvnOX7vYsg/6QFq91fClE9xFI8Peyh/OwcuxXEfX7Ucip7yhnT55s3vHDQ0DWjz90xkoewsQy7HF/hA3rP8RgiNm8Z2D/84dkCDL86SUrqFTE61A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953880; c=relaxed/simple;
	bh=LFHzQ7HSl0wyS6TyqHgzjNnI4MsCDklp8tnE8i8rB3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF9CHW1j8B+dJWL+1IEuPDvMj6P+f3GrglKr7cfmeAkH4/k4Y7jAwxfrtMlL5q+6TT3Bb1axoY81wFkwnGvqDdY/VBiKSD0esqpMvEHdUjtTyWV69V/r2E6IXam6NAjg6V6tl16cbSoWQw8jT5YV+lGk/eRKMPFOiJkmfP6y9p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbAstTWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbAstTWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF04C4CED1;
	Wed, 19 Feb 2025 08:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953880;
	bh=LFHzQ7HSl0wyS6TyqHgzjNnI4MsCDklp8tnE8i8rB3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbAstTWLTzZ1hMSxYfpWqvRl+ZUkO1jmUDKXtw74LTq5uAmXwNFd7V4WNGDtZ39vc
	 nrZLltSO45u9ihBj+a4qw7ZCjzPx4ROjmbD25VoUvPBa+70x0arGDieDw93wZ60U9K
	 32aAWrH5bEdk50qwHUQ8bzoWxGhE9iX7qEd5spGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hay <joshua.a.hay@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 027/274] idpf: call set_real_num_queues in idpf_open
Date: Wed, 19 Feb 2025 09:24:41 +0100
Message-ID: <20250219082610.599872846@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hay <joshua.a.hay@intel.com>

[ Upstream commit 52c11d31b5a1d1c747bb5f36cc4808e93e2348f4 ]

On initial driver load, alloc_etherdev_mqs is called with whatever max
queue values are provided by the control plane. However, if the driver
is loaded on a system where num_online_cpus() returns less than the max
queues, the netdev will think there are more queues than are actually
available. Only num_online_cpus() will be allocated, but
skb_get_queue_mapping(skb) could possibly return an index beyond the
range of allocated queues. Consequently, the packet is silently dropped
and it appears as if TX is broken.

Set the real number of queues during open so the netdev knows how many
queues will be allocated.

Fixes: 1c325aac10a8 ("idpf: configure resources for TX queues")
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index b4fbb99bfad20..a3d6b8f198a86 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -2159,8 +2159,13 @@ static int idpf_open(struct net_device *netdev)
 	idpf_vport_ctrl_lock(netdev);
 	vport = idpf_netdev_to_vport(netdev);
 
+	err = idpf_set_real_num_queues(vport);
+	if (err)
+		goto unlock;
+
 	err = idpf_vport_open(vport);
 
+unlock:
 	idpf_vport_ctrl_unlock(netdev);
 
 	return err;
-- 
2.39.5



