Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FABC3B2FD8;
	Sat, 17 Oct 2026 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256411; cv=none; b=MCOtiTfpgXvxiS5uwypJFoilJcIQzsbEPD6y70q9UZVYVU7HXcUzkmClqlqYZCvaPCW0GA+4KW99/z/zzhZ/llVYhJ94Itrv55rymcrC3ghAo6NEZfDdJepI7Rz1IEaLvTOIG5rddSdL8QCH7Wrd/F/2IYOO+aEVYYdpMHfbAuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256411; c=relaxed/simple;
	bh=78quB/bCRG5/dsxWvxsXHUTNJ+eefx+3RfI41io0uyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixTfnQy+Y/WgocH+fLFzgbbEPk5lbzRBWE4oNTZTmMTvT3JQHTzRRDRLKZrG2pz+C15ylm9Tqc2Lbk/ByYnNcH9NWcyOxkaCwrVgIgZS8YThHvNL0q03WZK23HGnxjdPR8TCnXgB6NAp3+16RrO2DddVwYZ4tj1B4b/yWF2D5cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGmNa0Sl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGmNa0Sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F8A1F000C4;
	Sat, 17 Oct 2026 17:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256410;
	bh=lI4c0gGKqturqCbl7eDaPNEGVwmmpoR0nPwJvmuPv1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGmNa0SlS10W0kkTeGhasSB9Hy2ajiVhOkMvvHr/9KQHzZDgxSc4jFiuquajNgrSs
	 17ii0ZItw08W8cFeJ6p/yfyOo4AVW21ns8doxN+Bq4ioURYDvGdomaT6Deyp1gCjLH
	 rhW+snzdqYGW/N9FGzfPFN+cTK50gitqkFz3lWd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0227/1674] net: microchip: vcap: stop scanning after deleting key field
Date: Sat, 17 Oct 2026 17:41:39 +0200
Message-ID: <20261017160436.968902145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 07437c94d474f..8891e814840d4 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -3512,8 +3512,8 @@ int vcap_filter_rule_keys(struct vcap_rule *rule,
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



