Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6422EE996;
	Thu,  3 Jul 2025 14:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554472; cv=none; b=cTCM9jwqMC8HBseMoJuAygdy84wXCE9nxki443ymqfziUHsUETvIGY+j+9Z18WrLzWI+SD7BcJIHMMM9Y7pvENfQWTbATYgXGmZ454dkwFpIhRh8hZwGvvwvkFfawCo0AggVdSe8lHDXrwvSV80ZBVrHsvi5G42zdRJzkZO9sJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554472; c=relaxed/simple;
	bh=MwoFAKfIgAbpGto5ohT+pzZJ8qJPjXJtroI7jMy73eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ul8RCy40FnoN3LcDINpy47eU5n8p6zPL9bF5Y2tgBxWMb3pgaqdsHUxlp6bK9XFyBkiyAAkJfmOEMRly6rT8RUpy6YaqqhXy0prVsjwEdzNq0wG9pvCctWu6KQpGEVO9RtYz6PtvasL0iEbGTy1urpBZL1cMMwPX64LqNUjN5og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7bisfzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7bisfzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650ECC4CEE3;
	Thu,  3 Jul 2025 14:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554471;
	bh=MwoFAKfIgAbpGto5ohT+pzZJ8qJPjXJtroI7jMy73eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7bisfzgFNC8NaiNJkLMSLLoF0Y+hKoRlEuhR6/uoeXuCX8zIPBTfXU86eOQCfr1L
	 UngGv7kTZsFeoExhEvzdoCLRMgoXQ/8iJL2xelFBV46MMJRdgBu1Ld/samGjt/2eAf
	 6ppo/2yMn/ZbzPG6gbsNZThnxbd7lxkZvnnwbMQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jos Wang <joswang@lenovo.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Amit Sunil Dhamne <amitsd@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/218] usb: typec: tcpm: PSSourceOffTimer timeout in PR_Swap enters ERROR_RECOVERY
Date: Thu,  3 Jul 2025 16:42:27 +0200
Message-ID: <20250703144004.172118009@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 659f5d55feb75782bd46cf130da3c1f240afe9ba ]

As PD2.0 spec ("6.5.6.2 PSSourceOffTimer")，the PSSourceOffTimer is
used by the Policy Engine in Dual-Role Power device that is currently
acting as a Sink to timeout on a PS_RDY Message during a Power Role
Swap sequence. This condition leads to a Hard Reset for USB Type-A and
Type-B Plugs and Error Recovery for Type-C plugs and return to USB
Default Operation.

Therefore, after PSSourceOffTimer timeout, the tcpm state machine should
switch from PR_SWAP_SNK_SRC_SINK_OFF to ERROR_RECOVERY. This can also
solve the test items in the USB power delivery compliance test:
TEST.PD.PROT.SNK.12 PR_Swap – PSSourceOffTimer Timeout

[1] https://usb.org/document-library/usb-power-delivery-compliance-test-specification-0/USB_PD3_CTS_Q4_2025_OR.zip

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable <stable@kernel.org>
Signed-off-by: Jos Wang <joswang@lenovo.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Amit Sunil Dhamne <amitsd@google.com>
Link: https://lore.kernel.org/r/20250213134921.3798-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 1d8e760df483c..9838a2c8c1b85 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5566,8 +5566,7 @@ static void run_state_machine(struct tcpm_port *port)
 		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB,
 						       port->pps_data.active, 0);
 		tcpm_set_charge(port, false);
-		tcpm_set_state(port, hard_reset_state(port),
-			       PD_T_PS_SOURCE_OFF);
+		tcpm_set_state(port, ERROR_RECOVERY, PD_T_PS_SOURCE_OFF);
 		break;
 	case PR_SWAP_SNK_SRC_SOURCE_ON:
 		tcpm_enable_auto_vbus_discharge(port, true);
-- 
2.39.5



