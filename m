Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D07A2210CA;
	Thu, 12 Dec 2024 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020722; cv=none; b=WaosGyA9MYjDffpR4TVUSlz+hPTBueebikOb/MYHMndWMbXKAoHC4go2cbG5xmM0xkQ0FI40xKWhgO+4ZkKMz/3mTFF4POGgxvTidnMrr3LI0PhJ6j0Sw0PKJV2FsC/qrYUzRFrzUr9U6vWnJNsvjHU62xD8281r7Q/yjQVfER8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020722; c=relaxed/simple;
	bh=oy/2a1AJW8dXFBOdNQT1EMGgQc7PNJyuBgGuzMov9pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4gqdyJOtX04O8l+46FakSd7W+66/8OMGsOl4rPb+RyWs/2yJ5+q10q8cFQy7QIUQXCTauhFbEXf2GqhcMBimqwkGpHLJwdV+O/SUMxX1QLce4rfLIIk25IIiE1CE8ADKE2q6aIcy0z1xECYJemK6Q4Oyz+WDOgTGYmKspt5DEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QND/qGGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QND/qGGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7E4C4CECE;
	Thu, 12 Dec 2024 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020722;
	bh=oy/2a1AJW8dXFBOdNQT1EMGgQc7PNJyuBgGuzMov9pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QND/qGGCvVishI0kJ5d4SkE9Amv7CLyLQCt2CoL3ass0bwVCqMxVAEXIqS6b7Z4tx
	 IKXBcgGQJZQGnVEysyDvU+rulE02hyIiaBXic2ZJcR6iNip9TD5tKGBKS4bB3S77YP
	 QLTd+rZ3TGqi4PE71jDg9Z5c3hXP83jQdQGO0Sjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 542/772] netfilter: ipset: Hold module reference while requesting a module
Date: Thu, 12 Dec 2024 15:58:07 +0100
Message-ID: <20241212144412.361092405@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0b24b638bfd2e..56215fb63b645 100644
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



