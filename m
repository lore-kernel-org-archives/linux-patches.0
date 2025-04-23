Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFE627FD75;
	Wed, 23 Apr 2025 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419866; cv=none; b=CzikC/aE83Dsvzs0Y7PJZWGZVa0gAz7hl2RvdS4vyJ1U91LJmBq7dt6Gal3gGVkfr/1zKtSyjmMbeHwQrYOlAuVNu8rqzjJnR5IWAeKUzf6IFGw5Jc7xxSHdKbIDyRz2U4YzAgWbQehcPUEEdRCH/o/IOPuQaTGkK3B1YkEnRtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419866; c=relaxed/simple;
	bh=+0khSuXXg0D1xtqLb15f7QJXD+L/j6xSgZTtqByCJaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDiJvdcjJ3Fgiff1Cp+wBobdffgBREqSlmsOjd+7SkIEmf140RqXeAJ6quPSuT2krXvPR9UMlzqEgBMRYhcqI/PYiNWFERmqABDV0YCxWPtHK6YRl+NpZzvDN31Y9FIwvoTOPB1zAajW0oLOON1nvwEoM++5rQPwBW6VJTWgG/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp5CNmUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp5CNmUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C97C4CEE2;
	Wed, 23 Apr 2025 14:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419866;
	bh=+0khSuXXg0D1xtqLb15f7QJXD+L/j6xSgZTtqByCJaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mp5CNmUPtE1ignGNUC/NGgsT7qV+fmkYHiR79eovzBlxfia429Iy4mODw8NeB+rLN
	 /ZcV0jbxWfAeGqHkSTsCuPzcDGi2ac8EWqzngT9n+qro+09xVy/c1txYSzziQm39rT
	 sAxih3u0DJEKnDj2fZhbMWRFltO7kpg6vs9Ds19I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/223] net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails
Date: Wed, 23 Apr 2025 16:42:19 +0200
Message-ID: <20250423142619.860933614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 514eff7b0aa1c5eb645ddbb8676ef3e2d88a8b99 ]

This is very similar to the problem and solution from commit
232deb3f9567 ("net: dsa: avoid refcount warnings when
->port_{fdb,mdb}_del returns error"), except for the
dsa_port_do_tag_8021q_vlan_del() operation.

Fixes: c64b9c05045a ("net: dsa: tag_8021q: add proper cross-chip notifier support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414213020.2959021-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 3ee53e28ec2e9..53e03fd8071b4 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -197,7 +197,7 @@ static int dsa_port_do_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
 
 	err = ds->ops->tag_8021q_vlan_del(ds, port, vid);
 	if (err) {
-		refcount_inc(&v->refcount);
+		refcount_set(&v->refcount, 1);
 		return err;
 	}
 
-- 
2.39.5



