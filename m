Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E1145D913;
	Fri,  9 Oct 2026 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555832; cv=none; b=G3EdMMvMeQBjMl0WaihOeRE1peWV2NTEyp/WCgfgY98uGRm/q3pSUE2tnHQra3BxIcaO0IOqxm+MbL+EDfhVMqM87jLv5ZE/M3lxAKIlmnA6qD2myVZup52KlFqstBmGqh2NSf1mv/Tad6UkEJiSaqc7tEEExPkfho7HckBhKEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555832; c=relaxed/simple;
	bh=qz4ncVumLZRepaYHNjUnNTgLkzFn76LbRQOCLM6j85o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3E9bwvKOXLcznNvNSvRtYfTAqwmU9wAEl+BlQkaa+HqlW4Nwlf1NateSC05uxzu8P9i4bdEslVLJXPXJCEp/BDVUgfA7zEOmRi3jS3/WQha6GIlGW1J1PdpsGk4/mfEwOAicmWU9PrPMXQB5/f8FyL3CIqyFqsMTcf10mkNKC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pC8E5GNn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pC8E5GNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744831F00893;
	Fri,  9 Oct 2026 14:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555831;
	bh=cvHTpDsqBBZ5fS11+m09siZ+dexV5daFIKPGKkIK108=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pC8E5GNnbxUG7giW2WMc8QXtgh+OUjp7fWBLe8c2T4/iQcXPaJBNFadV9uOY1aNla
	 4OtyMCDGu7NNddmGms0nH777P4F+GFfQPj4HdLyF52uPGvak191B2vEUmBfjirFLhq
	 6yhJEN8D/wfdcmh8sCsNuF28gkM5BerGiSlFS4fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/403] net: microchip: vcap: stop scanning after deleting key field
Date: Fri,  9 Oct 2026 16:08:06 +0200
Message-ID: <20261009140955.001084568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 99b43ede9e355ba35244cc9470bf1819774ce39d ]

The only call outside the KUnit tests is in
sparx5_tc_add_rule_copy(), which passes a fixed key list with no
duplicate entries. Therefore, the potential double-free is not
currently reachable in tree.

However, vcap_filter_rule_keys() is exported and does not require its
key list entries to be unique. If a future or external caller supplies
the same key at another position that the inner loop visits, it calls
list_del() and kfree() a second time on the freed field, leading to a
potential double-free.

Break the inner loop after removing a matching field. The outer safe
list traversal continues to process the remaining rule fields.

Fixes: 465a38a269e9 ("net: microchip: sparx5: Support for copying and modifying rules in the API")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/ahs-lCAXXikkaHky@stanley.mountain/
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 49eef025d2900..4c55ff842ed7b 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -3524,8 +3524,8 @@ int vcap_filter_rule_keys(struct vcap_rule *rule,
 				if (key == keylist[idx]) {
 					list_del(&ckf->ctrl.list);
 					kfree(ckf);
-					idx++;
 					err = 0;
+					break;
 				}
 		}
 	}
-- 
2.53.0



