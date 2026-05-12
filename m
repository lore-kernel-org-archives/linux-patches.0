Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328F92DE6E3;
	Tue, 12 May 2026 18:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609231; cv=none; b=WEtN5ByEJ1X078ZEMNmcgU8T83Uw4DdYK+esHALNp25pY7MT7InxDll+Igef+3PslU0Pttc9nyeIkoCjYn73BBlCL7a907mmz28uOVTkkcZhR2URa4Y1ruPEnWH3hkHLF8XcYYARjO+QTEt4AyVmNaMfcC2SyaxdOvGsT0u/g5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609231; c=relaxed/simple;
	bh=Gv7lVlOXq+KtJf4BxmFb63p3vtuws3j5YD6O83/uoVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjpYNkHvQoPVfKNEwh9iW0myCwNiyi2oIAxGNJ4r6+2ql1nA5UV9X2hEWuh9/1NItUjCRpzLbf55/Pck8WzKsxbY2dccgZSQrzA/7BiFZ8ngzOv3ZZCvMoFepyv482uBJDboDYSqOINFmuN+jTdzEcnC/jBN9Ke+wz7eMp2Hha8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oZN7Fv4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oZN7Fv4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B546DC2BCB0;
	Tue, 12 May 2026 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609231;
	bh=Gv7lVlOXq+KtJf4BxmFb63p3vtuws3j5YD6O83/uoVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oZN7Fv4urkV5MLU9y7TOqIOeKbdkJIVC6SpFIAcoRC/Rp0pa8FSb6uplgbPRBiU2d
	 WoVVgk75pYVDVMpGeknl31jQwwsxokdIZZ2NbkGvr0FZ5kWJPMGGm9nfSVEqFESsgV
	 8vFBaPW0nHik+CSRtf3w7FzsQi9XSzi8gHvTHIxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Siwei Zhang <oss@fourdim.xyz>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.0 074/307] Bluetooth: L2CAP: Fix null-ptr-deref in l2cap_sock_new_connection_cb()
Date: Tue, 12 May 2026 19:37:49 +0200
Message-ID: <20260512173941.683776274@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

From: Siwei Zhang <oss@fourdim.xyz>

commit 0a120d96166301d7a95be75b52f843837dbd1219 upstream.

Add the same NULL guard already present in
l2cap_sock_resume_cb() and l2cap_sock_ready_cb().

Fixes: 80808e431e1e ("Bluetooth: Add l2cap_chan_ops abstraction")
Cc: stable@kernel.org
Signed-off-by: Siwei Zhang <oss@fourdim.xyz>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1498,6 +1498,9 @@ static struct l2cap_chan *l2cap_sock_new
 {
 	struct sock *sk, *parent = chan->data;
 
+	if (!parent)
+		return NULL;
+
 	lock_sock(parent);
 
 	/* Check for backlog size */


