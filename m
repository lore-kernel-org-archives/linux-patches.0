Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1963C9896;
	Sat, 17 Oct 2026 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259590; cv=none; b=ZOPhQ/KM93Iov2bfOqLxBYgmz5m137zeHMLK9sPwpc5WDPewNfP1WaZWFBd50f9WAg1FfwCg4ND0eHTmacrtGiVZd55ndVy8B18w0R10KHTvigAWQ/3G/a0FfSYcvji/pP6z3/b3j1evNs3qGd55yjj2m8UzmGfTO8Q47udNYK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259590; c=relaxed/simple;
	bh=cxH/I9NnJtZrov0paEp1hLZ0ZezjfOPe3LaSNZnExjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYPvbmR3hhVU8/Tde6+CpullmWq90TxJa53Y301gyySbLh+/saTLNiB84FJe9Tyzpf3qVixCKfhRjT9zDKutnt0tLOLIDvNiS6+3CG8+CJHwJT7AUn71wOwk3BWcOjXRfibm9ZboZacS/wSYY0KOdLQQJjO9w1EaPm7gG5b5etM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V25wwfn8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V25wwfn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9AB1F000C4;
	Sat, 17 Oct 2026 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259589;
	bh=ODgeBTVW9ZvXBJ2q6n/4/qfzN3YKa2ZC9VYpt5C2E/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V25wwfn8a4Cwnq4imTTMQP2OH6mPGLqI95BwKYFj8Mu1H3yN5oDGILy1wI9vI5dAQ
	 VsAbTO1V893Auw6XJdaQZ/NQ9o82kq7Es9HmyKoZnJnIn89VpAKfYh6ttf/pvZ2X8O
	 D57eTUNZVK75/JCiNpd4OpSYL3R1knrngqyQbl5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1263/1674] net/smc: stop killed, freed and out_of_sync sharing a byte
Date: Sat, 17 Oct 2026 17:58:55 +0200
Message-ID: <20261017160503.559290174@linuxfoundation.org>
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

From: Hidayath Khan <hidayath@linux.ibm.com>

[ Upstream commit db51a8658c11a82432b64999519a269c3aabb447 ]

The three connection state flags are single-bit bitfields, so they occupy
one byte of struct smc_connection and every store to one is a
read-modify-write of the other two:

    u8  killed : 1;
    u8  freed : 1;
    u8  out_of_sync : 1;

They are not written under a common lock. smc_cdc_msg_validate() sets
out_of_sync from the receive tasklet, while smc_conn_kill() sets killed
from process context under lock_sock(), and the receive path does not defer
to the backlog when the socket is owned -- smc_cdc_msg_recv() takes only
bh_lock_sock().

Give each flag its own byte so a store no longer touches its neighbours.
All readers test them as booleans and are unchanged. struct smc_connection
grows by two bytes.

Fixes: b286a0651e44 ("net/smc: handle incoming CDC validation message")
Cc: stable@vger.kernel.org
Reviewed-by: Mahanta Jambigi <mjambigi@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260820074642.966856-2-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/smc/smc.h b/net/smc/smc.h
index 366cd1a0b950e..b19f41e7e1171 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -238,9 +238,9 @@ struct smc_connection {
 						 * 0 for SMC-R, 32 for SMC-D
 						 */
 	u64			peer_token;	/* SMC-D token of peer */
-	u8			killed : 1;	/* abnormal termination */
-	u8			freed : 1;	/* normal termination */
-	u8			out_of_sync : 1; /* out of sync with peer */
+	u8			killed;		/* abnormal termination */
+	u8			freed;		/* normal termination */
+	u8			out_of_sync;	/* out of sync with peer */
 };
 
 struct smc_sock {				/* smc sock container */
-- 
2.53.0



