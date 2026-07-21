Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D02407CDA;
	Tue, 21 Jul 2026 22:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672056; cv=none; b=apJRfm5P7sHVDBCnCCfTVZIcO3N2k5tu47lOUTxxQ2PRw6pJrkgNGqZbWnRXOzs0sS1Ic83xoDSPTKJ29pkRkmIl1L2JhBj/T0xun1VXRvhg7rR1UZT+Ir7HgirQ1djlNyCj4Pxq+hEk+GMPFKSq3sRQfgaI2RfjJmyL+XcZfBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672056; c=relaxed/simple;
	bh=gShtSmvY0xvzGonOdBHlAayuciQ3YiHf4awjgwA4pcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kxp6/umf5gQ2YpZRNv7nNk8jSf1m01Gv/R8wxd5YVUnx4Vp3O+yDkLtBp/wSOSiEcs7JF1tb6eDD5hQD0esA2ecNynA1S9B8uR+DQov+hNOIj/qCriFxgyW842FPpqyHr9Pu63yL64Ga+VSDS2AwZphJ4MNZI/BCXet2iP4+gvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xfq2k1ee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xfq2k1ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA271F000E9;
	Tue, 21 Jul 2026 22:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672055;
	bh=4BDtyVNWUPqUwo3+soWQ7A94mFC3gvwb9nDpnN3zuyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xfq2k1eeHBjpvFVPiKaRqfUF3+zdVUViofRoguBm1NDUPMYO5iD6MN3wWiZnWZVEw
	 QQNHr/kDM4zN0/UtBZWC7hM0pol2SrTept7A1gdCBvY8mLXEoGOaOtwpDSCrQC3L+9
	 RygnUtBiYKVt8G/6QH3wJQaH5OgUKqqh+9O5ibWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/843] ipv6: fix error handling in disable_policy sysctl
Date: Tue, 21 Jul 2026 17:21:54 +0200
Message-ID: <20260721152416.809964088@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 3e0e51c0ee1d08cc9d48dc17f3248d5b31cf8066 ]

When writing to the disable_policy sysctl, if proc_dointvec() fails to
parse the input, it returns a negative error code. The current
implementation is resetting the position argument even if an error
occurred during proc_dointvec() and not only during sysctl restart.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: df789fe75206 ("ipv6: Provide ipv6 version of "disable_policy" sysctl")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-5-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 2e46a570b162a4..ef28ab863a6c40 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6647,6 +6647,8 @@ static int addrconf_sysctl_disable_policy(struct ctl_table *ctl, int write,
 	lctl = *ctl;
 	lctl.data = &val;
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write && (*valp != val))
 		ret = addrconf_disable_policy(ctl, valp, val);
-- 
2.53.0



