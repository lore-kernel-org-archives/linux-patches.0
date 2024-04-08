Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184EC7D07E;
	Mon,  8 Apr 2024 13:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582314; cv=none; b=ejSSkraqf95s9EesYDpB9TPxMl0/HZna8Fj+FCrYIkGlLO6fxXSN5MiJ0aE8q2ygIuwaX6CvUDx0HpyRS1vnQfh77OqtNky4dvpJ4lp/hGDDO+2uwUl6ReSIdUO8UNlqT9gQlMrl+1CkcHUy0/E9OQEvkTdarjfc4fd96KuyzJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582314; c=relaxed/simple;
	bh=qQDZyz6jshTP1QXK56FgQFLsZVCg12xLuUz4jiRKRCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UacvXXmzTPabHl2YYMtZvmy8iB/BW2WkfeCcb9dE7321oQHDGz23W38wMiF1+s2ZadQalPoCT/kkwYjRwRq5JTDC3olTiH7FAU3pz074EMYJAolG7y3HbGma373rgc8F57JXKWaj78Q8GOoM22svI9UwDiqtHQwxKyWMBEUP5uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=utsdRSL6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="utsdRSL6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B2DC433F1;
	Mon,  8 Apr 2024 13:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582314;
	bh=qQDZyz6jshTP1QXK56FgQFLsZVCg12xLuUz4jiRKRCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=utsdRSL64u07yyJTlXxTxGNXR8ybvHL2UXB3dgPXlMkcQ2YZHA0f2WRPt3lVchKGu
	 Dx4cqw3KCjDGtBhcA+BnopBRY3Yc1WKtlQFam8TQf9sWvn0uIu4pmf23+8iRZeQTmP
	 C06LSVeNIb0BjMYcqyy5WQZjZv1sGiJFDPkTVyrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ting Chen <hexrabbit@devco.re>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 083/252] netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
Date: Mon,  8 Apr 2024 14:56:22 +0200
Message-ID: <20240408125309.214140983@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10518,11 +10518,6 @@ static int __nf_tables_abort(struct net
 		nf_tables_abort_release(trans);
 	}
 
-	if (action == NFNL_ABORT_AUTOLOAD)
-		nf_tables_module_autoload(net);
-	else
-		nf_tables_module_autoload_cleanup(net);
-
 	return err;
 }
 
@@ -10539,6 +10534,14 @@ static int nf_tables_abort(struct net *n
 
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


