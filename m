Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336553DDDD6;
	Mon,  4 May 2026 14:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903923; cv=none; b=N1vpuvoJi6Kp1ggRqjfI2vn0hBFiYCCDevh61XFVFMUPElcwN6yHs5lApK/HDj2homcHSmXOnbeJjEquHGT/GaxF6GRXUcENxxzVsQYx3O53/UvjCcRjeCciLQvH7dN3dMJKs4XOHIxBf1JrzP6pWlziPAEwhlEpRFP9llvfAZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903923; c=relaxed/simple;
	bh=QclF9ZhgNHQ8kifAGK1f0/eWmpuoIVQjKAOYZGWV3ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1L2EVatVTgxFHyEJo/K9AwCuqra9YDSq4/y+yG4nRKbqy3z2OeWm1SLMLHZShliv3YgZm2nUihzlQ3Cli/NBGMTxVOwvTmECnftvXcKf/Rk2pgi6d28wsB/cvOqa/REKZDs7CSUSAsuCoomL8Ne8nBJnNp9SqdgM8bdRYmgRHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14gT6XzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14gT6XzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE108C2BCB8;
	Mon,  4 May 2026 14:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903923;
	bh=QclF9ZhgNHQ8kifAGK1f0/eWmpuoIVQjKAOYZGWV3ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14gT6XzOLBzCJCbmdHuYqjWvv25TQdA6D4KacomJs683HFH9gVSKK0ReUMk/HLfeW
	 /C0KsC6bj2JYQGvpzAA1K/2G7RLwbNt3wBL3UwhDybWs0DLkpP6r7KJhNFJV6F7iLV
	 sKK4rDdjBit3iw7KGw7AryGy69B38rdtOD2cYxP4=
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
Subject: [PATCH 6.18 114/275] rxrpc: Fix rxrpc_input_call_event() to only unshare DATA packets
Date: Mon,  4 May 2026 15:50:54 +0200
Message-ID: <20260504135147.143549909@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

commit 55b2984c96c37f909bbfe8851f13152693951382 upstream.

Fix rxrpc_input_call_event() to only unshare DATA packets and not ACK,
ABORT, etc..

And with that, rxrpc_input_packet() doesn't need to take a pointer to the
pointer to the packet, so change that to just a pointer.

Fixes: 1f2740150f90 ("rxrpc: Fix potential UAF after skb_unshare() failure")
Closes: https://sashiko.dev/#/patchset/20260422161438.2593376-4-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260423200909.3049438-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/call_event.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -332,7 +332,8 @@ bool rxrpc_input_call_event(struct rxrpc
 
 			saw_ack |= sp->hdr.type == RXRPC_PACKET_TYPE_ACK;
 
-			if (sp->hdr.securityIndex != 0 &&
+			if (sp->hdr.type == RXRPC_PACKET_TYPE_DATA &&
+			    sp->hdr.securityIndex != 0 &&
 			    skb_cloned(skb)) {
 				/* Unshare the packet so that it can be
 				 * modified by in-place decryption.


