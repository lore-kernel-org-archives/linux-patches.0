Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177742BE7CD;
	Fri,  9 Oct 2026 14:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556281; cv=none; b=P4MlfKFkkJW5uZ31TA8m30DIhG9ZlhcCoxe7oWlR8TyRxQKiCphpSM+V06kca9RjsyHWrSMWQZODfv25KKKKPKjY8L+5nnUqzUdd97F3jiunGrGX02TH9txTyWVhTx7bl0Fv3h4r/AED6xfnQpGe18wUYz0XBGLvT8s+vDycI4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556281; c=relaxed/simple;
	bh=/iw2w8R/Jqu1bx/o/9l1cx3dDCuzsjb79Q2EWnirfwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZuvE/DZ3waDNdTbVgzWXRUKIfXPKUjpZLmb32lAL5vTPtnJem/DYGAzlZWWfM8oPVyTOfxjDvgd5tRevfeh68jdcIMhDKO0od3Aja8yJ84X8XdnxQbkNUrA8VYrU3Ta1EApnsrcyYPEoT2BT6AJO2nZldnpXr0ORekY/VoXlmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN+qseb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN+qseb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5DF1F000FF;
	Fri,  9 Oct 2026 14:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556280;
	bh=aECKZDwdRBXspkP2vlbZ4g97VaFV8ylD+qFCFFNQjmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jN+qseb9pIn9tg6HVF/0wOsa5ld4SKZtBlYwNzeIOkYJhpljfy1na7Wt6MHUKfSQT
	 TRDatRy60fSA1Ac28iHQTc85bOIx5qVTkSmHd2/lp7t9/HbsTTqrgbqPi2g33qvYN9
	 5setg01oDR8qzh3yxwD2slXg36WZianK9m5dpavY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 151/428] net: microchip: vcap: stop scanning after deleting key field
Date: Fri,  9 Oct 2026 16:08:08 +0200
Message-ID: <20261009140949.485850320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ff86cde11a32c..2676bc2268c8b 100644
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



