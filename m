Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F305843B48C;
	Tue, 21 Jul 2026 22:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674084; cv=none; b=ZuJ1+AReW4h80sXG4spo6SQyCZ2UzwWZ4mzF0Qa+l9nJ9Gzex5O3SyupHYpQMsqdcSa/v8//0IHaMlNomlB2/QaaX7t7V5oOk/hMXIw7Mgwkweu8QdCQGWo5ZCTmsl4jimtkSMFTJTsoHIH/QOGPDjsr8tDSkie2yONlFC5u6JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674084; c=relaxed/simple;
	bh=sGlLy4IAV7/TQNOXRjaB7F7L+hoiXKHkf69MbnrKP+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKOY6PrWC6VsIKuZNBT9TF9vb8QTEm4KPq4J0lClXP3X8kF5cT9Np26mO2tPeYSJIOSDsxAy/GGu5yqmSaO1AsjBeNjrKoKW2Pbdm1REMc353TtBBDKK4+WZKJRGB1MhFvx56h+JCFHOVCKqWGfodNSMkmhzkXeZUXMufz4lmFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlGUclFO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlGUclFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1061F000E9;
	Tue, 21 Jul 2026 22:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674080;
	bh=dHGFjEooUYaHAJRXlPTXBVVCNpPz3pUtpDk7zcrcW7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlGUclFOYMwxfnKt1Ip5KxmZWoIrT7biDbNDHOs1Utl1T0zsqJSwgKzvBWjky0aak
	 jLZr20nx4exGAX5Da+AuOcmyh59oR+1cCnBlb0FDmrtAi/eEmC8OQ/cslKJXuZ3GO7
	 mdy4BalKqePVQoTZOn2p2er1hcUTM9oUenZ0CqH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/699] ipv6: fix error handling in disable_ipv6 sysctl
Date: Tue, 21 Jul 2026 17:22:02 +0200
Message-ID: <20260721152403.882441364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit c779441e5070e2268bdfe77f6e2e0de926c431e3 ]

When writing to the disable_ipv6 sysctl, if proc_dointvec() fails to
parse the input, it returns a negative error code. The current
implementation is overwriting that error for write operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: 56d417b12e57 ("IPv6: Add 'autoconf' and 'disable_ipv6' module parameters")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-2-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c0f84b2315528f..c888471bf5d355 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6291,6 +6291,8 @@ static int addrconf_sysctl_disable(struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_disable_ipv6(ctl, valp, val);
-- 
2.53.0



