Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E3344607D;
	Tue, 21 Jul 2026 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649200; cv=none; b=HHLMrx2/ZeLQk0WafH0SZTr9ttXbsvXHF+1PYtknN7UXhhcYwgZCKYE/9A7WSvl6btqZ1g/j6/e1LumiTQfZp2Q2PklxjWXasiOg48oI/0Hjlm8tz3d0YHSE61BhewJ6DzSoo2KIUdiWvX7UPYwc8JEPGTbLJvJ61skypV5O2aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649200; c=relaxed/simple;
	bh=7MLVN6kQqGGL1qI3TvgshsrmCoE+A3ZoNH3oDVBn/Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqnpCQSujclsQtPWLz6W8D1PyusR7DGnvTDaF//DFwRXJ2PUHHA1DMussNsN9a/VnwrqM6senxe57rrmMtY27c3CGrO7KZUA2hZbF3eBvzFnsLza9hce1QZWNxsY1bVKmWU77AEtBx2j8oLq5C2a6fpbuXqFNr2vDuZlUuYItSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0zPkGWv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0zPkGWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9C41F00A3A;
	Tue, 21 Jul 2026 15:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649199;
	bh=Yqjfxu6fCMljDtXnVOaiqc/wPpfF0y5DmXTPOWEE4fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0zPkGWv5QLroJFTRs0TYBi7da7V/5sBq4tJKiwSSHhdzpBFT85MayclOeZLFm3ip
	 mrsJt5nVhSQ4DA4n6Hwi0/oWFT0qRn8HDnERS3EzvC/8dqyooVWEa5Df2XngdiigqM
	 0lVExHnIJic5iwQmOMFy4OswOgYgjKWRJqhxLA5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0487/2077] netfilter: synproxy: adjust duplicate timestamp options
Date: Tue, 21 Jul 2026 17:02:40 +0200
Message-ID: <20260721152604.296130144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 22bb132cfb9b94847d52d73614284b8c5ea8d36e ]

RFC 9293 does not mention anything about duplicated options and each
networking stack handles it in their own way. Currently, Linux kernel is
processing options sequentially and in case of duplicated timestamp
options, the value from the latest one overrides the others.

As SYNPROXY is modifying only the first timestamp option found, a packet
can reach the backend server and it might parse the wrong timestamp
value. Let's just continue parsing the following options and in case a
duplicated timestamp is found, adjust it too.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_synproxy_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index f99c22f57b7e52..a0bcf188810d13 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -233,7 +233,6 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 				}
 				inet_proto_csum_replace4(&th->check, skb,
 							 old, *ptr, false);
-				return true;
 			}
 			optoff += op[1];
 		}
-- 
2.53.0



