Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F421EF0AC;
	Tue,  3 Dec 2024 15:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239771; cv=none; b=MosalfSpTNVJdBim7x+gpAAosCQbfoRsFrz7jLxa/BvDPPJHGeA5ObngEQE40CJ2YaSNVPEKQAywDTVUZSAxzVmdJxEZgYz2rABhNuP3akTHm9pJo9aSqftKxJlZ9QLdEx90JiVJJ7NzM+O6Vo7wQ/5JnvHGAarvFouByIa6Tpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239771; c=relaxed/simple;
	bh=2jhjPke+roiIqQPyAo3IHbRR7QrYnRBQ5uQEjjEGWNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOsQ3+Kt76UsysdGrn6iVZRk+0vWB3xh9dmS3nBdAFa/Njo/fo0CjWLlbKcJZBHUYGMFpAltE2kfg8sKc6kt1b+y8rnq8t/aW6L/2WxchpY/RV25CbKcGKhkMl0vVUQytYF2h/Ea2Bp7th7YaAZjTzSAaUnZ+66WA1aIy22VzMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akFngOh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akFngOh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E315EC4CECF;
	Tue,  3 Dec 2024 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239771;
	bh=2jhjPke+roiIqQPyAo3IHbRR7QrYnRBQ5uQEjjEGWNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=akFngOh06s+1+zVWqXHyBV6y+Pu8GcdYU+n2KPS0WqQwbk+wlNBVltoAT2fwrwliq
	 IT5SLAcaPIvEQgCk5LwgEiv3He14+884w0uQMWOwVax9YTZmvNJTR31zfDH5GhlJdQ
	 j7wTGnBposIAriy2INuNLhGreNModNjsL2w6Rsgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziwei Xiao <ziweixiao@google.com>,
	Jeroen de Borst <jeroendb@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 729/817] gve: Flow steering trigger reset only for timeout error
Date: Tue,  3 Dec 2024 15:45:01 +0100
Message-ID: <20241203144024.450261241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1208,10 +1208,10 @@ gve_adminq_configure_flow_rule(struct gv
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
 


