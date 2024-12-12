Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33862153F4;
	Thu, 12 Dec 2024 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015801; cv=none; b=PZOmoDs6d6lGsqaPEwcpm02Kyxp/sfHCD/Ea0hcxbiWGXv9Agvt0IgKic4Qvm+oQ8h+YywIn65+PJQXd1X+YNnU8+cjjVbDSJ5+rZLrxn3siJgwpO8vFHlYOAajAdzqcxOKntfTO2MtsQN+/zQHcAbmi3H4+0YUboIrV512tJI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015801; c=relaxed/simple;
	bh=KoaMbUvhKDnRauL3gAu+hl+ePg2a/FvpLh7M6up3Hxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO85Mq+Wz6cnYx5otZrbJocGjLMNgsylp/0m0J9ZVWZWoz4B8HBFCvaADsRpdjB9OCFaEJ92YnGH/6G8xHfK9/ykbuxgsKWgRsa7SXcrPQ8hKwZfJK4nS0hc1nn7861fLGuhdcEy6Bl6SLsw11ZfyK0Iukr9LkhYf/bsCOUm/pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DW7vWSX/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DW7vWSX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDB8C4CEDF;
	Thu, 12 Dec 2024 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015800;
	bh=KoaMbUvhKDnRauL3gAu+hl+ePg2a/FvpLh7M6up3Hxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DW7vWSX/mR3GRzbl4qDnB/HyJwJb7OUSMUKF1fqLcg0YVi0ocqeiMYW0ZqxaDkBCX
	 wxuIXzxvlF0FjAoo2CksnAS7sM8nMbKCiVVKrwHaCdQmKIAm+K8cjuo0w1kkVjwybB
	 FZ6otZQn+Vcr3eB+7HFNJFKVpo0ivNVbI929oO80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/466] netfilter: ipset: Hold module reference while requesting a module
Date: Thu, 12 Dec 2024 15:53:37 +0100
Message-ID: <20241212144308.585433214@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 456f010bfaefde84d3390c755eedb1b0a5857c3c ]

User space may unload ip_set.ko while it is itself requesting a set type
backend module, leading to a kernel crash. The race condition may be
provoked by inserting an mdelay() right after the nfnl_unlock() call.

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 61431690cbd5f..cc20e6d56807c 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -104,14 +104,19 @@ find_set_type(const char *name, u8 family, u8 revision)
 static bool
 load_settype(const char *name)
 {
+	if (!try_module_get(THIS_MODULE))
+		return false;
+
 	nfnl_unlock(NFNL_SUBSYS_IPSET);
 	pr_debug("try to load ip_set_%s\n", name);
 	if (request_module("ip_set_%s", name) < 0) {
 		pr_warn("Can't find ip_set type %s\n", name);
 		nfnl_lock(NFNL_SUBSYS_IPSET);
+		module_put(THIS_MODULE);
 		return false;
 	}
 	nfnl_lock(NFNL_SUBSYS_IPSET);
+	module_put(THIS_MODULE);
 	return true;
 }
 
-- 
2.43.0



