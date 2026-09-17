Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E572F768EA;
	Thu, 17 Sep 2026 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670439; cv=none; b=J/dUqgczxXujQXSzKSOiBEFIQXRmbBQgttotzy92fUeND2ypEm+y2Ybt/T1uyGlmOwWhMMXN7NlAbK5YBU/WVejqOpgFxw9zrsvZAlmWPmP4dVuTgrekAeLhVp5QBEwL2T9luJeqE3NitEk2yzxz8woxH6laJGQB578oOfVw1Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670439; c=relaxed/simple;
	bh=+6PAnsLzzWWv/qP571r+g8dU2C1y5miGC6DCKOQqTW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fh6wxbcDrClBsRj3yh3hoeOwDDDwgPDzC4ZjwUEucEsKtzwHexBjkfGD/DbEqDG/cnQ9kXwjfytYleZL4IAUB25tZV+TfubwNyWV5FGsODzwGa0Xn63r59qLItAGD353quz7CN0HJ13uF/4UFm0v1hG/RYXLBA315VyXb9TcEyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o90LMBmO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o90LMBmO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423CA1F000FF;
	Thu, 17 Sep 2026 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670437;
	bh=dhVSPC+XGftyGsPPhgZ4oWgkbLw3jQZrSLcpwVuJgk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o90LMBmOVy4H/7WO8GtqmUIcC621RPFfH+qRDRpZsjJ8bjwS2Da15+lW0Ei3pO4Bw
	 FjLcqji6qT5U2g/UwHdYN0q27AwgSWM6e+yP4NEXYZG2pwbEk3ewxWTd1V/HibwUCI
	 slkKymU+F2VJaWjSTbaitlig/h7fmE7bUxufubRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0661/1102] nexthop: Initialize extack in remove_nh_grp_entry()
Date: Thu, 17 Sep 2026 16:10:04 +0100
Message-ID: <20260917151556.786678354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5bd9e4e7cdaa03879e9b73b12ab52cceb1edd55b ]

remove_nh_grp_entry() prints the extack message when a listener fails
to replace the reduced nexthop group. However, extack is not
initialized and listeners are not required to set a message when
returning an error. Neither netdevsim nor mlxsw do so when an
allocation fails, resulting in the dereference of an uninitialized
stack pointer.

Fix by zero-initializing extack, as was done in commit 6347c5314cee
("nexthop: initialize extack in nh_res_bucket_migrate()").

Fixes: 833a1065eeb1 ("nexthop: Emit a notification when a nexthop group is reduced")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260903080259.10378-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index ef323775f09ac..fbb22a63b8807 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2012,7 +2012,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 {
 	struct nh_grp_entry *nhges, *new_nhges;
 	struct nexthop *nhp = nhge->nh_parent;
-	struct netlink_ext_ack extack;
+	struct netlink_ext_ack extack = {};
 	struct nexthop *nh = nhge->nh;
 	struct nh_group *nhg, *newg;
 	int i, j, err;
-- 
2.53.0



