Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5CE521203;
	Wed, 30 Sep 2026 17:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789906; cv=none; b=HP50Uc5JcMphKKHuPY7ysFqDIidDE7nC3ychK/s4AWsJGGU9/0pLvj2lWO0khji50bwtLIdcVqqhEMhStnsHdneqoxhouiJh1ZfiVA7OHd7G/NEN6tnj4C3uM/HRxCUUpsH8O9U2zV07p7ccjNPCi640/ypOguzOnh4grOkk0G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789906; c=relaxed/simple;
	bh=h6aXAmCvTHFLBQMB1kiX8BBNOHvBskPcxsBzbIJREiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L7kuVUK42Hx7/UufXh3JcNiBN+1aJzAyHLLsZNjK12fP6CPdMAUru33qKwgsV3msStt8oi3swCPrLtt8yQTkVaXoPOw66DDItB3BDEDQbs/bPa0ntagGhU939UkMiBipWUp8n/PLHcWtEWuWs4b+UiceVF01c6zzrgtKUVmaN/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niS3WbRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niS3WbRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7341F000FF;
	Wed, 30 Sep 2026 17:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789905;
	bh=9I/sqbXjSP6WTqWjd5In/xm+sMuJmRcOu0nosdcDP2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niS3WbRlBJbQ1xEGBgfVh6ANKgHwspSoGRexQLGlwt7Y0uAjkExR7umrIVE5iTQnt
	 KwmHCjCOudazcKVovWIsSYrKLTqJUhl0aZ76qYcQKkZ85PUAngvurt2ngTUzSZKPND
	 4I2PERHd4rcaHtQhNGXNHG4Nk9C9YyapirUAiO/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 598/877] net/smc: stop killed, freed and out_of_sync sharing a byte
Date: Wed, 30 Sep 2026 17:25:09 +0200
Message-ID: <20260930152427.558059437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/smc.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -277,9 +277,9 @@ struct smc_connection {
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


