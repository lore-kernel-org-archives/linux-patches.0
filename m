Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6703AB29B;
	Mon, 23 Mar 2026 14:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274925; cv=none; b=tFnZZlxeH2ur0P9STaZkMx1W/5W8Ha/YT6M/K5Aw8Nn9/v9rRQU+1ejN2XIkcl/4NcBOjeU1kV6YhcMsM7Wz1oZBd8BULK4aRCivaKl+nWeZdPvtY4j/2K7N/H1fAix1JP7EEYYPbISufSGi8Hx9FVtogNgTKfM8zvEpGpIv07c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274925; c=relaxed/simple;
	bh=nfTQ8KG6mHqUsIS3qYspOk5C9wiX0hDwxwwzYW6tzak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqDw7WIoRubclsA9iMK21jLuH2rkT2ziX3o1zk2YzgZfw8ApomsdQzceOYvB+CqCOFAcSCIyxd6K2zg1w8CluHnTulMCjOSf74U2Vd/vHsOAkcyGbsfqhV7JerI5thTPDl2sRfKtSTB0U7j02qU0wMIv8mRE6GTjyAEZvuVKdeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/oHP8TN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/oHP8TN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D733AC4CEF7;
	Mon, 23 Mar 2026 14:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274925;
	bh=nfTQ8KG6mHqUsIS3qYspOk5C9wiX0hDwxwwzYW6tzak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/oHP8TNfXnqqjgPmeTvN3tKdkEAu0kMDExyZcTOJnNYce0oifGQMCLOAUPxiCnH7
	 BcMrE/9ssrKvBxTgo7HaoO93avamYcDLcSJR+8C1VXKO+6bjaaElJtF32MrSuT9jPk
	 ZX1TODT82Y44zMZfjjmwPr65DgUs1ZyWTb6xlwTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 158/212] iavf: fix VLAN filter lost on add/delete race
Date: Mon, 23 Mar 2026 14:46:19 +0100
Message-ID: <20260323134508.747150606@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit fc9c69be594756b81b54c6bc40803fa6052f35ae ]

When iavf_add_vlan() finds an existing filter in IAVF_VLAN_REMOVE
state, it transitions the filter to IAVF_VLAN_ACTIVE assuming the
pending delete can simply be cancelled. However, there is no guarantee
that iavf_del_vlans() has not already processed the delete AQ request
and removed the filter from the PF. In that case the filter remains in
the driver's list as IAVF_VLAN_ACTIVE but is no longer programmed on
the NIC. Since iavf_add_vlans() only picks up filters in
IAVF_VLAN_ADD state, the filter is never re-added, and spoof checking
drops all traffic for that VLAN.

  CPU0                       CPU1                     Workqueue
  ----                       ----                     ---------
  iavf_del_vlan(vlan 100)
    f->state = REMOVE
    schedule AQ_DEL_VLAN
                             iavf_add_vlan(vlan 100)
                               f->state = ACTIVE
                                                      iavf_del_vlans()
                                                        f is ACTIVE, skip
                                                      iavf_add_vlans()
                                                        f is ACTIVE, skip

  Filter is ACTIVE in driver but absent from NIC.

Transition to IAVF_VLAN_ADD instead and schedule
IAVF_FLAG_AQ_ADD_VLAN_FILTER so iavf_add_vlans() re-programs the
filter.  A duplicate add is idempotent on the PF.

Fixes: 0c0da0e95105 ("iavf: refactor VLAN filter states")
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 03ab2a4276bbf..0a72d419782e5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -757,10 +757,13 @@ iavf_vlan_filter *iavf_add_vlan(struct iavf_adapter *adapter,
 		adapter->num_vlan_filters++;
 		iavf_schedule_aq_request(adapter, IAVF_FLAG_AQ_ADD_VLAN_FILTER);
 	} else if (f->state == IAVF_VLAN_REMOVE) {
-		/* IAVF_VLAN_REMOVE means that VLAN wasn't yet removed.
-		 * We can safely only change the state here.
+		/* Re-add the filter since we cannot tell whether the
+		 * pending delete has already been processed by the PF.
+		 * A duplicate add is harmless.
 		 */
-		f->state = IAVF_VLAN_ACTIVE;
+		f->state = IAVF_VLAN_ADD;
+		iavf_schedule_aq_request(adapter,
+					 IAVF_FLAG_AQ_ADD_VLAN_FILTER);
 	}
 
 clearout:
-- 
2.51.0



