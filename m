Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0F033B6C4;
	Sat, 30 May 2026 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161986; cv=none; b=ktF4cMdNlR5Py9nexW5Dy64cJcvo2+dYudIbLXoK9GGXlkwAGaH1pVGiXoEjwJuDii5CtGs2WLKPocbUUwkPTPAbviSIQTI1KlMclAMtMvH3Xwrdzq+Sw6Pc+cj9ZLC3uZQnYRSD5TqmyFRFokSkHgLC4YxCIADkf6YA10+4foY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161986; c=relaxed/simple;
	bh=6psvR3LFaQ4JiGweijI0kx3r1/aT0mxe0ken+1q9AEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNsucRJU0GcQ4kVqt0OQN8TAovHe/MC4zkgqBYptMX+NOIEI9sfI8LMZ6RexpZT+i4kuCEGhav5Qb1mNwbneI0Mt1xI7fuokaah38FK9Y1nM/on3S9hegPKrFntmfnHTZGaT5L/Z92m9TcNPKyFtc6tdhnUniyWOmVJm6jr5c/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMMMR19f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMMMR19f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04AD1F00898;
	Sat, 30 May 2026 17:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161985;
	bh=sJ/awdC9Mrgt38N8cmpdc1RH9ivkqVaI88R+U4dFcxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMMMR19f2aeU45iTvYgWDQcniV5U2qER5I+xDlkyFPsClWNZ/T15TJ9JMCWR6fYig
	 vJSwOeBKq82pHrKSg4pEYiv3xqlZBUmEXBdT+9nQ/o8prCxrnnitHOD6GNLUC6HKyn
	 MSK6X3B65hQP0Jz1CFEk54yEi4ClTPcYHvoDxv6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 786/969] iavf: add VIRTCHNL_OP_ADD_VLAN to success completion handler
Date: Sat, 30 May 2026 18:05:10 +0200
Message-ID: <20260530160322.308238183@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 34d33313b52eeac3a97ad2e3176d523ec70d9283 ]

The V1 ADD_VLAN opcode had no success handler; filters sent via V1
stayed in ADDING state permanently.  Add a fallthrough case so V1
filters also transition ADDING -> ACTIVE on PF confirmation.

Critically, add an `if (v_retval) break` guard: the error switch in
iavf_virtchnl_completion() does NOT return after handling errors,
it falls through to the success switch.  Without this guard, a
PF-rejected ADD would incorrectly mark ADDING filters as ACTIVE,
creating a driver/HW mismatch where the driver believes the filter
is installed but the PF never accepted it.

For V2, this is harmless: iavf_vlan_add_reject() in the error
block already kfree'd all ADDING filters, so the success handler
finds nothing to transition.

Fixes: 968996c070ef ("iavf: Fix VLAN_V2 addition/rejection")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-fixes-v1-4-cdcb48303fd8@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 6fb657ec654e8..9ae7c92ae1b1f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2501,9 +2501,13 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		spin_unlock_bh(&adapter->adv_rss_lock);
 		}
 		break;
+	case VIRTCHNL_OP_ADD_VLAN:
 	case VIRTCHNL_OP_ADD_VLAN_V2: {
 		struct iavf_vlan_filter *f;
 
+		if (v_retval)
+			break;
+
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
 			if (f->state == IAVF_VLAN_ADDING)
-- 
2.53.0



