Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C541E6DCF;
	Thu, 30 Jan 2025 14:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247183; cv=none; b=MhcaVuF8yJjuQvxG8sBLu1ILGNC6dMJLaXZt9DKVQKRov/NQUqi5Sc3pwhh/nTVnCJVM50eOvRQFdai0dwe0KeTB4aRTT4RPUEKXKcOgQBWIqIyG7LS9J+aqwBHEErdwAg/GId2uk930WxvF2suGkTDi6tEy2hBodIytJ2jQwyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247183; c=relaxed/simple;
	bh=srWnqkQzww4rSAxTsFPjwPegOo6cEC/N+NLRnGAaIh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tkgm9f0bqVDS3sU9If58UgBXr2XSXvO6bSaj1Tio0OI3L0/+HfLMMF9YdLgA9NjwxIntplUGzhDNJELkgNx4jMsWlQgMEnOHhdhGQDtLEj5voG2gtUzPDqYM44TuMkOGADgCuwz9eGXTc9kt4KkK8kU93S6+YZ/84vsdSgYy6MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkBkU5U7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkBkU5U7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F0DC4CED2;
	Thu, 30 Jan 2025 14:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247183;
	bh=srWnqkQzww4rSAxTsFPjwPegOo6cEC/N+NLRnGAaIh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkBkU5U7NKGKSHuNp2Ksk4PHCQHNc3L2HcBZzqXH4V67G+yb8dhe78PHU4D+nqSgt
	 w3OeNob5hvh4QN6aohpDJt7kZWsf5XJ5BQFtdEX485qzhYJvepI7it0K9i1/RjDV1o
	 L4XzbXF1bu7N7LI9/8L+D/kbO5fSOJ2EVtkP2tpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 111/133] vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]
Date: Thu, 30 Jan 2025 15:01:40 +0100
Message-ID: <20250130140147.003563227@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[SG: fixed conflict since this tree is missing vsock_connectible_has_data()
 added by commit 0798e78b102b ("af_vsock: rest of SEQPACKET support")]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -837,12 +837,18 @@ EXPORT_SYMBOL_GPL(vsock_create_connected
 
 s64 vsock_stream_has_data(struct vsock_sock *vsk)
 {
+	if (WARN_ON(!vsk->transport))
+		return 0;
+
 	return vsk->transport->stream_has_data(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
 
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
+	if (WARN_ON(!vsk->transport))
+		return 0;
+
 	return vsk->transport->stream_has_space(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_space);


