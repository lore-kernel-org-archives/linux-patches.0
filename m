Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899B1326D44;
	Tue, 21 Jul 2026 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655534; cv=none; b=iTwOzJ4vQA9LGIhyNSbrt6TEvWhPnWjAsJ+afQbG5RQbjC3XY+gvO2URzC3pwRL6J6EDLGXxu2OGFT1nitlNmIcO0gnV78EtnyDg/Tt3sps5MHCcN89nppk3sgc9jU5oJjcf1OLb00Tgnuf2HesvX2WvfNVz9cs9JUFEGelLd2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655534; c=relaxed/simple;
	bh=KBp6MJH9r2R1Ta+asF+6IWe3h0ecmw7oLITXCXcQi6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I19GCjYaJx14htKqONegPHcfVFbTkldH2Zfrgb507OAM+uoCJ2k1Oe7UKMgnIXqMky7xdzPhayCwYO5LvtphtnfH0xD2JlHf5ApOSDdK0f8lTbJsZgsOFEGGw3ar0fzLlYaU7zVkpkOYLC6bT9RoB0SSO60cwEwsilRUVIm+JmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N2zx12u8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N2zx12u8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02BA91F000E9;
	Tue, 21 Jul 2026 17:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655533;
	bh=m95GW2XTyIkNjgzrES8XlW6z4yNO+t3RvyVlpuCU5PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N2zx12u8kxAxkJjHMN9AySdTv8dafAUUZzzPmK/aqy8UYnQ2kyESTVHixREUcwtV7
	 X2s/lOrZbVUBGBd0sJjrZKmpqWyWQh4cHdZmmoJSY7U25UBI2ryDcAStlIC/MMzLwT
	 t6DCuMH4WkYiy3r65GCcXVQLbL7cN7U7wN5SegbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0043/1611] rxrpc: Fix potential infinite loop in rxrpc_recvmsg()
Date: Tue, 21 Jul 2026 17:02:39 +0200
Message-ID: <20260721152515.792563071@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 67a0332f442ef07713cd2d9c13d59db0f1c23648 upstream.

Fix the wait in rxrpc_recvmsg() also take check the oob queue.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Link: https://sashiko.dev/#/patchset/20260616155749.2125907-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-9-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -436,7 +436,8 @@ try_again:
 		return -EAGAIN;
 	}
 
-	if (list_empty(&rx->recvmsg_q)) {
+	if (list_empty(&rx->recvmsg_q) &&
+	    skb_queue_empty_lockless(&rx->recvmsg_oobq)) {
 		ret = -EWOULDBLOCK;
 		if (timeo == 0) {
 			call = NULL;


