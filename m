Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22B73290B0;
	Thu, 28 May 2026 19:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998287; cv=none; b=Polu42rnmWM9erRAM74U8mhwlbmxuWEw/9Mtbgg5Xce59PtlnfijzBvP7bWBuvS3mUzfaZrMoQUg4S6XjvLRqVcbsXbnQy05VxJMQq7Vnz3aowbaqMCdMVm3TKNJ/52OqYNdN/MMD0fK2h+CoKCTiEt1Dg/O9i//0/Y4UrzeVfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998287; c=relaxed/simple;
	bh=m3aF69UvYk3EJWrs/JxiK6pUks8IADPEIggRgYK4WNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gLAy5KtNFPg1rM1hKvVoAsmCy0rhWFVll5n+OW5wKj7RZ0LkrwssOr2uYx7sRj9ccPjYKnzwV8bGAPj5CSfMv48g8mzufR4wKWYBKInPGeqjNqTPKFAddvlCMUYe92667+Jqm8WmXsauXj/NFXABG8xPFlQE0o4rJGDtZVxByyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQGxPajA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQGxPajA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8581F000E9;
	Thu, 28 May 2026 19:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998286;
	bh=Mh0il5TH7wX76IfqeeIjHNyA1wIrRsZTL6QR93eCf9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yQGxPajAUOM+ps0XI6ihfPmisoiR9q1J8aEJZZi5YdBIql3oiUj3j9zECb+N5aXLT
	 TnwFnFUeXokQC+fa9Be4/2VRMV92eriOTbEx6XGqE+zw3KrbKjZjXDFSaAPyd3lEwz
	 1oyfMkCX8qeBF2uHymwqQId/itxboh4UvazQPA6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 7.0 084/461] mptcp: reset rcv wnd on disconnect
Date: Thu, 28 May 2026 21:43:33 +0200
Message-ID: <20260528194649.351966113@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 0981f90e1a05773a4c29c6e720f5ea1e3c8f1876 upstream.

If the MPTCP socket fallback to TCP before the MP handshake completion,
the IASN remain 0, and the rcv_wnd_sent field is not explicitly
initialized, just incremented over time with the data transfer.

At disconnect time such value is not cleared. If the next connection falls
back to TCP before the MP handshake completion, the data transfer will
keep incrementing the receive window end sequence starting from the last
value used in the previous connection: the announced window will be
unrelated from the actual receiver buffer size and likely too big.

Address the issue zeroing the field at disconnect time.

Fixes: b29fcfb54cd7 ("mptcp: full disconnect implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260515-net-mptcp-misc-fixes-7-1-rc4-v2-4-701e96419f2f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3470,6 +3470,7 @@ static int mptcp_disconnect(struct sock
 
 	/* for fallback's sake */
 	WRITE_ONCE(msk->ack_seq, 0);
+	atomic64_set(&msk->rcv_wnd_sent, 0);
 
 	WRITE_ONCE(sk->sk_shutdown, 0);
 	sk_error_report(sk);


