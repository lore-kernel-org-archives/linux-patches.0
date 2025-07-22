Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5471C2ECEB5;
	Tue, 22 Jul 2025 14:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193715; cv=none; b=EyBtnI4oAT3xQdmfoAVSz/YlLX+rMsMAoLHg01nQCBIVkr2CfxpVuJVpk9kAl4kGhlU1insmG01xVWIxtVy6ouPt6PgkRXnPKbkkMst+EaC/x+2BFm8vluotRQd2Fd20lAVNh5ikwnFA1YptGACXRE8GTeVQ7mHJSmaM42wlJlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193715; c=relaxed/simple;
	bh=JzIpNJ+rH+1gw3qGcQcLXeEPuytM5kHMFFCj6AqlWa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiQDwfvh+XOfil/9AsAFqBZjo0hS7gnEveu4pr2I8Z6iC3SHA2oEZwwMMIP6mwjXgD20t8Bi68ts3J0sIYce796njun5KKLb4GoZAP3hjvFlEyztZsSAG/cucEm/XeLaTBc1iGdiqbpHPjq6vGAou6PjQeM7qSbOKnq2NiqN6R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDqXMNM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDqXMNM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD380C4CEF1;
	Tue, 22 Jul 2025 14:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193715;
	bh=JzIpNJ+rH+1gw3qGcQcLXeEPuytM5kHMFFCj6AqlWa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDqXMNM3yWRJy8PoPfGvW3ube8r4+EjsBmT4tnXliUP6AE+c4JeG5noP3ynzharVQ
	 qxzG4ady7SRyzKsJ4Am9CpKsW2QVsIKTlvcPfZwZpcFVF3rBVvmmA2cq+haGg210mA
	 gEExEFhbhC5bnD+dwH8f2ULA7/bXEoyOCidd95Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 143/187] ipv6: mcast: Delay put pmc->idev in mld_del_delrec()
Date: Tue, 22 Jul 2025 15:45:13 +0200
Message-ID: <20250722134351.116303543@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit ae3264a25a4635531264728859dbe9c659fad554 ]

pmc->idev is still used in ip6_mc_clear_src(), so as mld_clear_delrec()
does, the reference should be put after ip6_mc_clear_src() return.

Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface mld data")
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250714141957.3301871-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 65831b4fee1fd..616bf4c0c8fd9 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -807,8 +807,8 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
 		} else {
 			im->mca_crcount = idev->mc_qrv;
 		}
-		in6_dev_put(pmc->idev);
 		ip6_mc_clear_src(pmc);
+		in6_dev_put(pmc->idev);
 		kfree_rcu(pmc, rcu);
 	}
 }
-- 
2.39.5



