Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7361E5B9C;
	Wed, 19 Feb 2025 08:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954736; cv=none; b=OchhxwR/CBuRRpZRafKzcFmC7fI56DxDazFydkIMy4k97yAnYQ25Tnt40buMdN0ajgbliGAY/F5vGzvoM5gsuO9nhIUj22/n2DLg3LcdwmhkeVqT0X6z0Gbyl7NrrTB/hsUJUDPcXEanMxJNHIv/xunuJ3FMeGCG+7AhwrlPkOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954736; c=relaxed/simple;
	bh=0QoOM7cW90fDRO5VhNaQMMmqgQHO1WTxUI8QmGfia9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeWOy5QSu1i0MqmUOLwZbF5O0tfwuKbLcBX3GvoWzcaISleQ+MHJmjiHTkPByd+wsukWA8EhNnmHKY50YJa4zfVrx8clv8m6k5kLCHZC7xoE4auZIFNsyJONpV7bm8XUz1J35tKkqjOiUgoaF/Hy/jfwiuqWjoGwY8BmyBeose0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Hlv6sPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Hlv6sPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08B5C4CEE6;
	Wed, 19 Feb 2025 08:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954736;
	bh=0QoOM7cW90fDRO5VhNaQMMmqgQHO1WTxUI8QmGfia9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Hlv6sPdjbr/CsgbpQ5+CAYaWmah2e02ItYh49G8yyqi7bJ6bGgPg17Ur20t0pxFP
	 FtO2EcpmRIGrMhoNTZsyWnPShFvaXvAIspZ27Jau5V1G7S8Ws8C1ecEJqO3m/c/PYb
	 CGjnkL9ql3NlZHM+c47z6ApKpoZ8C9nSZ/hnRLsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 002/230] NFSD: fix hang in nfsd4_shutdown_callback
Date: Wed, 19 Feb 2025 09:25:19 +0100
Message-ID: <20250219082601.784097464@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

commit 036ac2778f7b28885814c6fbc07e156ad1624d03 upstream.

If nfs4_client is in courtesy state then there is no point to send
the callback. This causes nfsd4_shutdown_callback to hang since
cl_cb_inflight is not 0. This hang lasts about 15 minutes until TCP
notifies NFSD that the connection was dropped.

This patch modifies nfsd4_run_cb_work to skip the RPC call if
nfs4_client is in courtesy state.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Fixes: 66af25799940 ("NFSD: add courteous server support for thread with only delegation")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4callback.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4callback.c
+++ b/fs/nfsd/nfs4callback.c
@@ -1486,8 +1486,11 @@ nfsd4_run_cb_work(struct work_struct *wo
 		nfsd4_process_cb_update(cb);
 
 	clnt = clp->cl_cb_client;
-	if (!clnt) {
-		/* Callback channel broken, or client killed; give up: */
+	if (!clnt || clp->cl_state == NFSD4_COURTESY) {
+		/*
+		 * Callback channel broken, client killed or
+		 * nfs4_client in courtesy state; give up.
+		 */
 		nfsd41_destroy_cb(cb);
 		return;
 	}


