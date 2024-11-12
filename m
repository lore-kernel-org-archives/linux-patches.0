Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6854A2123E5;
	Tue, 12 Nov 2024 10:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407001; cv=none; b=AtVz3I8UZaLb5vLDGZpXF4K6vM+Y6HjIRnWCTMm3PynSBn4PZ6F7Sqkf9M9ods0F6wi+kX3Op7TXPwOmqBZUPvrIkrcraNU1Vtc/VsV4lHHPNDJg/JouoWxaRH8MKNqIbdpTBVErZAR339HmMsQ717IfB92XTzgJPsqnM8Og1aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407001; c=relaxed/simple;
	bh=gdzbVcbIn+t4kuZ3P1PJvV+HE0TlBp7J+i1jReUiz0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjfL45uCNdjmTW2OcLqtl4QT1kYGeMf5JLnN48+TsEP0Tx1mdUydaUqpVW8afMvBCp+CP5Ar9aIyCSUnfG9SqD6gVOR40eo6CanYdLffGWACJBcziRfjt8r/DmHM9Z9LU+55wTIGTiGFHU/U8lPSUUqG9GrfFbtm05sj4BBf5t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qk8RxFQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qk8RxFQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D3EC4CECD;
	Tue, 12 Nov 2024 10:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407001;
	bh=gdzbVcbIn+t4kuZ3P1PJvV+HE0TlBp7J+i1jReUiz0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qk8RxFQtrDI+X3CbP+HYzHSM+di+ygAZIY6fPXNCS14ed47yd2lA1Z6z9flwfgtzN
	 uZ0KJAbHBaO5u8MedCqui0x0yXJcNgp93C3IkMeyfHf10/MsLQ/aGmpNFNdd2Adwuy
	 jHCHgFZI8zrjh1dCgCGWDaKPWw/5mRA7HuiQXVx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.15 20/76] i40e: fix race condition by adding filters intermediate sync state
Date: Tue, 12 Nov 2024 11:20:45 +0100
Message-ID: <20241112101840.553449209@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit f30490e9695ef7da3d0899c6a0293cc7cd373567 ]

Fix a race condition in the i40e driver that leads to MAC/VLAN filters
becoming corrupted and leaking. Address the issue that occurs under
heavy load when multiple threads are concurrently modifying MAC/VLAN
filters by setting mac and port VLAN.

1. Thread T0 allocates a filter in i40e_add_filter() within
        i40e_ndo_set_vf_port_vlan().
2. Thread T1 concurrently frees the filter in __i40e_del_filter() within
        i40e_ndo_set_vf_mac().
3. Subsequently, i40e_service_task() calls i40e_sync_vsi_filters(), which
        refers to the already freed filter memory, causing corruption.

Reproduction steps:
1. Spawn multiple VFs.
2. Apply a concurrent heavy load by running parallel operations to change
        MAC addresses on the VFs and change port VLANs on the host.
3. Observe errors in dmesg:
"Error I40E_AQ_RC_ENOSPC adding RX filters on VF XX,
	please set promiscuous on manually for VF XX".

Exact code for stable reproduction Intel can't open-source now.

The fix involves implementing a new intermediate filter state,
I40E_FILTER_NEW_SYNC, for the time when a filter is on a tmp_add_list.
These filters cannot be deleted from the hash list directly but
must be removed using the full process.

Fixes: 278e7d0b9d68 ("i40e: store MAC/VLAN filters in a hash with the MAC Address as key")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Reviewed-by: Michal Schmidt <mschmidt@redhat.com>
Tested-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h         |  1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 12 ++++++++++--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index a05103e2fb522..a143440f3db62 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -776,6 +776,7 @@ enum i40e_filter_state {
 	I40E_FILTER_ACTIVE,		/* Added to switch by FW */
 	I40E_FILTER_FAILED,		/* Rejected by FW */
 	I40E_FILTER_REMOVE,		/* To be removed */
+	I40E_FILTER_NEW_SYNC,		/* New, not sent yet, is in i40e_sync_vsi_filters() */
 /* There is no 'removed' state; the filter struct is freed */
 };
 struct i40e_mac_filter {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 7c5f874ef335a..503818f0714d4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -105,6 +105,7 @@ static char *i40e_filter_state_string[] = {
 	"ACTIVE",
 	"FAILED",
 	"REMOVE",
+	"NEW_SYNC",
 };
 
 /**
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index c1f21713ab8d1..bc5da0b8648c1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -1233,6 +1233,7 @@ int i40e_count_filters(struct i40e_vsi *vsi)
 
 	hash_for_each_safe(vsi->mac_filter_hash, bkt, h, f, hlist) {
 		if (f->state == I40E_FILTER_NEW ||
+		    f->state == I40E_FILTER_NEW_SYNC ||
 		    f->state == I40E_FILTER_ACTIVE)
 			++cnt;
 	}
@@ -1419,6 +1420,8 @@ static int i40e_correct_mac_vlan_filters(struct i40e_vsi *vsi,
 
 			new->f = add_head;
 			new->state = add_head->state;
+			if (add_head->state == I40E_FILTER_NEW)
+				add_head->state = I40E_FILTER_NEW_SYNC;
 
 			/* Add the new filter to the tmp list */
 			hlist_add_head(&new->hlist, tmp_add_list);
@@ -1528,6 +1531,8 @@ static int i40e_correct_vf_mac_vlan_filters(struct i40e_vsi *vsi,
 				return -ENOMEM;
 			new_mac->f = add_head;
 			new_mac->state = add_head->state;
+			if (add_head->state == I40E_FILTER_NEW)
+				add_head->state = I40E_FILTER_NEW_SYNC;
 
 			/* Add the new filter to the tmp list */
 			hlist_add_head(&new_mac->hlist, tmp_add_list);
@@ -2417,7 +2422,8 @@ static int
 i40e_aqc_broadcast_filter(struct i40e_vsi *vsi, const char *vsi_name,
 			  struct i40e_mac_filter *f)
 {
-	bool enable = f->state == I40E_FILTER_NEW;
+	bool enable = f->state == I40E_FILTER_NEW ||
+		      f->state == I40E_FILTER_NEW_SYNC;
 	struct i40e_hw *hw = &vsi->back->hw;
 	int aq_ret;
 
@@ -2591,6 +2597,7 @@ int i40e_sync_vsi_filters(struct i40e_vsi *vsi)
 
 				/* Add it to the hash list */
 				hlist_add_head(&new->hlist, &tmp_add_list);
+				f->state = I40E_FILTER_NEW_SYNC;
 			}
 
 			/* Count the number of active (current and new) VLAN
@@ -2742,7 +2749,8 @@ int i40e_sync_vsi_filters(struct i40e_vsi *vsi)
 		spin_lock_bh(&vsi->mac_filter_hash_lock);
 		hlist_for_each_entry_safe(new, h, &tmp_add_list, hlist) {
 			/* Only update the state if we're still NEW */
-			if (new->f->state == I40E_FILTER_NEW)
+			if (new->f->state == I40E_FILTER_NEW ||
+			    new->f->state == I40E_FILTER_NEW_SYNC)
 				new->f->state = new->state;
 			hlist_del(&new->hlist);
 			netdev_hw_addr_refcnt(new->f, vsi->netdev, -1);
-- 
2.43.0



