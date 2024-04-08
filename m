Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501B07CF1A;
	Mon,  8 Apr 2024 13:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582486; cv=none; b=aH/Hvz2bOQzicKEZSxUZQXXzvftFTK/1ijkQF7qZdLHptBgTiW1TyUx+mzkRq3aBECCzqN9y7t3xgDXA9WK1rYj7rJ5Bxu3koRJqRAI3RuqiPIUcu6flofp6OsDL/Uz+IjnNdbEiZPvapCXo/gutmUU0Bop4ZB+UwYuk/k8Po+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582486; c=relaxed/simple;
	bh=XQIHnZdSHfYiBJPCvsZ5kE+jDqiDte+Drm1TzYBThp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8fqDK0PWMBMcovjb4WHE/AbOhc8LLAeIJeFQFuBBBD6PJ7fXcymakUp4ZyoIpV/TEivbL4VPpczuFo20klkDuEI9mLjEXxWE/YYZFWNW7zZGPuEl7eI5rEUPX6TpX2XklcuA4hRgejkc16UDCNL6zeIevb46bjcqnK1QqPSAjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpZsF8Vq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpZsF8Vq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5860C433F1;
	Mon,  8 Apr 2024 13:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582486;
	bh=XQIHnZdSHfYiBJPCvsZ5kE+jDqiDte+Drm1TzYBThp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpZsF8Vqy1MbwSoeQ+RGq+4SdWM+FrrWW+7z8l9KKjlUoJSdPvmt6ZIg4VlZ3+8D+
	 jAJP0ouIL1HRkli4H0o9C0r7RTrEcUdy29irOKE0k2fgnzolVK0XrOobfQsNPbc3Dj
	 QXtQ1rVAdTmCrsWwXopLh18c1LKsVoTJKGC0lvn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ting Chen <hexrabbit@devco.re>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.8 080/273] netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
Date: Mon,  8 Apr 2024 14:55:55 +0200
Message-ID: <20240408125311.786122082@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10643,11 +10643,6 @@ static int __nf_tables_abort(struct net
 		nf_tables_abort_release(trans);
 	}
 
-	if (action == NFNL_ABORT_AUTOLOAD)
-		nf_tables_module_autoload(net);
-	else
-		nf_tables_module_autoload_cleanup(net);
-
 	return err;
 }
 
@@ -10664,6 +10659,14 @@ static int nf_tables_abort(struct net *n
 
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


