Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D860A1D5CE8;
	Wed, 19 Feb 2025 08:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954879; cv=none; b=CeuPBASa6ugA1WhkWkH+pswpppBNSAX2ICdLH/hX41+c39d/QH+SriAMca9MVTLeDA9UWCtPvff0NKOxmKjvEMzPnA3UtfTtEoS94j7F9b1t6FFpR2GAHxTuC0xlEiayrFuzkODJwfGAxLqRAbBB6Hg4gJRcmR8Ft8+f6EdgmBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954879; c=relaxed/simple;
	bh=UxtPcjLIAKFY85Wd5OAw1BGtw3gehsW+BxzEQVVtI0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUh7128S5E9A5iHaJ99YSxo+6PYeKYaHGAvQKF5Yzt5yS0Fw7c1AvDutQV4oReg21XJuR23IWtK1XF7Jrogx6MiQviCQIWnZXrInUyQyXKKz/eY5Qg3KW4NuxeX2aRfBhTgNQrs96zyaV/oPGSy4tZBojoTI8dBAixyt3ZcY5zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbOMbXrJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbOMbXrJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504AFC4CED1;
	Wed, 19 Feb 2025 08:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954879;
	bh=UxtPcjLIAKFY85Wd5OAw1BGtw3gehsW+BxzEQVVtI0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbOMbXrJ6ITXM9j09cSbUClnvHNzfMyP8DmdE+wo1qLK5tSUggAYPzz9JZbEUcJHp
	 ft8IG6jNajbIyPN3GcavStvgXoe0Ngge2yYJ4ybqhqliZMFTVFfTrPzxNPWYdpWXz6
	 BEPV8TSpE1YKMnOMSMBqBSdhak5YEHtc2+JUvuGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hay <joshua.a.hay@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/230] idpf: call set_real_num_queues in idpf_open
Date: Wed, 19 Feb 2025 09:25:40 +0100
Message-ID: <20250219082602.613698787@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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



