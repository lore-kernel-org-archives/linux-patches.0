Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51357230BDF;
	Tue, 26 Aug 2025 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215496; cv=none; b=q0vYPYBPJ51vRjgKJRE2O1o/Hu78zQLaY8AyRtr/XXl014wYtUltCkljbi+QWLKJANYu5kGufEoGhtNV1Nq6cSc6RcbPqkxYl9Fi+gKnci8XJolDmYbnN5gzLWCtcbU4YZL7P3Jjx3uLYIk2uL3yP4ID7K97FxrVBW0KhevtRTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215496; c=relaxed/simple;
	bh=6TypEpWYeU9Y1OzFTcvSg0CLfWt6YKpSZh3qVEWUZoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKp8Sf3YhF5pFqfK5C3FOELHBfzwPCGpGaYIxz/varYfDTxNjIPokYL2T/I1pfoiCwDN5Md6THyf/mLL6l+IdZXzIM8+SI1xUlIeM+YH0tLhmSC0M/lQeA8JpJXgXx2k1o/pPimZ5IaEPSl4KTHEbYcr3Ia92UZMnXaNimE4Cik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOk7TMwX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOk7TMwX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6364C113CF;
	Tue, 26 Aug 2025 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215496;
	bh=6TypEpWYeU9Y1OzFTcvSg0CLfWt6YKpSZh3qVEWUZoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOk7TMwXL3jxrvETD7HO23vuxgLDDYPZzqM1/H6oM14CAz4+8BdvudBPlOdNgyQy6
	 QgLzfVX8S48C1rutSaFuAVMxEgkryaUUNFcSgMrsEmErApfniD8TacWmYLZ1RqYXh7
	 7RgeS15RcjSCkCvnDMMMHvvFDea5blsrnxO144Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/644] ipv6: mcast: Delay put pmc->idev in mld_del_delrec()
Date: Tue, 26 Aug 2025 13:02:25 +0200
Message-ID: <20250826110947.840490940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1d038a0840994..574a30d7f930d 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -803,8 +803,8 @@ static void mld_del_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
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



