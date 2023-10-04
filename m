Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B654518E2A
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A17CC433CC;
	Wed,  4 Oct 2023 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443146;
	bh=V73my5E3mgplZV64foWkXYNpCdQuFJ6A5YnvBdGOx3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3/dmWKfzegmytLYBjLUwfjO+xvAZtxVWsWoMxBxBr2Qm/7SYJQzgNGZXpGaGatc6
	 debSH7rhtjPUsbrDSDaHyCX2JD1R1WJ7Zjda5eLZaSTKEm0TcLZ2WEsEZOS7Iv/2lt
	 a54AduMzw3q7cyooYL7a0/WzlC5f2IV7B4uUHMEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Simon Horman <horms@kernel.org>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/259] iavf: schedule a request immediately after add/delete vlan
Date: Wed,  4 Oct 2023 19:53:45 +0200
Message-ID: <20231004175219.826926758@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 5f3d319a248654a805bafc9e7094bcea47dac6c7 ]

When the iavf driver wants to reconfigure the VLAN filters
(iavf_add_vlan, iavf_del_vlan), it sets a flag in
aq_required:
  adapter->aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
or:
  adapter->aq_required |= IAVF_FLAG_AQ_DEL_VLAN_FILTER;

This is later processed by the watchdog_task, but it runs periodically
every 2 seconds, so it can be a long time before it processes the request.

In the worst case, the interface is unable to receive traffic for more
than 2 seconds for no objective reason.

Fixes: 5eae00c57f5e ("i40evf: main driver core")
Signed-off-by: Petr Oros <poros@redhat.com>
Co-developed-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Co-developed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Ahmed Zaki <ahmed.zaki@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index ee04670b77b33..a39f7f0d6ab0b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -829,7 +829,7 @@ iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter,
 		list_add_tail(&f->list, &adapter->vlan_filter_list);
 		f->state = IAVF_VLAN_ADD;
 		adapter->num_vlan_filters++;
-		adapter->aq_required |= IAVF_FLAG_AQ_ADD_VLAN_FILTER;
+		iavf_schedule_aq_request(adapter, IAVF_FLAG_AQ_ADD_VLAN_FILTER);
 	}
 
 clearout:
@@ -851,7 +851,7 @@ static void iavf_del_vlan(struct iavf_adapter *adapter, struct iavf_vlan vlan)
 	f = iavf_find_vlan(adapter, vlan);
 	if (f) {
 		f->state = IAVF_VLAN_REMOVE;
-		adapter->aq_required |= IAVF_FLAG_AQ_DEL_VLAN_FILTER;
+		iavf_schedule_aq_request(adapter, IAVF_FLAG_AQ_DEL_VLAN_FILTER);
 	}
 
 	spin_unlock_bh(&adapter->mac_vlan_list_lock);
-- 
2.40.1



