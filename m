Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C948C408617;
	Tue, 21 Jul 2026 22:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672045; cv=none; b=FmpWxgH76oS6w0krH2VMb8ePTDa9pseimuYc9kfYZci5xdY6tciVrn4K7Do9WhPi7YFSJF8BoZPIwkrNw3XYS+nMM6eILlD/eyHMoEquAoQA/Xu+OCAduNunkAX2+utzaiCSDEbKpCO11klsqQ2d1B8rLBAd54OmGWOL8MMfcQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672045; c=relaxed/simple;
	bh=DB+NGn1IL9dGvl7ulyxibxJwD6ZE1XeI5dYnfuFdDpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbxyQBv616u+jCYkmcJ5Pgpyu10dFVmQxcQWTmcpS7QQ6vAWOeSCpHjQo2crMfIx9zaj3gyZED6cA7l+szCmXrmL7OWRgEi3NyOsPRrU+Vkf3Wum8/zab8v2GkvFsdWVqF8O0p30bdSGj8CycaeWpdIsqQ/5vsRLctF0Y/Hxyeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FUW2Ti0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FUW2Ti0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5071F000E9;
	Tue, 21 Jul 2026 22:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672044;
	bh=rbHf00O/aqWY9u4NkJ87VY1P/VkkatYMzlbxSU4nyZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FUW2Ti0zpGpCG3/iR8Q0a+fiIcu311dxOPP6oq4kzu6pDbERWMQOo0cg4OpOH72C
	 9gqx97nJwm2pU4Rh/OrUMO2RWsqpUYset4r+htJbvuK0og8hJqTy3pRyMzTlEt2EL5
	 l6RfuyBmestmZr+HEFez643qTRPGM5QTr5iwy2Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 476/843] ipv6: fix error handling in disable_ipv6 sysctl
Date: Tue, 21 Jul 2026 17:21:51 +0200
Message-ID: <20260721152416.744218802@linuxfoundation.org>
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
index 4879487ecaaf27..cd491b118238a3 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6350,6 +6350,8 @@ static int addrconf_sysctl_disable(struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_disable_ipv6(ctl, valp, val);
-- 
2.53.0



