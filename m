Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625476;
	b=zC+uCvZm8owkJs/33Rw6iPqf0AvgTgt187qCZtD+fnZUJoekGGOlIshEW8SEBL+6zHGu
	 B8/pMkoiXJXSD6RAF3LHxYrh4T8xHDQ026Hr1/9uz+B1wbnqcZ0F+yhndVI9pkuia89SE
	 iwsBJvx27n0ELxGKcYHZEMqaqI/J9MhEOwsXyy0AI+I3XTg04+rsEiyWTGUO2m3NhYJFd
	 aquSQBExHkmGARK5SknrIlKoaRvyDZQbqVMlEV8zDiHa7To1zF8nJZlYsI1A/lBXbjza7
	 ZDNpXzu7sT2ewFPQtMxzy61sh1JWRlydFxA/NtjjP2XpcDjRFxqOzJncdAUhqUGtkBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=moOxJ6rDBPe6BGJhO+AQS7SON/iFpvmoJa8LffQdtvA=;
	b=dEhk/fseo6xfXkXRT7G9nz+CHendcIrHmEiNwywVbgbLptW+5hsJyCALa/0fzYsVS+Ec
	 YNp6BmHZ0E8aw/BgGcNQZU4Zs3GQ7vD35lSIzMsHLXPHsXh0lXwdfZn8v3NTC40Ga3YU1
	 UNwwEuXig8qqJh3hYIhxWHjSmZrfUI9vAo3vV+hDsF2QqqI2G6o+u7yW01lgqdQAhKmHs
	 5XqjQGhV228zFYFW3SgR09lLdrrA/e9bJDZzzdRaCEwBE2d6a09Et/1IEo05oGY2rfRUY
	 Jcf/WPIB6lqBwSq/vKKfKRbvr/4LW69ZRDvEFieZ31K6/2LN/R21WCng3mwWrEH3F5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oHkAaDLn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525BF606A31E;
	Wed, 25 Nov 2026 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oHkAaDLn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FEF1F000CA;
	Wed, 25 Nov 2026 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625475;
	bh=moOxJ6rDBPe6BGJhO+AQS7SON/iFpvmoJa8LffQdtvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHkAaDLnkT/IJsjdXBCZA4EjXKnmvy0LK4A6EvYbRxMEKOxn9FkzDSMyQ3u/FLiC/
	 eUIOqF5a+D6xeotqBByM7pFvmexiOZ52foWzhia+QdO8m5Isumb+MTtLdkXdS7s5Kg
	 V3OegrNs/lN7eQ9SurhoGqsfkX80xVYrNbrePMco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 530/816] ksmbd: fix durable reconnects for root shares
Date: Wed, 25 Nov 2026 15:34:38 +0100
Message-ID: <20261125143901.460179492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 25e36df831a47597c03c6239fbc71285e7d714c2 ]

When a share exports "/", ksmbd_validate_name_reconnect() expects
another slash after the share path. For a file at /foo, this rejects
the valid reconnect name "foo" even though the file is in the share.

Compare the requested name with the rendered file path after its
leading slash when the resolved share root is "/". Keep the
exact-root/empty-name check and reject rendered paths without an
initial slash.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Reported-by: Dairui Zhang <zhangdairui@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs_cache.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index b1ee76949a2ea..52389fff3d4a0 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1377,6 +1377,10 @@ int ksmbd_validate_name_reconnect(struct ksmbd_share_config *share,
 			/* the durable fp is the share root itself */
 			if (name[0])
 				ret = -EINVAL;
+		} else if (share_path_sz == 1 && share_path[0] == '/') {
+			if (ab_pathname[0] != '/' ||
+			    strcmp(ab_pathname + 1, name))
+				ret = -EINVAL;
 		} else if (len <= share_path_sz ||
 			   strncmp(ab_pathname, share_path, share_path_sz) ||
 			   ab_pathname[share_path_sz] != '/' ||
-- 
2.53.0



