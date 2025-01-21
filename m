Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326D91F4275;
	Tue, 21 Jan 2025 18:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482683; cv=none; b=E3b5K3pLvQ+coxYVHQA0BDnmBSxQ3eXdmmn6BIwdsluJmMFEwF3W1ImM3T7uhfbFdv1+Mpz9Av7uV3cSlZLF3frehP1YcH+OVjgSL+X3KpPh9LTItzFd6VUxMa/xVyLe0pSuYoq68tkPnQiUfPJjp2sBM/XWy4ow14elMVcLBvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482683; c=relaxed/simple;
	bh=3NxHsCxMcJk+PygIVTmEVR6BV1F+jtRz2DZRsqTTbNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smssKSZtFpqeej4ybpDSFG3G58jsSgQtPwqpcv2D1q5VbyXEbzCzQnaSz2A/OOrDbZbepv+iCFwciirdDMYsq08Wve5sYih7JOtUbdFpEVVRPfcEwsQppOFsvsIOAw620SggrYZXhqIOL+5Og4HcnFcVgK7WF5raZwG1jrXNCUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGSVu2ro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGSVu2ro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0DCC4CEDF;
	Tue, 21 Jan 2025 18:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482683;
	bh=3NxHsCxMcJk+PygIVTmEVR6BV1F+jtRz2DZRsqTTbNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OGSVu2rorRyQFG+DPn+BZqc3TrUNGAeF4IllMn5qpvNOU08rjnEubjKLCgS/Alf24
	 UAckafes5O4K6ik+sarasNsHRGu6S5/5GkwsAuzrn/W4EjtRFB8kqv/FhLN1j2EM3S
	 9lnplta8GLwJwD884MPiYGn5WaLVjL10COGXsmNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 38/64] vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]
Date: Tue, 21 Jan 2025 18:52:37 +0100
Message-ID: <20250121174523.004791309@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Garzarella <sgarzare@redhat.com>

commit 91751e248256efc111e52e15115840c35d85abaf upstream.

Recent reports have shown how we sometimes call vsock_*_has_data()
when a vsock socket has been de-assigned from a transport (see attached
links), but we shouldn't.

Previous commits should have solved the real problems, but we may have
more in the future, so to avoid null-ptr-deref, we can return 0
(no space, no data available) but with a warning.

This way the code should continue to run in a nearly consistent state
and have a warning that allows us to debug future problems.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/Z2K%2FI4nlHdfMRTZC@v4bel-B760M-AORUS-ELITE-AX/
Link: https://lore.kernel.org/netdev/5ca20d4c-1017-49c2-9516-f6f75fd331e9@rbox.co/
Link: https://lore.kernel.org/netdev/677f84a8.050a0220.25a300.01b3.GAE@google.com/
Co-developed-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
Co-developed-by: Wongi Lee <qwerty@theori.io>
Signed-off-by: Wongi Lee <qwerty@theori.io>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Luigi Leonardi <leonardi@redhat.com>
Reviewed-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -873,6 +873,9 @@ EXPORT_SYMBOL_GPL(vsock_create_connected
 
 s64 vsock_stream_has_data(struct vsock_sock *vsk)
 {
+	if (WARN_ON(!vsk->transport))
+		return 0;
+
 	return vsk->transport->stream_has_data(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
@@ -881,6 +884,9 @@ static s64 vsock_connectible_has_data(st
 {
 	struct sock *sk = sk_vsock(vsk);
 
+	if (WARN_ON(!vsk->transport))
+		return 0;
+
 	if (sk->sk_type == SOCK_SEQPACKET)
 		return vsk->transport->seqpacket_has_data(vsk);
 	else
@@ -889,6 +895,9 @@ static s64 vsock_connectible_has_data(st
 
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
+	if (WARN_ON(!vsk->transport))
+		return 0;
+
 	return vsk->transport->stream_has_space(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_space);


