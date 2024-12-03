Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1B11EE00E;
	Tue,  3 Dec 2024 16:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242516; cv=none; b=SkkSUz0UdgDW2GApgcVt7FGNoq35bQnGRKpyD2vXcRIgO8aR4qNTOmB8goH0wMC7PwQtJcEwvczcVZuF8tLcBVSnRxgMu5Cy5RdvAmTeina73Jgh4uO1M1HfEUZkPu9NsrVC4zpXT+StiqtHcVwiCNIs4Qt6ziDllgoCU2OLYdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242516; c=relaxed/simple;
	bh=GvAfllJtpXPLlgmfXWYlMRU0SMZaZLUNhejTQk0qkH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKOtS4yG9xVZSfdmUZ/Ow/D7kWyhxHTJOJtn41tQbAnTYuAYWsIHct5oFs9+YwdQ6LqKpaOLoTxAo6oLL/oqiISNljoy2b/AngR0BaqSBaPhFBNuiRruonrpyV9RZhd3NCrRP6MO+XCYjsbM1ZR4XvTjd2g9jQzI5ARSpcRhIoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCK/cJsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCK/cJsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC64C4CECF;
	Tue,  3 Dec 2024 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242515;
	bh=GvAfllJtpXPLlgmfXWYlMRU0SMZaZLUNhejTQk0qkH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCK/cJsYzgtJP+mvlWJKUJq5Lywhni4BocJpes+OcACA13KbxeNdv8Da2aLyScqCc
	 3uEzvUFO7KTQv7ylBqKrNYHxVfWLyP+W038C9VwGmxOksdRNFlsfc8/pEBTT7sOUa4
	 tmJbAdga7vDPDC/BXFW+MWkfvrYADxuTwLCZSn2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziwei Xiao <ziweixiao@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 728/826] gve: Flow steering trigger reset only for timeout error
Date: Tue,  3 Dec 2024 15:47:35 +0100
Message-ID: <20241203144812.160335929@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziwei Xiao <ziweixiao@google.com>

commit 8ffade77b6337a8767fae9820d57d7a6413dd1a1 upstream.

When configuring flow steering rules, the driver is currently going
through a reset for all errors from the device. Instead, the driver
should only reset when there's a timeout error from the device.

Fixes: 57718b60df9b ("gve: Add flow steering adminq commands")
Cc: stable@vger.kernel.org
Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Harshitha Ramamurthy <hramamurthy@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241113175930.2585680-1-jeroendb@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -1248,10 +1248,10 @@ gve_adminq_configure_flow_rule(struct gv
 			sizeof(struct gve_adminq_configure_flow_rule),
 			flow_rule_cmd);
 
-	if (err) {
+	if (err == -ETIME) {
 		dev_err(&priv->pdev->dev, "Timeout to configure the flow rule, trigger reset");
 		gve_reset(priv, true);
-	} else {
+	} else if (!err) {
 		priv->flow_rules_cache.rules_cache_synced = false;
 	}
 


