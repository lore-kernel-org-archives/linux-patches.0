Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4789636B927;
	Tue, 13 Oct 2026 12:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894921; cv=none; b=kA29n4UV/nTr1sMX9vfJts8rz6z7NIMmqFa2e3p7XTXWi9AuNDBF+FxZFP6/XBrDk6216ZcqGAGS5Us0dzWWWOKHoWRf79D3O/PphC5J+wjZqVkshMYKvTrMMUSBt+JzPJ5l6G9264w/0AyO+hUYtd9yK4usyxP70xNuD1bkU1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894921; c=relaxed/simple;
	bh=v8cfmWbTc/NKwefA9ecRz/vNLOvq/YRZiFNs3kdUNVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyRkLFkj7Kez8XejtWO1suG3mMk+kK1i3upwLcHpZVUTotA0JDsNXaUbBxCgKZV93QbeoNIS3Prp49AW6nB8lgwTq3pXIhAHBwQwwxPUYmh5yOwwJYwz5FBlB+RnKXVaNuQ64p5xrYoempZxu1J531lPfism7wNMdVj31fiapMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJkJmKm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJkJmKm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2091F000FF;
	Tue, 13 Oct 2026 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894920;
	bh=2KCBpY0mGHJipv1dKH21irK78cb1bEc6rsjvpDVihqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJkJmKm7iClVCt/Ur25KrH9m+iE+XtA7uxHVkZQWm96vrXLGV574n8W0dq7IqdJHw
	 VJw0sBTD1TX/xeSWXo2700UUnjyrhHwinezHoQ2elhax7VpYusNZueGvXEFWDjmz4V
	 GTAMwKC9l3wmr5iQkCAbWrw73NzLLv1KMAv4sPcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/497] net: microchip: vcap: stop scanning after deleting key field
Date: Tue, 13 Oct 2026 13:34:29 +0200
Message-ID: <20261013112910.312342328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



