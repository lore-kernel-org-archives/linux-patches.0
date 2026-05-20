Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F6034041C;
	Wed, 20 May 2026 17:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297029; cv=none; b=aln9lW4ElS4hejg2c60YIaHluBEzSP5KArqcGYHI0yk9AbkGC0iSAeNJXCFYsiw9LnqsMYTBgKahwzIp3C5sPU4uRCqvKU/CNCJCMCKvFzDbNZKoswzC1u/ukLh552tmDr4oW4hYtHJ6xVnEYaUrgtKKZs8sXqFiBBtHH1VDA3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297029; c=relaxed/simple;
	bh=GpPpeNOx7su2zk0LxF55F1Weg3myNcbrYFwPbfwIB20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1lqfrN//YcvV+96HZ6UrCA3Tp5pclOzGNsXvXB3VOtVw+c+zgyyRccX4pm8TsbYhqc4WqwV/QPgLhRZ4PqWQRg0VC1vwL1lDpKZSZqfgliWIsv5X6Xd/ulkObMdA1lvO3zF9+vnxNaW0oJCVKkx9aqYdgGJvfwzkHVPsclfSIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYTYoe9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYTYoe9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F84B1F000E9;
	Wed, 20 May 2026 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297028;
	bh=oTO5dzUFtwGadASLqE/bPDjePcZsKZqb4s34dMxNhm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYTYoe9KBAaCk5AkrezkKN6QGQaMEPkdjhb5kZBXHnh2vsK29QbEZtCXBA6bQW6Nn
	 FF4C/r7EJ4L77ACeQmKmN8SwHOK9d6sOS8nqvpqwrMjqGf0GnTrajMPiBS3KgBSY35
	 +6OQ5K4+IeGG56E7YQZtdCmVV5BBMOOTpcfRHFkU=
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
Subject: [PATCH 7.0 1023/1146] iavf: add VIRTCHNL_OP_ADD_VLAN to success completion handler
Date: Wed, 20 May 2026 18:21:13 +0200
Message-ID: <20260520162211.380935893@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 93ca79c3e3b53..4f2defd2331b1 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2876,9 +2876,13 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
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



