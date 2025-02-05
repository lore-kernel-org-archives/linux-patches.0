Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1510F1607B7;
	Wed,  5 Feb 2025 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767670; cv=none; b=a4/LfzNHtdsNAvw1KojroeCMZGEx6uKnkBNIMlKqOwDdVkai3RSaf2++vYyWgsqzwz6/yLK2UT5a5IjMM/D43cSYHYT6U6VwX5MEDs6xBLyhB2/K/llRB4k7ulcDI8wS2Vd3jdg5P8BxtufVntfU9aKZ87MYUsYvX7j3wIbtjFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767670; c=relaxed/simple;
	bh=FXXfF7HB3iF+5cvdEmhl+dqXmPmUENDPwFtNfziW6kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1F7o8o+LYCUiBIsI1MoYvYXT7QC+yAbDKAEImcb0l7cdey9G03TQkVlWOcQ9W9b9rkv1v6f1SCRmCumW1/XRAgCmDczLhA6GlvU6uSPh1TaGWlSt3ZbUzz148KfRbs5BK2Pxi5Tu3pfBYj8ZFXpxpC92qQCzlQTvjJupwKWdXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvAd6qdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvAd6qdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEF8C4CED1;
	Wed,  5 Feb 2025 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767670;
	bh=FXXfF7HB3iF+5cvdEmhl+dqXmPmUENDPwFtNfziW6kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvAd6qddrXy5p+nxPE9PobPkBDhuS9bEeTSliiXBLD84mGEtUaqMLtTIqfE0KK5/x
	 FMJGKOMLeEgVsYv6H1+qoZNBXEyCQkEUhxDl4tE4BZaKlAAbUrojkqpT6GUybjR/Qk
	 pAmfCH2lvsZ9LQhzLQasPilh5lXSoOK2VKAPhKHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 490/590] iavf: allow changing VLAN state without calling PF
Date: Wed,  5 Feb 2025 14:44:05 +0100
Message-ID: <20250205134514.016638132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit ee7d79433d783346430ee32f28c9df44a88b3bb6 ]

First case:
> ip l a l $VF name vlanx type vlan id 100
> ip l d vlanx
> ip l a l $VF name vlanx type vlan id 100

As workqueue can be execute after sometime, there is a window to have
call trace like that:
- iavf_del_vlan
- iavf_add_vlan
- iavf_del_vlans (wq)

It means that our VLAN 100 will change the state from IAVF_VLAN_ACTIVE
to IAVF_VLAN_REMOVE (iavf_del_vlan). After that in iavf_add_vlan state
won't be changed because VLAN 100 is on the filter list. The final
result is that the VLAN 100 filter isn't added in hardware (no
iavf_add_vlans call).

To fix that change the state if the filter wasn't removed yet directly
to active. It is save as IAVF_VLAN_REMOVE means that virtchnl message
wasn't sent yet.

Second case:
> ip l a l $VF name vlanx type vlan id 100
Any type of VF reset ex. change trust
> ip l s $PF vf $VF_NUM trust on
> ip l d vlanx
> ip l a l $VF name vlanx type vlan id 100

In case of reset iavf driver is responsible for readding all filters
that are being used. To do that all VLAN filters state are changed to
IAVF_VLAN_ADD. Here is even longer window for changing VLAN state from
kernel side, as workqueue isn't called immediately. We can have call
trace like that:

- changing to IAVF_VLAN_ADD (after reset)
- iavf_del_vlan (called from kernel ops)
- iavf_del_vlans (wq)

Not exsisitng VLAN filters will be removed from hardware. It isn't a
bug, ice driver will handle it fine. However, we can have call trace
like that:

- changing to IAVF_VLAN_ADD (after reset)
- iavf_del_vlan (called from kernel ops)
- iavf_add_vlan (called from kernel ops)
- iavf_del_vlans (wq)

With fix for previous case we end up with no VLAN filters in hardware.
We have to remove VLAN filters if the state is IAVF_VLAN_ADD and delete
VLAN was called. It is save as IAVF_VLAN_ADD means that virtchnl message
wasn't sent yet.

Fixes: 0c0da0e95105 ("iavf: refactor VLAN filter states")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index f782402cd7898..5516795cc250a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -773,6 +773,11 @@ iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter,
 		f->state = IAVF_VLAN_ADD;
 		adapter->num_vlan_filters++;
 		iavf_schedule_aq_request(adapter, IAVF_FLAG_AQ_ADD_VLAN_FILTER);
+	} else if (f->state == IAVF_VLAN_REMOVE) {
+		/* IAVF_VLAN_REMOVE means that VLAN wasn't yet removed.
+		 * We can safely only change the state here.
+		 */
+		f->state = IAVF_VLAN_ACTIVE;
 	}
 
 clearout:
@@ -793,8 +798,18 @@ static void iavf_del_vlan(struct iavf_adapter *adapter, struct iavf_vlan vlan)
 
 	f = iavf_find_vlan(adapter, vlan);
 	if (f) {
-		f->state = IAVF_VLAN_REMOVE;
-		iavf_schedule_aq_request(adapter, IAVF_FLAG_AQ_DEL_VLAN_FILTER);
+		/* IAVF_ADD_VLAN means that VLAN wasn't even added yet.
+		 * Remove it from the list.
+		 */
+		if (f->state == IAVF_VLAN_ADD) {
+			list_del(&f->list);
+			kfree(f);
+			adapter->num_vlan_filters--;
+		} else {
+			f->state = IAVF_VLAN_REMOVE;
+			iavf_schedule_aq_request(adapter,
+						 IAVF_FLAG_AQ_DEL_VLAN_FILTER);
+		}
 	}
 
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
-- 
2.39.5



