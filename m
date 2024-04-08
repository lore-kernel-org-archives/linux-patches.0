Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AC26FE1A;
	Mon,  8 Apr 2024 13:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581399; cv=none; b=RwY9ePs+Ev6TnJ4DQg4GYm0qHKcgarMNQlS1jEEbcnKPcHEh/1IdQrBeWH01Sc3m6UeOJGFKZvp1Q9GRwDBtmEC31j3dduXGOwzu4OC8flUswfMYIFVN6QG7/u43X/3tE5kO5iutBhoTD5anqJaMI1ctLLj0kB2Y01MXn/EnUU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581399; c=relaxed/simple;
	bh=doRiEzG7ocErcAySZhbXfoXxTXlYQXDuYfegwpzfrNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtRU4c257mRB+d7uXQrdhUD5Zimv8yNrdzA4tjvs1cJiQbnI4qfVuSmCLzvgpVDMUUZNZMAwaNVxzOX24z8weOtKeK4LyVjwiDz906A6ved+JuTQvYOrVHd+2ERC75Iaz2KMMBmoiXNzuGgRRUupsBWLWh7iMngOea+PAdVYz6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZtDzup9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZtDzup9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01507C433F1;
	Mon,  8 Apr 2024 13:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581399;
	bh=doRiEzG7ocErcAySZhbXfoXxTXlYQXDuYfegwpzfrNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZtDzup9dqeHSJgYDg7BkFyJvBleSQFEkXR6UDnKpKjDoLibyEDpYtnX0lj4/Ff/E
	 CR2+FfZZFPAhZ8JPlCHYJN5Mbix+53xlNDv7VAxfs8USmJCFOig1jmv4xH6PTpR+ko
	 6KD9+3JrfT3reRlVSVR90rTMCRn/fT2QkleWiSuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/138] tls: recv: process_rx_list shouldnt use an offset with kvec
Date: Mon,  8 Apr 2024 14:57:08 +0200
Message-ID: <20240408125256.674467195@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 7608a971fdeb4c3eefa522d1bfe8d4bc6b2481cc ]

Only MSG_PEEK needs to copy from an offset during the final
process_rx_list call, because the bytes we copied at the beginning of
tls_sw_recvmsg were left on the rx_list. In the KVEC case, we removed
data from the rx_list as we were copying it, so there's no need to use
an offset, just like in the normal case.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/e5487514f828e0347d2b92ca40002c62b58af73d.1711120964.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index bdb5153f3788a..e40f6ed65e6a2 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2238,7 +2238,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		}
 
 		/* Drain records from the rx_list & copy if required */
-		if (is_peek || is_kvec)
+		if (is_peek)
 			err = process_rx_list(ctx, msg, &control, copied + peeked,
 					      decrypted - peeked, is_peek, NULL);
 		else
-- 
2.43.0



