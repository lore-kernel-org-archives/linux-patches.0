Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDB813A258;
	Thu,  3 Jul 2025 14:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553997; cv=none; b=JGiPNXwEI2yvEHDIfLvsceCl2gbnvn91Vu+FYitVFxoYqJRDeoC5ok4w26v6hInbMxPzKZHaaVW/uULhNQ5lgEM+QgNet0qZkbRXhLk4U4fAIPWbQt4RdkSqMiLI5Wg7tD94CTIoIxaQ6qZ7ainfB1jZdJMuFQoyZHQUDuTSChY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553997; c=relaxed/simple;
	bh=ts+9CWCrUjWX81Tla20EROrJ5TVaU0LoHd+FDeqSucc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpJbRkBhJG6OzGYE+9J785Ii+tY4yf0Pt0WRXhNHYH8Rbi0fQ9fpWtlw+v5+57mjV+itIm4mH8oQvrWgiyBQ75CO7GjD9fbn4aXeOXaDiHNYOZSeatzuH+sZ6cdkmE6YUB/6kko32WoBBm7oFImjGQhtpEuX2/gG4LmdDB9t3Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KezE13jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KezE13jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15130C4CEE3;
	Thu,  3 Jul 2025 14:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553997;
	bh=ts+9CWCrUjWX81Tla20EROrJ5TVaU0LoHd+FDeqSucc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KezE13jrHNhbvS5zPvXgOMxhAeukAEb5x6UeX1ohYilra9RBJf9HQWh+6ZPRpeEkf
	 ee0rDhY8q0XgSQrg+pG7Qrpp6lUfxNZ4tfE7meybOQHpQwnNikFCuQFFWeT6M8aHQd
	 ekKqNhjiZDm6+/fljdhRb6yCrbwtfpTEAEX9si1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/218] usb: typec: mux: do not return on EOPNOTSUPP in {mux, switch}_set
Date: Thu,  3 Jul 2025 16:39:56 +0200
Message-ID: <20250703143957.858508623@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 49926d6e72c71..182c902c42f61 100644
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



