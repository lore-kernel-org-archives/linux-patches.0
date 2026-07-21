Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391093C0617;
	Tue, 21 Jul 2026 21:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669671; cv=none; b=LqHXe/6pjOVKz2VZ2iWulI7Gpevvy8wEwKL3o4QdqlFweeLYkQd1joXyJwv0IWIXfxt/pa/pzxC7Jg4hZYTOcZgve3xEROZijyZTq0eHFvYS+o5JFuJtG9lBHFtui/i1JFhXvji9v7Vxw6WILw36UKA6D6Fq+R7Wq0dyFoqkhS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669671; c=relaxed/simple;
	bh=ELcG9J4AtZIMfKBAIzFuPsHJ+3jyeI37BMIM0lIYvx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXkuWLfnapaDh+2cLffiaf2URuGImwKKYo281j5E9hAsd5t4l25kGZHNg5CSPnYCVeb2M3tJJ/PAKXVA31jSuHC3JHs2aVMCmVeLqtERbaG/lF91xTU1xc43u7sUCjbtCa2v4tWIjCo/fkHrtpLBomNNPJjuKt3TFn84igCet9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYz8C+LW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYz8C+LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2E31F000E9;
	Tue, 21 Jul 2026 21:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669660;
	bh=y8kEPdYDeS3F1nJYLzG7ARefuIKFHsqOmqt3K9aOOUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYz8C+LWSFcupN6gj+nziigLSUUq+v4B6yzXqgDUVqB75D83bRbrangxciZ72uEgd
	 ZITCkCxEyO/7dXDd9yJQIwK/fL1gMDmjkvaJ05z5kzSPqjgh7bIVBXXls6AJ8nFoay
	 W0HHQ7i+VmI/CdDeInnCqF9atDFpKyMZiPBZAdTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0638/1067] ipv6: fix error handling in forwarding sysctl
Date: Tue, 21 Jul 2026 17:20:39 +0200
Message-ID: <20260721152438.866530675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 058b9b19f9639fe1e1225a17c540f61b65bee6ad ]

When writing to the forwarding sysctl, if proc_dointvec() fails to parse
the input, it returns a negative error code. The current implementation
is overwriting that error for write operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure. In addition, adjust return code of
addrconf_fixup_forwarding() for successful operation.

Fixes: b325fddb7f86 ("ipv6: Fix sysctl unregistration deadlock")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-4-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 7994b93ccaed9f..db66a8f1e16885 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -916,7 +916,7 @@ static int addrconf_fixup_forwarding(struct ctl_table *table, int *p, int newf)
 
 	if (newf)
 		rt6_purge_dflt_routers(net);
-	return 1;
+	return 0;
 }
 
 static void addrconf_linkdown_change(struct net *net, __s32 newf)
@@ -6279,6 +6279,8 @@ static int addrconf_sysctl_forward(struct ctl_table *ctl, int write,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_forwarding(ctl, valp, val);
-- 
2.53.0



