Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFD4196C92;
	Thu,  6 Jun 2024 14:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682899; cv=none; b=Jc/+ygcIw2cqexhcAVdl4jAPw3MgSVTJFRe24HyhdQvWg6Jm8ntHcwM55mDjuGSUhqp8KF5fIrHiaiv4iH3ava7Tci1Zo7M4EDZMJBDeydLYpnO0+ZNSDY8KA0H/7GOLvVDS6wiO1ky4Dsqm6n/b6GhKureMoItDaeuE5qu1//8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682899; c=relaxed/simple;
	bh=3nMNGOmEx5/30+KUQV/53ZpBC1xp3NI0SI9A6my+qyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elDUfgjIrLKpqnVZUXyUmCQ+KpIzdBDyutdcujELhaOZNx2M6Uclqff1fOV7CRbW8uCWj14rFa423ikqQAAT7DGTFMeHUZa4zWN21fL9VBB/1vIkuhDS88K5F86ZrMbbbCk+Cy0J2uxcSpKf7oCPMb33b954d/fmlE8DUoy5ohY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iG95mB69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iG95mB69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 791CFC4AF0B;
	Thu,  6 Jun 2024 14:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682898;
	bh=3nMNGOmEx5/30+KUQV/53ZpBC1xp3NI0SI9A6my+qyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iG95mB692WVySTWoIN9RJBEQZWbqtYNfO0YwQXyXvI3vXvwvEqAasPqlbRykZv5I6
	 DjFPt5Uo+OpLhMYNenQo/C2hsC/PdMTCPDg2wyMgVChz+/NCwM0uq5aXX31EJmQllL
	 TryBvWYvJbwVNNaxg3UEuVpY0uotvplMB84xYRiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 016/374] usb: typec: ucsi: always register a link to USB PD device
Date: Thu,  6 Jun 2024 15:59:55 +0200
Message-ID: <20240606131652.318418865@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 7ec4fa4ff478f..7a427c8e92e29 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1573,7 +1573,6 @@ static int ucsi_register_port(struct ucsi *ucsi, struct ucsi_connector *con)
 		}
 
 		con->port_source_caps = pd_cap;
-		typec_port_set_usb_power_delivery(con->port, con->pd);
 	}
 
 	memset(&pd_caps, 0, sizeof(pd_caps));
@@ -1590,9 +1589,10 @@ static int ucsi_register_port(struct ucsi *ucsi, struct ucsi_connector *con)
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



