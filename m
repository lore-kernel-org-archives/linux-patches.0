Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE9F2BE026;
	Thu, 25 Jun 2026 13:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392807; cv=none; b=q14NXkDVYSZr4IGQqMth+14gXccuFe+S5J9fIrl8dbyjn0HSFIvh9OIuzTy0NgIZWMjLCwGfRK1ip7Hwlqj9U5eqdJVf8Q0s8s8H/gGTz6OfyTr+DFO1kRdh1ar9k9ZKuncrledWUZK37Q71f7qqEB230ekY7rNDX5cwD1SE9p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392807; c=relaxed/simple;
	bh=atMv3rrfWEw9wssIcSaYKXLlr3+V48pVzFA2YhUw0q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TugQww4HkDfotRS51XQNhLQWjNJQqgwi0hCoceBx+rYsDlEVnhvgKj8J/KEpL05h3qkg+GkY6CwVFJjZGomekO94eTL+Bw+MpqHyo+mnud6nTEaboLdWb74MeTokghGW3CFx7fUBGcLWqYSnMX/JtBbsuoqqM+yxJIIjEzqzYBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fs2Rmyod; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fs2Rmyod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F081F000E9;
	Thu, 25 Jun 2026 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392806;
	bh=juO0ywVZJHlQMjqwqI9fx3KoZmTgAwLSNybaGlUqTGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fs2RmyodjZOvfcspQzvy6K1tl2+s9jQrrMecCVElCq1TRfcd69ZjFgRPo/WsyxhpG
	 7jrX4dS7m655DBIv3go/LHQIrJcLkOMVHK2SZLBqcf0tJYRZvIWfPAwxwTrL1m3sIS
	 vXl9w8ptm2MMWYfwA3szMOTnVCwuLa+nuQPJo44o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>
Subject: [PATCH 6.18 21/60] rose: set SOCK_DESTROY in rose_kill_by_device() for prompt cleanup
Date: Thu, 25 Jun 2026 14:03:06 +0100
Message-ID: <20260625125648.647768526@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125645.554579168@linuxfoundation.org>
References: <20260625125645.554579168@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


