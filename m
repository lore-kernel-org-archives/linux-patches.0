Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EC32ECE91;
	Thu, 25 Jun 2026 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393040; cv=none; b=iThTxyAtqdv9JxEKFJYFggsK9Qurom+E7anT8/kEIsxaa4b/rriMmMQSCs8s7ODEieIjSmh0dm5+Eu+Vnea787HB53SSrrPfdvupVii63KQJHvEBzKlXwGKYr0YvxVCL8jD3nRu+NkwYhvNr4HuPA6/5EcYjjEgJxqGFUX+89k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393040; c=relaxed/simple;
	bh=BR7p9rBV4eolQ1Yot+VMwLdcCfWtq7f64hUrG77BqbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUgufVEqvnQuTwz/RC/xXrv8Dhcw7fHLTW67/i4XaaSAQzBM5q8PkDTNVUQVOn1vnytkDtNwy9HK39jbIC9KhwC3l2dksOyjTp1s9NBuLUgTJVIxHUdyj1RrK0WMxCvhY/u6jgnHPmRsIz4jOq5SM1icGObR6diVOFJ4BK6SxnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xffYpM3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xffYpM3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4248A1F00A3A;
	Thu, 25 Jun 2026 13:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393037;
	bh=HSw5vc8wNatetnOlzY+FEk8lmaQddXbspZW8dFvsuR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xffYpM3wjt/t/ucTmT6ZcyT7A6zcYuzbhvcxKLQGzGL1MsAzUiyFHCexr48FTTWkJ
	 WSnuR2zNolqT3INwyRDrafKSlIus/MIpyz4qjb11asc1dlD61bEPH5TOx6DyJe127m
	 WbHeRb1AtILkUNyEfBx7y2WszXpsxlqlJxoU1iOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 7.0 23/49] rose: set SOCK_DESTROY in rose_kill_by_device() for prompt cleanup
Date: Thu, 25 Jun 2026 14:03:35 +0100
Message-ID: <20260625125640.747640857@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

commit 741a4863ad570889c75f7a8e404567d8f3e46335 upstream.

When rose_kill_by_device() is called (via NETDEV_DOWN on module exit
or interface removal), it calls rose_disconnect() which transitions
sockets to ROSE_STATE_0 and sets SOCK_DEAD.  However,
rose_heartbeat_expiry() only calls rose_destroy_socket() at
ROSE_STATE_0 if SOCK_DESTROY is set -- the SOCK_DEAD path is reserved
for TCP_LISTEN sockets.  Without SOCK_DESTROY, orphaned sockets in
ROSE_STATE_2 (clearing) loop indefinitely in the heartbeat without
ever being freed, keeping the module use-count elevated and blocking
modprobe -r rose until the T1 timer (up to 200 s) expires.

Set SOCK_DESTROY immediately after rose_disconnect() so the heartbeat
destroys the socket at its next tick (within 5 s), allowing clean
module unload.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rose/af_rose.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -211,6 +211,11 @@ start:
 		spin_lock_bh(&rose_list_lock);
 		if (rose->device == dev) {
 			rose_disconnect(sk, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
+			/* Mark for destruction so rose_heartbeat_expiry()
+			 * cleans up the socket at its next tick rather than
+			 * looping forever in ROSE_STATE_0 with no owner.
+			 */
+			sock_set_flag(sk, SOCK_DESTROY);
 			if (rose->neighbour)
 				rose_neigh_put(rose->neighbour);
 			netdev_put(rose->device, &rose->dev_tracker);


