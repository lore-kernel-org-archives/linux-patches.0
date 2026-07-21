Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F300B46AA68;
	Tue, 21 Jul 2026 15:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784647998; cv=none; b=hFheEbGFexHkhqOcAyvXtV5+Dohc8NgfKBthtBmg83hcBKPy1wU2jqfE7Wmsej69nQm66+ej6xnzf2I86C7f1an05M4EOJZOMtVHw/yGRPrlmJqH75MDG7hhGPX06hWlStJiU+0U75oP82MDdZQPJ0b4cxxv33A+thtJlI7dr80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784647998; c=relaxed/simple;
	bh=0QRMvI4x1ojTg/BeMGVscwU85JujKwgj7Ng4fHBr/xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTegCyyuYXLiojNLd7LGyfPKwrpY6wgIQJGZ/nRnRn+xVkDh7eq25/fYpBiVMUYkf7tBGecOXxuYoFpMnHv8bHXnPVPfVeVqvjkez8AzjQ7Q7vuaguofAGgW/MOr4fx6/mEBguBL9zExuiEjhYB+D8eg1fmessHr55J7WjZgnvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNIf4zIv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNIf4zIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6958D1F00A3A;
	Tue, 21 Jul 2026 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784647996;
	bh=Ulcfbfyy/1KU/AFjUrug9ua3gYEilS8U5KhWc7ilmDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNIf4zIvWysFxzILXPblhL+NFsLp+C/jPrXYRpRDH0ajGT7exohISJr7xzf7Fwla1
	 0tBLprU2ajnzK4j1quXgxovWk45oB4+Zpl7UhSZM9B9KHaJHMILHMbknbNb0CRI4fS
	 vYZp5qYGVZt9mjJX/J89WrdAyXADxPUx5d2wE8W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 0033/2077] rxrpc: Fix double unlock in rxrpc_recvmsg()
Date: Tue, 21 Jul 2026 16:55:06 +0200
Message-ID: <20260721152553.460010962@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit a2f299b4d5510147fa8629a6aba2869bbcc88aea upstream.

Fix a double unlock in rxrpc_recvmsg() when dealing with OOB messages.

Fixes: 5800b1cf3fd8 ("rxrpc: Allow CHALLENGEs to the passed to the app for a RESPONSE")
Link: https://sashiko.dev/#/patchset/20260609140911.838677-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-4-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -470,7 +470,7 @@ try_again:
 		release_sock(&rx->sk);
 		if (ret == -EAGAIN)
 			goto try_again;
-		goto error_no_call;
+		goto error_trace;
 	}
 
 	/* Find the next call and dequeue it if we're not just peeking.  If we


