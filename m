Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3151C372231;
	Sat, 28 Feb 2026 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301483; cv=none; b=Z5YzgUFKdaNumd2KQQLrK5elZJ6ZMbufPB/+DZ8i8eZTtfqtgDWdwIDHDoYjYst/665hxu2H00YUCtm96WoUb3JKfA67kRfSUljB4ldOLXgYcl/gQTNkfeF9xaX4OQQfjXn4QAHxrBf/Tdm1X01TkKUuqf9wwg5/0iD5V5LquhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301483; c=relaxed/simple;
	bh=SUf0qdZ6P+PWNQj5j9osWjREKs8+YSw/TMis7sPESjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgN5Mjzr5m3BdwcPPYaxxFf7Keo0kMoDZioVieUIvM1afvd0O8QzLxEtrhRAxZfmYpWttQaa8HdUG67xY5clNzW3nO2pNF5mRVnEPRMUtqFVywkvsJLy+Ac6A2031Ne4g4FPsVNwY3eH0jGzT5ck9Et5r9mNrc+UruFfojKsAqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tQI5BFVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tQI5BFVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A712C19423;
	Sat, 28 Feb 2026 17:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301483;
	bh=SUf0qdZ6P+PWNQj5j9osWjREKs8+YSw/TMis7sPESjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQI5BFVRSu4pzY3PCdCs5t5NJxFPEUJjGlviY5wAG/UqEbvfxRuf3br0cUfUCQ5y1
	 w2KE15h+pi01N6GERBs4pgI2/8AVljTG7luBccIub+JGytnKYUmeMGsi+TbIJgye+4
	 fjFGd8CF/N+uM39RznRupiLrEjeU5vjw40fJqCl5jaSZDff0zBh9sp2THcuwOdit0R
	 uEYZfXq9dQIFxyl2FfDIucskn4nYJ1tsaOu+ousxdT83iQe1+ORKO8BSLD7d6ZsV+w
	 Oa3VaWlBiRVcVhYHf6o90EErksBpPNFjpJHdIp4IMvhOimbQ2+7HVF+IUVbR+yLy0N
	 bQPVvNe1bgPjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Daniel Hodges <hodgesd@meta.com>,
	stable@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 668/752] tipc: fix RCU dereference race in tipc_aead_users_dec()
Date: Sat, 28 Feb 2026 12:46:19 -0500
Message-ID: <20260228174750.1542406-668-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel Hodges <hodgesd@meta.com>

[ Upstream commit 6a65c0cb0ff20b3cbc5f1c87b37dd22cdde14a1c ]

tipc_aead_users_dec() calls rcu_dereference(aead) twice: once to store
in 'tmp' for the NULL check, and again inside the atomic_add_unless()
call.

Use the already-dereferenced 'tmp' pointer consistently, matching the
correct pattern used in tipc_aead_users_inc() and tipc_aead_users_set().

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Daniel Hodges <hodgesd@meta.com>
Link: https://patch.msgid.link/20260203145621.17399-1-git@danielhodges.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 970db62bd029b..a3f9ca28c3d53 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -460,7 +460,7 @@ static void tipc_aead_users_dec(struct tipc_aead __rcu *aead, int lim)
 	rcu_read_lock();
 	tmp = rcu_dereference(aead);
 	if (tmp)
-		atomic_add_unless(&rcu_dereference(aead)->users, -1, lim);
+		atomic_add_unless(&tmp->users, -1, lim);
 	rcu_read_unlock();
 }
 
-- 
2.51.0

