Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989A2178381;
	Tue,  2 Jul 2024 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940103; cv=none; b=GpDVSp5Omck3Lew9nN9WtFrHgkrX/9gXgYCjWNwX70va37QhdvwOYugmllEiPXfLCc1qKCVodiUlaMpSF6DPx6hJnNpvDq48grkw2rDBIrbL13que8CScD0vRDE8iDVXUxkrWXQ2ESl5iOrKBHXvI6uTPhSp0FC1dqVOOz+XkcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940103; c=relaxed/simple;
	bh=iOfAwu0EXIzzg6IDfrP8rjr5peyKZECKgFdltgeNLbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq4ZmKxRil3vsvyPJXR1F804LEnHVA5AqFsrUJAFSgEBhA/KCkrYto0QF4dJsyWNntTB+n93Z3qmNB5ntjKEq31WxdSst7CXCliyApwTr6V8gA4kuxFo0V4OjNFGbcVVVf9XqdEokdFZsK8Gu0CyJkyrGQvjnW5HPJX0xxefTfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBNXroNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBNXroNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068EFC116B1;
	Tue,  2 Jul 2024 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940103;
	bh=iOfAwu0EXIzzg6IDfrP8rjr5peyKZECKgFdltgeNLbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBNXroNERCeWh7rZtuDKJXjClh/VoIC1OyO7X23VIdg8kgOxtk6wZCwuFHQSonFqv
	 8L8NxPp8+nC2/4AQAbzduhTpWRujx+3uEtkwsX9r1iwJZUyZfYPfSSoONKhGJBpjFU
	 FOGBpbffZbXm2GtFaYJZFHocgi+LjOMpPzUTa74w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Jianguo Wu <wujianguo@chinatelecom.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 046/222] netfilter: fix undefined reference to netfilter_lwtunnel_* when CONFIG_SYSCTL=n
Date: Tue,  2 Jul 2024 19:01:24 +0200
Message-ID: <20240702170245.736316485@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit aef5daa2c49d510436b733827d4f0bab79fcc4a0 ]

if CONFIG_SYSFS is not enabled in config, we get the below compile error,

All errors (new ones prefixed by >>):

   csky-linux-ld: net/netfilter/core.o: in function `netfilter_init':
   core.c:(.init.text+0x42): undefined reference to `netfilter_lwtunnel_init'
>> csky-linux-ld: core.c:(.init.text+0x56): undefined reference to `netfilter_lwtunnel_fini'
>> csky-linux-ld: core.c:(.init.text+0x70): undefined reference to `netfilter_lwtunnel_init'
   csky-linux-ld: core.c:(.init.text+0x78): undefined reference to `netfilter_lwtunnel_fini'

Fixes: a2225e0250c5 ("netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core")
Reported-by: Mirsad Todorovac <mtodorovac69@gmail.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406210511.8vbByYj3-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202406210520.6HmrUaA2-lkp@intel.com/
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_hooks_lwtunnel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 7cdb59bb4459f..d8ebebc9775d7 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -117,4 +117,7 @@ void netfilter_lwtunnel_fini(void)
 {
 	unregister_pernet_subsys(&nf_lwtunnel_net_ops);
 }
+#else
+int __init netfilter_lwtunnel_init(void) { return 0; }
+void netfilter_lwtunnel_fini(void) {}
 #endif /* CONFIG_SYSCTL */
-- 
2.43.0



