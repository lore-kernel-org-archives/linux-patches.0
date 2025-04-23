Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55762C8EB;
	Wed, 23 Apr 2025 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419858; cv=none; b=bqQNsOymB0DOTWmoIp1eatzzoKYW+0BuepvHwFFPu+1eKqLm1tt2f1Ut9CchR+R/kZsxsozoOPC1W0t0lfyJ1FCqsd08eAMlxfm9RlZznKaySG2yYzOCEMFXNNPaQZS7oh2dwjRYTZygwSVVMZMZMkMAptk0ugeI57BHn+yfsvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419858; c=relaxed/simple;
	bh=+r5AFtB+hTLGloy/XwWZVf4+4oK5moIgy4QgMx9ivP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHEVABRD4or9DssktDYOmg++SPWpMyj/fwPntg8BzhPr7VEkr17UeMfaeYYudPp1yHIRaKKJAUPIi2VtxWnDOMFTLr66573MXH4wnsKqBInOoGWesS3clG+gOxtI05el5vIGVfVhixqryW5uZaTa0/8xxl7CTXjVu/7VKXpd/H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWqdpPJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWqdpPJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0B0C4CEE2;
	Wed, 23 Apr 2025 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419858;
	bh=+r5AFtB+hTLGloy/XwWZVf4+4oK5moIgy4QgMx9ivP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWqdpPJkII4sv0s8ju6yHCIS+SGWRfHPKZRgOVvuibf8nAX7pgxJRUGjdSl6WsVW+
	 GKLYyTd7Bwrt449WT6kjAggtXjlSXHM5EC/q7HxcwV1+XuuKt1va57lxcYqgIdKurc
	 9++3L0zdYHZzOQATQc+x+ZoksIc6uCu8nPFoVFco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/393] rtnl: add helper to check if a notification is needed
Date: Wed, 23 Apr 2025 16:38:29 +0200
Message-ID: <20250423142643.821081244@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 8439109b76a3c405808383bf9dd532fc4b9c2dbd ]

Building on the rtnl_has_listeners helper, add the rtnl_notify_needed
helper to check if we can bail out early in the notification routines.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://lore.kernel.org/r/20231208192847.714940-3-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 369609fc6272 ("tc: Ensure we have enough buffer space when sending filter netlink notifications")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtnetlink.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index a7d757e96c55f..0cbbbded03319 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -137,4 +137,19 @@ static inline int rtnl_has_listeners(const struct net *net, u32 group)
 	return netlink_has_listeners(rtnl, group);
 }
 
+/**
+ * rtnl_notify_needed - check if notification is needed
+ * @net: Pointer to the net namespace
+ * @nlflags: netlink ingress message flags
+ * @group: rtnl group
+ *
+ * Based on the ingress message flags and rtnl group, returns true
+ * if a notification is needed, false otherwise.
+ */
+static inline bool
+rtnl_notify_needed(const struct net *net, u16 nlflags, u32 group)
+{
+	return (nlflags & NLM_F_ECHO) || rtnl_has_listeners(net, group);
+}
+
 #endif	/* __LINUX_RTNETLINK_H */
-- 
2.39.5



