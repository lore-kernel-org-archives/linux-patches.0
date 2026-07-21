Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D5F3B0AC6;
	Tue, 21 Jul 2026 20:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666915; cv=none; b=KbXrSmvtxCwHkdstQVwxlUxCV9p9p5SFORhUtdu2k4AGuGQmPPvgAwhG2OxTjlYnjbllL+ObXb+r+r/y6cBI9450Ot+YaRFcbAMa+A6ANArSru+wkukoHJeEOUqVbKkN159DdChIFxrlfBP1SzuXTPQW+y4Rk+XhGnvEip4r1dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666915; c=relaxed/simple;
	bh=Xey8+h26lnxoq7GZmXf0/C1agY9vnXsdCecewXba7OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaVaB60bbI35CXgZjS0v2WgceSHZrzfHQG1xR+OPpM5KKFmJSYhDFfwFLVyY0L5Z7mqKHX2bf41GpTEPmDMIVZsHecEDRospPr1dr6pU1k4aMmwXvwsZeR80lEIt41eLAU1ZqK2vt3LuzkSMrGUM6tXDDNcgE2G3aQiBHtygUTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bezeUrP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bezeUrP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1651F00ADB;
	Tue, 21 Jul 2026 20:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666911;
	bh=qHlUvzkRKBXvCvWhGknsQ6gDFGQZs5ZPyvjvhL2GTxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bezeUrP6DR8XRoDuWtma2Be3ay43GVGYV0d3/zkBdQt9XsXEWS01RpUPVPRWBtwdc
	 JzXmbzUIIoJ0JLzaz4wyDJxyu5aUs3hh93xysz8iwoMwLmVh2qrWZy1d57j6AVMBoF
	 NCQBIbp5W/Lm4NgmEiKz/DlaZCHlo1TsR/vRLFqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0861/1266] amt: fix size calculation in amt_get_size()
Date: Tue, 21 Jul 2026 17:21:38 +0200
Message-ID: <20260721152501.117609806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9e05e91a9a847ed57926414bd7c2c5e54d6c56c6 ]

amt_get_size() incorrectly used sizeof(struct iphdr) for the sizes of
IFLA_AMT_DISCOVERY_IP, IFLA_AMT_REMOTE_IP, and IFLA_AMT_LOCAL_IP.
These attributes contain IPv4 addresses (__be32), not full IP headers.

Replace sizeof(struct iphdr) with sizeof(__be32) to avoid over-allocating
netlink message space.

Fixes: b9022b53adad ("amt: add control plane of amt interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260701122329.3562825-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index ddd087c2c3ed45..f2da0c49171f5d 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -3303,9 +3303,9 @@ static size_t amt_get_size(const struct net_device *dev)
 	       nla_total_size(sizeof(__u16)) + /* IFLA_AMT_GATEWAY_PORT */
 	       nla_total_size(sizeof(__u32)) + /* IFLA_AMT_LINK */
 	       nla_total_size(sizeof(__u32)) + /* IFLA_MAX_TUNNELS */
-	       nla_total_size(sizeof(struct iphdr)) + /* IFLA_AMT_DISCOVERY_IP */
-	       nla_total_size(sizeof(struct iphdr)) + /* IFLA_AMT_REMOTE_IP */
-	       nla_total_size(sizeof(struct iphdr)); /* IFLA_AMT_LOCAL_IP */
+	       nla_total_size(sizeof(__be32)) + /* IFLA_AMT_DISCOVERY_IP */
+	       nla_total_size(sizeof(__be32)) + /* IFLA_AMT_REMOTE_IP */
+	       nla_total_size(sizeof(__be32)); /* IFLA_AMT_LOCAL_IP */
 }
 
 static int amt_fill_info(struct sk_buff *skb, const struct net_device *dev)
-- 
2.53.0



