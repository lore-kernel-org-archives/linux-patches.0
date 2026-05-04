Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA272E2F0E;
	Mon,  4 May 2026 13:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903020; cv=none; b=MR3tvpFqnZpnMmj1oN2DYM8ZBKH7e/Wy4M4z/XX5lGYhFmrZB23JrkNSlvl6VPvpzdq/fmuv6GP2G3sbyvf+Pgz5c1BYy4OG5JQUTer2xlrTK+YRFFzLSbjjwGRuATJfcAzBOAF54p8XQOOWYO9JB9GDbeb+NLKZQLiyjmiUNH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903020; c=relaxed/simple;
	bh=r6jIIaxlKwHUF+uewf0uKdTOUqobRxZsmh1IUAdLmmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGuw4hByqsyfGrtBDORL3V+/PTJSCVdc3j0Nq0YRJK6NJGlrm6oMP5b5y4HOCsLFCopkDfNq0g8nMierLArFtaNH4yrjfm9X9NJw3xGjTvgrWF4qvbRxIi6KW+fQkojaKTqtc2upa6edp90PWogY4c/NsOWMvlvBqq5mODYb1zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D11cudOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D11cudOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E9FC2BCB8;
	Mon,  4 May 2026 13:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903020;
	bh=r6jIIaxlKwHUF+uewf0uKdTOUqobRxZsmh1IUAdLmmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D11cudOQq/VpHOufl8l4dT4vsUD5NJNXvfBCWlNwujwX0+Pomz/mAbvQieC6AtCWy
	 +dkZNoiYXykRjIFD16/8hd7kv5MYIojBNzSJi5o3Z+O06EH6J59P6SkN9b+W9h1CH0
	 vwC0yS1XAOivLR861N1ze/H/cimbkm7n1po4c6Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiao <252270051@hdu.edu.cn>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 7.0 073/307] ipmi:ssif: Clean up kthread on errors
Date: Mon,  4 May 2026 15:49:18 +0200
Message-ID: <20260504135145.562837603@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <corey@minyard.net>

commit 75c486cb1bcaa1a3ec3a6438498176a3a4998ae4 upstream.

If an error occurs after the ssif kthread is created, but before the
main IPMI code starts the ssif interface, the ssif kthread will not
be stopped.

So make sure the kthread is stopped on an error condition if it is
running.

Fixes: 259307074bfc ("ipmi: Add SMBus interface driver (SSIF)")
Reported-by: Li Xiao <<252270051@hdu.edu.cn>
Cc: stable@vger.kernel.org
Reviewed-by: Li Xiao <252270051@hdu.edu.cn>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ssif.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -1268,8 +1268,10 @@ static void shutdown_ssif(void *send_inf
 	ssif_info->stopping = true;
 	timer_delete_sync(&ssif_info->watch_timer);
 	timer_delete_sync(&ssif_info->retry_timer);
-	if (ssif_info->thread)
+	if (ssif_info->thread) {
 		kthread_stop(ssif_info->thread);
+		ssif_info->thread = NULL;
+	}
 }
 
 static void ssif_remove(struct i2c_client *client)
@@ -1916,6 +1918,15 @@ static int ssif_probe(struct i2c_client
 
  out:
 	if (rv) {
+		/*
+		 * If ipmi_register_smi() starts the interface, it will
+		 * call shutdown and that will free the thread and set
+		 * it to NULL.  Otherwise it must be freed here.
+		 */
+		if (ssif_info->thread) {
+			kthread_stop(ssif_info->thread);
+			ssif_info->thread = NULL;
+		}
 		if (addr_info)
 			addr_info->client = NULL;
 


