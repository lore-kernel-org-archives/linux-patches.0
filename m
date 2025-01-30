Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2ABD1BDA95;
	Thu, 30 Jan 2025 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246890; cv=none; b=g03zHX9WXSC+cgoOVHlT+oo/ylUIxv00NxHKM8Ct2B7UH2u2MX+G7PrwPGGW2SD6MdniYJ2xaWl4rtNqaAiqd8yV8yMtZ/KO+WTdXCw72B69gT+0DhAqSRcBxFifwUafGb9/MS1YnC0Mx6EE1cjwoNNTOhur/Gp1Cl1BaJFMFOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246890; c=relaxed/simple;
	bh=PAJEvlkhyqf14kQzcotN5G3cPInux/nmXK4FiR94kUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sV+4BLTGCGWrj7MzpUy3eW3dKejqcwYqzav5OBEsF2XJDSDBarnwHQbU+mf/EQTd9jXCUXZNs6nulMPNw+WnhKTBZjLW5EMV9L0dlyTfs6yx7c26/QtbhBCJG5ZsIFuuE+bHpHxFo2ulr4BnK0G6tBA9t2NSapGC+09bydaZhh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrX56c3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrX56c3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B35C4CED2;
	Thu, 30 Jan 2025 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246890;
	bh=PAJEvlkhyqf14kQzcotN5G3cPInux/nmXK4FiR94kUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrX56c3fmFAbvyBpuF6l4/lxiaal4N8nYM8TF1yh8XO1z4J49ijPv61S1mMf/OtcN
	 nrEe+xCvfz373kZIyVp2X27ppeJlJ4OtsaC5Div5qFWQLK3zssif2C1WA0Svn+Wqk9
	 yFV7NjlAdR2rIJEeu3bYfBmaUBOhg6un7vfRwnw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/133] tcp/dccp: complete lockless accesses to sk->sk_max_ack_backlog
Date: Thu, 30 Jan 2025 15:00:00 +0100
Message-ID: <20250130140142.955704552@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 9a79c65f00e2b036e17af3a3a607d7d732b7affb ]

Since commit 099ecf59f05b ("net: annotate lockless accesses to
sk->sk_max_ack_backlog") decided to handle the sk_max_ack_backlog
locklessly, there is one more function mostly called in TCP/DCCP
cases. So this patch completes it:)

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240331090521.71965-1-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3479c7549fb1 ("tcp/dccp: allow a connection when sk_max_ack_backlog is zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index f5967805c33f..2a4bf2553476 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -282,7 +282,7 @@ static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
-	return inet_csk_reqsk_queue_len(sk) >= sk->sk_max_ack_backlog;
+	return inet_csk_reqsk_queue_len(sk) >= READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
-- 
2.39.5



