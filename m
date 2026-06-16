Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903644418D7;
	Tue, 16 Jun 2026 18:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634640; cv=none; b=MoRad4+XuIzk3qpBOlEmyoeD5xUQPFTxSnpqtTmUuWOWyoa3Sbmmeng46BammokpaLA4e2hw1hIeEb649B1iYvAvzXhpSGDFdC/7pJAx1uZ8+YsYV486Ei6pBWIERQnUx25ct5OuS1Fsu634TuD0gbKJz9saMPwZZPPuDIHMCJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634640; c=relaxed/simple;
	bh=5UJH0UoqVZffacw4+0mLrjTnse9yxOlkSh7YunMWujc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SpLGB19+H4VSsaP5q8ZUdWhGHBOh4SEkpQq+3kolqOvep1GXxUdumUv5mlQOXA2ULXPT43gYH/aLnkYHCJXyv0EJ1D/hcnarXK7CIKPmTUMSZtRHDa/Tq5VtYFTHnVw7haEwS3ZqUmdiav7TzosDpmFzYRG9KEtg5iSm5YdjdJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqNqDLAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqNqDLAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9457C1F000E9;
	Tue, 16 Jun 2026 18:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634639;
	bh=G3taWQjl1BfsPxdjG5iodc2cSxnqUL9MLYVql2ioS6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqNqDLAy1/9Suf7Cnh21ioWaKobXzYT/NuL39wzq3wwBCFnEZrmc7qxfEN3MWJVrx
	 IKSBtPeQPE72oJgNeQ7EbTb3rZE7fa3HIUk0cLwV6Ao0M4AO1K2HZqa0dvFJUXVQHA
	 WnBM1sy4/1/emyP4Aq9d8HrGdyry/0WHnKPddrCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>,
	stable <stable@kernel.org>,
	Badhri Jagan Sridharan <badhri@google.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/411] usb: typec: tcpm: reset internal port states on soft reset AMS
Date: Tue, 16 Jun 2026 20:29:02 +0530
Message-ID: <20260616145117.309810031@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

[ Upstream commit 2909f0d4994fb4306bf116df5ccee797791fce2c ]

Reset internal port states (such as vdm_sm_running and
explicit_contract) on soft reset AMS as the port needs to negotiate a
new contract. The consequence of leaving the states in as-is cond are as
follows:
  * port is in SRC power role and an explicit contract is negotiated
    with the port partner (in sink role)
  * port partner sends a Soft Reset AMS while VDM State Machine is
    running
  * port accepts the Soft Reset request and the port advertises src caps
  * port partner sends a Request message but since the explicit_contract
    and vdm_sm_running are true from previous negotiation, the port ends
    up sending Soft Reset instead of Accept msg.

Stub Log:
[  203.653942] AMS DISCOVER_IDENTITY start
[  203.653947] PD TX, header: 0x176f
[  203.655901] PD TX complete, status: 0
[  203.657470] PD RX, header: 0x124f [1]
[  203.657477] Rx VDM cmd 0xff008081 type 2 cmd 1 len 1
[  203.657482] AMS DISCOVER_IDENTITY finished
[  203.657484] cc:=4
[  204.155698] PD RX, header: 0x144f [1]
[  204.155718] Rx VDM cmd 0xeeee8001 type 0 cmd 1 len 1
[  204.155741] PD TX, header: 0x196f
[  204.157622] PD TX complete, status: 0
[  204.160060] PD RX, header: 0x4d [1]
[  204.160066] state change SRC_READY -> SOFT_RESET [rev2 SOFT_RESET_AMS]
[  204.160076] PD TX, header: 0x163
[  204.162486] PD TX complete, status: 0
[  204.162832] AMS SOFT_RESET_AMS finished
[  204.162840] cc:=4
[  204.162891] AMS POWER_NEGOTIATION start
[  204.162896] state change SOFT_RESET -> AMS_START [rev2 POWER_NEGOTIATION]
[  204.162908] state change AMS_START -> SRC_SEND_CAPABILITIES [rev2 POWER_NEGOTIATION]
[  204.162913] PD TX, header: 0x1361
[  204.165529] PD TX complete, status: 0
[  204.165571] pending state change SRC_SEND_CAPABILITIES -> SRC_SEND_CAPABILITIES_TIMEOUT @ 60 ms [rev2 POWER_NEGOTIATION]
[  204.166996] PD RX, header: 0x1242 [1]
[  204.167009] state change SRC_SEND_CAPABILITIES -> SRC_SOFT_RESET_WAIT_SNK_TX [rev2 POWER_NEGOTIATION]
[  204.167019] AMS POWER_NEGOTIATION finished
[  204.167020] cc:=4
[  204.167083] AMS SOFT_RESET_AMS start
[  204.167086] state change SRC_SOFT_RESET_WAIT_SNK_TX -> SOFT_RESET_SEND [rev2 SOFT_RESET_AMS]
[  204.167092] PD TX, header: 0x16d
[  204.168824] PD TX complete, status: 0
[  204.168854] pending state change SOFT_RESET_SEND -> HARD_RESET_SEND @ 60 ms [rev2 SOFT_RESET_AMS]
[  204.171876] PD RX, header: 0x43 [1]
[  204.171879] AMS SOFT_RESET_AMS finished

This causes COMMON.PROC.PD.11.2 check failure for
TEST.PD.VDM.SRC.2_Rev2Src test on the PD compliance tester.

Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Fixes: 8d3a0578ad1a ("usb: typec: tcpm: Respond Wait if VDM state machine is running")
Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable <stable@kernel.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260414-fix-soft-reset-v1-1-01d7cb9764e2@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kept `tcpm_pd_send_control(port, PD_CTRL_ACCEPT)` call unchanged ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4576,6 +4576,8 @@ static void run_state_machine(struct tcp
 		port->message_id = 0;
 		port->rx_msgid = -1;
 		tcpm_pd_send_control(port, PD_CTRL_ACCEPT);
+		port->vdm_sm_running = false;
+		port->explicit_contract = false;
 		tcpm_ams_finish(port);
 		if (port->pwr_role == TYPEC_SOURCE) {
 			port->upcoming_state = SRC_SEND_CAPABILITIES;


