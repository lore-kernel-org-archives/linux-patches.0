Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293B79FD;
	Thu, 11 Apr 2024 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832505; cv=none; b=bY0qezab6M+PjSyrY9ffPkPd1I++V1+yEYYYDUWcUaXKaabZyIzkH9hEwN5MTu/UL7o7DY7gnDHAtaIP6F7OgBNG+sdZTH7PEffZZm93UUoOJ0s+nII7/2SCi7hGlsAnWa4qZTDuZsy/EYQCWPk5lBaXo8pWB0n2E1jF4WS3nd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832505; c=relaxed/simple;
	bh=9b5VimqSsAUFmqlFbM/u1fPijk/Ouce6zRtIgvHsAHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzlJdVhOhsE6b5ra53JjFi+74uIxsnjqNNx+Vh1CGB9KcbqZV0Gavq405OVgFOLYHjhQTiGLkp6Vd+7SZad3JHPuBHf9OroJVbo6KFNezZEZ5PcqhyhZYINDyI7SzgbIy+dX75zZVmJWo1LNSjbNO23Kh3QL12Fz/MVYMgOJMgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxFWsdn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxFWsdn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D112C433C7;
	Thu, 11 Apr 2024 10:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832505;
	bh=9b5VimqSsAUFmqlFbM/u1fPijk/Ouce6zRtIgvHsAHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxFWsdn/l0r1i7v3bPZ1NCgxuJLV2K9OSvJ6e+J5J4e10GkJM11tdrD7r2/RY1vbc
	 13aAZMReftLk9dO6JcFZpMSG3XlCsrhfR/nXG0jB9ezqgGzKd7lkaOXsGi3WXa/G9o
	 7cveSTw9GR2YZgsah6EjgPfmyVHgb4YVFBFB2Mwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ting Chen <hexrabbit@devco.re>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 70/83] netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
Date: Thu, 11 Apr 2024 11:57:42 +0200
Message-ID: <20240411095414.792883595@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 0d459e2ffb541841714839e8228b845458ed3b27 upstream.

The commit mutex should not be released during the critical section
between nft_gc_seq_begin() and nft_gc_seq_end(), otherwise, async GC
worker could collect expired objects and get the released commit lock
within the same GC sequence.

nf_tables_module_autoload() temporarily releases the mutex to load
module dependencies, then it goes back to replay the transaction again.
Move it at the end of the abort phase after nft_gc_seq_end() is called.

Cc: stable@vger.kernel.org
Fixes: 720344340fb9 ("netfilter: nf_tables: GC transaction race with abort path")
Reported-by: Kuan-Ting Chen <hexrabbit@devco.re>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6b032a90e2b15..e7b31c2c92df2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10077,11 +10077,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		nf_tables_abort_release(trans);
 	}
 
-	if (action == NFNL_ABORT_AUTOLOAD)
-		nf_tables_module_autoload(net);
-	else
-		nf_tables_module_autoload_cleanup(net);
-
 	return err;
 }
 
@@ -10098,6 +10093,14 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
 
+	/* module autoload needs to happen after GC sequence update because it
+	 * temporarily releases and grabs mutex again.
+	 */
+	if (action == NFNL_ABORT_AUTOLOAD)
+		nf_tables_module_autoload(net);
+	else
+		nf_tables_module_autoload_cleanup(net);
+
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
-- 
2.43.0



