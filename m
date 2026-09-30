Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C188C52E04E;
	Wed, 30 Sep 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790532; cv=none; b=GT1xkmNqfNO8R52lt47e08p2AN6sMcxtDAKFhYMGKkOtKF4hHTHP/kvwkYwfJfSWUu/MSQNdkJnscAkEDVhv0FFDNAWpoy68FJvKiPm2Fyim/yTyLmWhyj0/C00kGZMbZpWzPkPjpSQ7ov9R4x5zPOKHZRCmxKV1g3uHDfeYjec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790532; c=relaxed/simple;
	bh=zgtHyz4oAapmkJm8x5VzKlm8XrirGdBGcuKg/mZja4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nseml4Ep0Xa7RQHrbZBV10eo0T8cacBedtoR1Iae8TssWd9EouBU/S+ZQTS1FdqgvCIrpQQPLpzhSThpA9+GX1A1nw60TZMg2QdfFx5OBaEzUGTbv+/ZHbc4Ul3MpA6pPFeXxo9j04peyiBWhgwPpBIQd17cLS9/O4wfie18Ogk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGzxCWU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGzxCWU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258FB1F00898;
	Wed, 30 Sep 2026 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790531;
	bh=5RaTN8MRnywVnEW/fCJx/hGiB33D1K9fFd4t1uMe6+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGzxCWU1tf4hTX5WjQV+2nuKDfeJRP11tAb63++/mFjk7S82JeJKihcIdAksUqFO3
	 bk8kqljzI0t2VucFu6MHrzAmkRVUuJalLQqsABaRq95L5BgV7dUUSXjaVHAgxLPsmB
	 BDhQwAnaYCDhI/c1qwgWbmnQa/Q2VQwuHEpsS+hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.12 861/877] rose: set SOCK_DESTROY in rose_kill_by_device() for prompt cleanup
Date: Wed, 30 Sep 2026 17:29:32 +0200
Message-ID: <20260930152433.318433898@linuxfoundation.org>
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


