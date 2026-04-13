Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F7B2C08AC;
	Mon, 13 Apr 2026 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096596; cv=none; b=npQ+o7kfZRxN/TdZzHW+8dYWso8uFrVHb50/KHCWtTnUiVrY5zlboH6zoZZPQaXlTF4zMIioZeiYIvLLsPYqim7EfxmJ7T75tEgsWDFAa2iGeR1WRucev31OmM1q6m5IseTGKTvpRBbmxW8+SfJunQDS/CkIEDNTMF6alrtR1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096596; c=relaxed/simple;
	bh=NFzRyR9OlPdSfUyy+WPMFd2PllmoTAOuEo1RKS/UepM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3trm8lgdFgD67LrWYxqyKP9qc2MtiCGhMBlMuA3/23d4m/ajILXC7mAP1d+xO+DdpKZvTD2GgU1fBMeTm/mZQXAwayubsgT+eq6mm6cAcJeQsSem2nMTLTeGGQjEDjw5tRydTbq3qkJ04E06UIKFhsClSQhuF9wvRp8Xg70zlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3aFNJG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3aFNJG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080AEC2BCAF;
	Mon, 13 Apr 2026 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096596;
	bh=NFzRyR9OlPdSfUyy+WPMFd2PllmoTAOuEo1RKS/UepM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3aFNJG36IbAOTuWd4Omd1oWHchmJr1W6kDuwtiDXHjejUxMXLK5uTx1Lnvw6zJEX
	 9DQtLFImIpgIF7nXEjLc82+RjTUFzBAGZOahrgiWPrfnvE8EoG+hru9vft3dh6s5sZ
	 NNg4RILAH/H6oPQPkmsm+f7Q0iqBuEEHPXZZ9zC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Douya Le <ldy3087146292@gmail.com>,
	Yuan Tan <tanyuan98@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 71/83] rxrpc: Only put the call ref if one was acquired
Date: Mon, 13 Apr 2026 18:00:39 +0200
Message-ID: <20260413155733.653271623@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Douya Le <ldy3087146292@gmail.com>

commit 6331f1b24a3e85465f6454e003a3e6c22005a5c5 upstream.

rxrpc_input_packet_on_conn() can process a to-client packet after the
current client call on the channel has already been torn down.  In that
case chan->call is NULL, rxrpc_try_get_call() returns NULL and there is
no reference to drop.

The client-side implicit-end error path does not account for that and
unconditionally calls rxrpc_put_call().  This turns a protocol error
path into a kernel crash instead of rejecting the packet.

Only drop the call reference if one was actually acquired.  Keep the
existing protocol error handling unchanged.

Fixes: 5e6ef4f1017c ("rxrpc: Make the I/O thread take over the call and local processor work")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Signed-off-by: Douya Le <ldy3087146292@gmail.com>
Co-developed-by: Yuan Tan <tanyuan98@gmail.com>
Signed-off-by: Yuan Tan <tanyuan98@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Ao Zhou <n05ec@lzu.edu.cn>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260408121252.2249051-11-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/io_thread.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rxrpc/io_thread.c
+++ b/net/rxrpc/io_thread.c
@@ -419,7 +419,8 @@ static int rxrpc_input_packet_on_conn(st
 
 	if (sp->hdr.callNumber > chan->call_id) {
 		if (rxrpc_to_client(sp)) {
-			rxrpc_put_call(call, rxrpc_call_put_input);
+			if (call)
+				rxrpc_put_call(call, rxrpc_call_put_input);
 			return rxrpc_protocol_error(skb,
 						    rxrpc_eproto_unexpected_implicit_end);
 		}


