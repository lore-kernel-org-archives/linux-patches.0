Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24E71F3FFE;
	Tue, 21 Jan 2025 18:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737483151; cv=none; b=i1OntW0yYIG8OcGr7li2lLPcUVQPvTcrizHmN+xVzBmuVjPuqWdvNFAHcMrduYDueeV+VQ0nrntbGjGDn1VbdctDmMhUpe8gavSOFJmPHdSMpsxk4uc2TdL/Oxrs9VRoKU890pS10Pk8DGRXHpyZReAvdrDsSQCG4YnO4KLq31E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737483151; c=relaxed/simple;
	bh=PmzLvH569dSSRg7rjhPPiwbNn8IluZMrSVYsbF6z8RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g93ZzenN+cbdB7UwpF5w51hp1dU1kvcOXaf4ZbN3Gmo2yHSi/4vbMlLouKIp/+0KqehyPTg7x83Vw88IEh2+87WBdNulOeR7cQW9moIfLkR2uCX7dRe68cSeuxIeZBTdHj/dleZd21tK1ydyWlJMFD/s4gmZTqh9gn4ncXnKy9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoASPK3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoASPK3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C399C4CEDF;
	Tue, 21 Jan 2025 18:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737483150;
	bh=PmzLvH569dSSRg7rjhPPiwbNn8IluZMrSVYsbF6z8RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoASPK3PchQgRwgGDrS10pqLSFiub4EZGTxFFB7e0UmhPUd6SNTusY3STAwM2OixA
	 PI5/NXSqY0+O/HBlWP1uaAz0eUjuQBHmiQT437hJoOjAwQy8xaguVFZ3a89C3xI5Ng
	 2yvFxjbYbwZyDAFxHbXDhZoEHqI7up8MGjAT+m7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <v4bel@theori.io>,
	Wongi Lee <qwerty@theori.io>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Luigi Leonardi <leonardi@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 108/127] vsock: prevent null-ptr-deref in vsock_*[has_data|has_space]
Date: Tue, 21 Jan 2025 18:53:00 +0100
Message-ID: <20250121174533.816676881@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -870,6 +870,9 @@ EXPORT_SYMBOL_GPL(vsock_create_connected
 
 s64 vsock_stream_has_data(struct vsock_sock *vsk)
 {
+	if (WARN_ON(!vsk->transport))
+		return 0;
+
 	return vsk->transport->stream_has_data(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
@@ -878,6 +881,9 @@ static s64 vsock_connectible_has_data(st
 {
 	struct sock *sk = sk_vsock(vsk);
 
+	if (WARN_ON(!vsk->transport))
+		return 0;
+
 	if (sk->sk_type == SOCK_SEQPACKET)
 		return vsk->transport->seqpacket_has_data(vsk);
 	else
@@ -886,6 +892,9 @@ static s64 vsock_connectible_has_data(st
 
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
+	if (WARN_ON(!vsk->transport))
+		return 0;
+
 	return vsk->transport->stream_has_space(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_space);


