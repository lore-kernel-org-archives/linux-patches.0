Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50962EF67F;
	Thu,  3 Jul 2025 15:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555613; cv=none; b=B6MLlE3a4h861ixgd/ibcfxjFEM3lAK3arzYmnxOJXB4FkOb0BSnZVg07WvCYa8M0cfOYOxyreaCuMmFwvLK3zv8o8BuE1OR+PQRqZj87Jn1Bz/5/VKwdMbaBjpZYhvP0esl3e9tInBOE7ZYYUwz5KgjhA7FglXbBLo6QAyz+Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555613; c=relaxed/simple;
	bh=s3BXem6d4DcHUgbH93b6UJrvmVjbJDeNlj88yyJdrrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM4suE8Jlyr8McqslCgJ5lV9KbhTfWaO7qCvz7/t+yjEln3tAXv2tXvuIhcNohqDR/dd2HWBH2PlCbHMTOnGDMThjiA5N8493Tlvs6S6yy0LTpf0oTnnRtowkgODt3+oW0rDaPpH4bY/HGErQ4ks+O3i8uwelfSNJeBTrrtygCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oknbb+7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oknbb+7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1510EC4CEE3;
	Thu,  3 Jul 2025 15:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555613;
	bh=s3BXem6d4DcHUgbH93b6UJrvmVjbJDeNlj88yyJdrrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oknbb+7HQzNvZAwl4Kd2WnJhk1EG8+65vipc6IJMnLVeKkq8Szb8+SyMDEpADo6tX
	 OtowQd4Ygum++HNx4GblqRqUxkbS3NCMytvhyJI1+o3eq5gc19SenzmDgNnoNXqhdp
	 zDTNE3altqHWs1Ztyjc6bR1/KItBb6dNtAz3y1DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/139] usb: typec: mux: do not return on EOPNOTSUPP in {mux, switch}_set
Date: Thu,  3 Jul 2025 16:41:42 +0200
Message-ID: <20250703143942.708580898@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 0f7bbef1794dc87141897f804e5871a293aa174b ]

Since the typec connectors can have many muxes or switches for different
lanes (sbu, usb2, usb3) going into different modal states (usb2, usb3,
audio, debug) all of them will be called on typec_switch_set and
typec_mux_set. But not all of them will be handling the expected mode.

If one of the mux or switch will come back with EOPTNOSUPP this is no
reason to stop running through the next ones. Therefor we skip this
particular error value and continue calling the next.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250404-ml-topic-typec-mux-v1-1-22c0526381ba@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/mux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/mux.c b/drivers/usb/typec/mux.c
index 80dd91938d960..a5b2a6f9c5795 100644
--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -214,7 +214,7 @@ int typec_switch_set(struct typec_switch *sw,
 		sw_dev = sw->sw_devs[i];
 
 		ret = sw_dev->set(sw_dev, orientation);
-		if (ret)
+		if (ret && ret != -EOPNOTSUPP)
 			return ret;
 	}
 
@@ -378,7 +378,7 @@ int typec_mux_set(struct typec_mux *mux, struct typec_mux_state *state)
 		mux_dev = mux->mux_devs[i];
 
 		ret = mux_dev->set(mux_dev, state);
-		if (ret)
+		if (ret && ret != -EOPNOTSUPP)
 			return ret;
 	}
 
-- 
2.39.5



