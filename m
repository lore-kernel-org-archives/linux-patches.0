Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03953D978;
	Tue,  2 Jul 2024 17:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940850; cv=none; b=eP3aJgRZ0bPfuJVCq2yeI+J8totnUDELHQ5KTMuBaA6eXC8y32HpocwBDad7YU/N/Doj8H+S/Jie2+qoDW2eLbE9mUgoL1iZbXnqKDYMlY11UIkgQHMDn85zs/SMFNuq8eAcBnuzAwO8mcgcbxLRD6/+8UI7Upm37rkVSykZh4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940850; c=relaxed/simple;
	bh=PFyEynGUMsQrl97R6WzH5wfq9P+Ndw56n0p/xSa/2C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmbUL14ZugaRTfiwxSuXsSU3NilD8EjznTgtCrp38FCpp0xMbov3CQpy+Hso3upiK64r5U7W8Tovk+LZdrfw+NE2mkwQWMjA1SFXhmK2kM4v25MGlDb6KbRse48hc4mlEyV5XXGgGVRJyExY3EiMi3EE7MJ2G2icNv2uVJaelMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZjU/+Ij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZjU/+Ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24298C116B1;
	Tue,  2 Jul 2024 17:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940850;
	bh=PFyEynGUMsQrl97R6WzH5wfq9P+Ndw56n0p/xSa/2C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZjU/+Ij6LyhnPMz4gJ+AbfCizZSpLxK7KS2I6CwbWNYOOgGWB0ed2ix1OeQdDIsj
	 jSsW5PQ+kzFNfRxZ+rATAVLTvsRRt1xM3zGiuTtWm9yXCDbKnoFSI61vUP49/TS7r7
	 pkSCWaT/6siH6kBQe0e8lfRw2nN4q3dpgo8HoRPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mtodorovac69@gmail.com>,
	kernel test robot <lkp@intel.com>,
	Jianguo Wu <wujianguo@chinatelecom.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/163] netfilter: fix undefined reference to netfilter_lwtunnel_* when CONFIG_SYSCTL=n
Date: Tue,  2 Jul 2024 19:02:31 +0200
Message-ID: <20240702170234.463938437@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



