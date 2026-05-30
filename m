Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC8721E098;
	Sat, 30 May 2026 18:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165956; cv=none; b=ngS2FjvXJ77BXAtoJeNmm1pYSYF8nYR9shNb38f9dw7VbXUTeLhCtNi+3wXqosYZfkGNk+kAQfFUl1Xfxy6plrMb+byDgJ7/NMrSyJqp5g4dyrIysNkdXxMxJUhmJICev1/kRJleiVHVV11IiQXmVQX+xJoZZW1uHEezodonnL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165956; c=relaxed/simple;
	bh=PbIPap2PnW+2o8qK7LBWThznt/8kPNmHB9FhG11Q8fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9coX7B0PzOLXdyHP5/GWPbCrk6wbn509+IXbNDBhumcUQN8vVPFKVbiAtxcioiOw5cBfT1i9XW4MS6IroAg4hU+9CpsVun/5lff4SaWlxkgPcarm2ggHVCPxVRttj7ZlMrviQIPqWa7nXMAEeFuFRCoHX8RXmu9RzVMjJGB+p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPgcAYNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPgcAYNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA811F00893;
	Sat, 30 May 2026 18:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165955;
	bh=nOk366RtIHiWieqfa9cxOEONfM5+k6GxGVss9hWCIGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPgcAYNf+zDOC0izGPxgb3qw6N61q6L+YoIzVyhlm8MlK5kZG7mW/NUozwUUBxITr
	 Q1c29IgXDF9Ly8KV11fR6j6nTAxtB2SSW59lWFNJVwWLYMMSOwc9GlBHnBbrbuoC9c
	 XKC6KGSkatk5JIWrAFwdEVvhIuxhtXc3eyEVQFFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 231/589] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_state_change_cb()
Date: Sat, 30 May 2026 18:01:52 +0200
Message-ID: <20260530160231.054801133@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siwei Zhang <oss@fourdim.xyz>

commit 2ff1a41a912de8517b4482e946dd951b7d80edbf upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 89bc500e41fc ("Bluetooth: Add state tracking to struct l2cap_chan")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1599,6 +1599,9 @@ static void l2cap_sock_state_change_cb(s
 {
 	struct sock *sk = chan->data;
 
+	if (!sk)
+		return;
+
 	sk->sk_state = state;
 
 	if (err)


