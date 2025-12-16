Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E6034029C;
	Tue, 16 Dec 2025 11:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884747; cv=none; b=HO5SU0Jp4rxOJQHjTSQqn9arnPfanGvAsnJ+ea5hh132gbbdhlIuAg4EDC/bdU5efp4FPbXK56mOT6qavvgLHfXyOhfdw/ohYQU9XjJ9V17093FHU+/R98oSwqHm+MsEfRejAFAANNrSRwb4SeFeO6/ImN9SePRFLxV3Uh2tdvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884747; c=relaxed/simple;
	bh=i0it6OlAFPvFjRf711Bqa1aluRwdKHcbcRQHkp8qh3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3++vkZj+mPC3odS+HaKls+nK2vN8a5Nq4rXeNjyU5X7Of8gMHIyxNMZXf6uC4QnLYp+ZE5H1e/RHFvMNeqjKVJZe6ZnvF53T2BtJTqytY4rcbd7TuSqwhXZaUh32Fx6pUK9swU4smTcCGr06EVlNL7cSOJXKTCg8zAP1nCsZfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0BeA6/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0BeA6/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EDDC4CEF1;
	Tue, 16 Dec 2025 11:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884746;
	bh=i0it6OlAFPvFjRf711Bqa1aluRwdKHcbcRQHkp8qh3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0BeA6/cTC3d4gMaGSOhA+PhixDn/h6CHySNW/RSkeplJXqk0gKKvgP04PGBZz9EN
	 NeG0RbSR4rzsoiLX4VQNchzVvWoJbRpvPGTU1WCQ92I3TWMSXJvtDwityEx9GxlYdd
	 QzRfn9EpqW6BFIkeu9zCYo+/ddt3ZLMisLC6p9uU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/354] net: hsr: remove one synchronize_rcu() from hsr_del_port()
Date: Tue, 16 Dec 2025 12:14:06 +0100
Message-ID: <20251216111331.023081309@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4475d56145f368d065b05da3a5599d5620ca9408 ]

Use kfree_rcu() instead of synchronize_rcu()+kfree().

This might allow syzbot to fuzz HSR a bit faster...

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250103101148.3594545-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 30296ac76426 ("net: dsa: xrs700x: reject unsupported HSR configurations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_main.h  | 1 +
 net/hsr/hsr_slave.c | 4 +---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index f066c9c401c60..37beb40763dba 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -163,6 +163,7 @@ struct hsr_port {
 	struct net_device	*dev;
 	struct hsr_priv		*hsr;
 	enum hsr_port_type	type;
+	struct rcu_head		rcu;
 };
 
 struct hsr_frame_info;
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index b17909ef6632f..01762525c9456 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -241,7 +241,5 @@ void hsr_del_port(struct hsr_port *port)
 		netdev_upper_dev_unlink(port->dev, master->dev);
 	}
 
-	synchronize_rcu();
-
-	kfree(port);
+	kfree_rcu(port, rcu);
 }
-- 
2.51.0



