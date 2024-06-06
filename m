Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596F319D078;
	Thu,  6 Jun 2024 14:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683456; cv=none; b=CGqNSGA+24aX8E8UV91nd8E45WSJJE7bLBOPP8lVUjdf0Sg6QEw3PMF3e+PtE0ZKlhX/GgTdxXhpZYLMFqf6jDt3GnoC2ynq6AAQhx2fUxoDOM8NZg17sQPLEffG6Juu0o1z99jJj16VxA6NK0hNitgS0bXq2gh6F5wk0FhMcHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683456; c=relaxed/simple;
	bh=fF/c2KgDcCNruvGgUBrtpJmCgUcyzDWHc40O/vQkKP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIld6afn46RvnpEUUNXqbTfs8dVCb67naZc4B1x8yRRaguRXSsF5MpxHzXwQOnL0aeCrLMlu0R4e04bAe3VCf6RPjoaThCvhOGNroCLedn1gQcpvBSaS2zlZptdDwXTSMrGpIqLl3Us0gPmNgz7GeJIb/v3pe/3MWXZaGGgEm8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WR7m47yQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WR7m47yQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E88C2BD10;
	Thu,  6 Jun 2024 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683456;
	bh=fF/c2KgDcCNruvGgUBrtpJmCgUcyzDWHc40O/vQkKP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WR7m47yQ1TCx27sdWSTA9lw7ZVmkUDyTbZHKwv5vg3f72WerkFrc1mK4Ku7R5qeMX
	 gL7Nc5opiDliWcocdFvI/2qvNH3A0ld8MfpyMQAC1y9HJQd8cuwAcDnpD8gDF4bBj9
	 5gugbG0+6wytug3BDHlXqYM2cqmd6+e3e6c0GhXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 401/744] usb: typec: ucsi: always register a link to USB PD device
Date: Thu,  6 Jun 2024 16:01:13 +0200
Message-ID: <20240606131745.320144550@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c0f66d78f42353d38b9608c05f211cf0773d93ac ]

UCSI driver will attempt to set a USB PD device only if it was able to
read PDOs from the firmware. This results in suboptimal behaviour, since
the PD device will be created anyway. Move calls to
typec_port_set_usb_power_delivery() out of conditional code and call it
after reading capabilities.

Fixes: b04e1747fbcc ("usb: typec: ucsi: Register USB Power Delivery Capabilities")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240329-qcom-ucsi-fixes-v2-4-0f5d37ed04db@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 7d2ca39ad7622..4aac2a719b7cd 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1297,7 +1297,6 @@ static int ucsi_register_port(struct ucsi *ucsi, struct ucsi_connector *con)
 		}
 
 		con->port_source_caps = pd_cap;
-		typec_port_set_usb_power_delivery(con->port, con->pd);
 	}
 
 	memset(&pd_caps, 0, sizeof(pd_caps));
@@ -1314,9 +1313,10 @@ static int ucsi_register_port(struct ucsi *ucsi, struct ucsi_connector *con)
 		}
 
 		con->port_sink_caps = pd_cap;
-		typec_port_set_usb_power_delivery(con->port, con->pd);
 	}
 
+	typec_port_set_usb_power_delivery(con->port, con->pd);
+
 	/* Alternate modes */
 	ret = ucsi_register_altmodes(con, UCSI_RECIPIENT_CON);
 	if (ret) {
-- 
2.43.0



