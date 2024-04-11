Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724E21E48E;
	Thu, 11 Apr 2024 10:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832685; cv=none; b=F7R315aAxQuNE/IlYAYrlPUiCbkIs6J96WOX+L6W+6HQfPTpRAgUm/E3AkxhXhS7YaEXPs4aokDLrS2xUWfJ4RvxrblLL0xGHXffHiONJQSHD4wuX4vvfJAhOZEzXq+P1xRjcWUuFkVXkclxZwBarcnTib0OSOT+v6zpDnrRgEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832685; c=relaxed/simple;
	bh=4NOqxpK14wEcv4bwMX7tGQT0u89DRjP5vstXk2+os8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6jyATvmVw+SViXNdhMS2VJ95pqzFqGipFrXL8Bs9k8fHQpvZQMEznE3tg1Lcl7H6H6iTBXkSkK2d0gBXmKoBc0wpPo5C1aI7SMHEIMzP05KkGBfsQDbAZGTfuN9Sw8GVdape1R4ajDwjQp87a/WYzGd/myvIqo11aUUw3EI0rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCI/doGH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCI/doGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED28C433F1;
	Thu, 11 Apr 2024 10:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832685;
	bh=4NOqxpK14wEcv4bwMX7tGQT0u89DRjP5vstXk2+os8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCI/doGHmmQ91sVyRBUJ3O1ON4qG03kE3x4gzA7XZ+H/cF3wPspJCxzAeQIkkoiVF
	 W1FJ70MR1k7fnlphQ7zlrogcDPY4P6YU6zxBQCLd3bAp0aQDHhvNCFCFi4WjxF/B23
	 HWCv9BhVHYu8R3ez9336aVZoua+cutqzHIFxX4J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ting Chen <hexrabbit@devco.re>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/57] netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
Date: Thu, 11 Apr 2024 11:57:55 +0200
Message-ID: <20240411095409.412995852@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9801bac049e28..ca061fc0b1def 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9880,11 +9880,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		nf_tables_abort_release(trans);
 	}
 
-	if (action == NFNL_ABORT_AUTOLOAD)
-		nf_tables_module_autoload(net);
-	else
-		nf_tables_module_autoload_cleanup(net);
-
 	return err;
 }
 
@@ -9901,6 +9896,14 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 
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



