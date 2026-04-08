Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE9825A321;
	Wed,  8 Apr 2026 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674353; cv=none; b=efW+ofbPneZcEZ2S3YgfgZcaoU1mMif2RClpKOQMX76FkVAHjgtU2P3ouDNvQLpvTBc+xzu1+1LvlH1HP4vN+6ZhUsrzB0rN+zA0PAEMg9mdo3WQkNtpuWFmph7SGqMuPAmaLIi9tEfWHUlSWuEI98qPMDFl+tTBPGVtYB2uJLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674353; c=relaxed/simple;
	bh=cQwh2KMflZFAOwtEyM/oZ7UjkNUqUGDsWFAqRYYNNwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvyTpowTDuAZ8zSwBhv3e/f31K1CALqccsKU1yIdAmy67YrHSO3NNZoL0ry4u8+sIh4Jzxn1lMgHdojpTXVmtteJYlvFkggR4Iyh3rZmLjNthNL0bbHyOYsIRWZ0aLW9HMkcHMLXhdeC47dOh5jx1WPfZqaWupygMxDl5+2PMAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+xjCIhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+xjCIhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9516C19421;
	Wed,  8 Apr 2026 18:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674353;
	bh=cQwh2KMflZFAOwtEyM/oZ7UjkNUqUGDsWFAqRYYNNwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+xjCIhSh2nnTbYm8quf7UGuYvqSdNZid7m/+oBdnjLtiJZuO4YJCaCO3LECVUObg
	 s5hF/sLT4hYZw2l1oVPqdMUjldwzJDizrWzZtnBcVacDmwQ31OoPLSuhnqpT4x++vx
	 TmOEIuqROJCW5VMBmqesm04r7wQcVV9HBixEZAKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 063/311] ipv6: prevent possible UaF in addrconf_permanent_addr()
Date: Wed,  8 Apr 2026 20:01:03 +0200
Message-ID: <20260408175941.769086164@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit fd63f185979b047fb22a0dfc6bd94d0cab6a6a70 ]

The mentioned helper try to warn the user about an exceptional
condition, but the message is delivered too late, accessing the ipv6
after its possible deletion.

Reorder the statement to avoid the possible UaF; while at it, place the
warning outside the idev->lock as it needs no protection.

Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://sashiko.dev/#/patchset/8c8bfe2e1a324e501f0e15fef404a77443fd8caf.1774365668.git.pabeni%40redhat.com
Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/ef973c3a8cb4f8f1787ed469f3e5391b9fe95aa0.1774601542.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 3dcfa4b3094a8..272dd1a0acd0e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3621,12 +3621,12 @@ static void addrconf_permanent_addr(struct net *net, struct net_device *dev)
 		if ((ifp->flags & IFA_F_PERMANENT) &&
 		    fixup_permanent_addr(net, idev, ifp) < 0) {
 			write_unlock_bh(&idev->lock);
-			in6_ifa_hold(ifp);
-			ipv6_del_addr(ifp);
-			write_lock_bh(&idev->lock);
 
 			net_info_ratelimited("%s: Failed to add prefix route for address %pI6c; dropping\n",
 					     idev->dev->name, &ifp->addr);
+			in6_ifa_hold(ifp);
+			ipv6_del_addr(ifp);
+			write_lock_bh(&idev->lock);
 		}
 	}
 
-- 
2.53.0



