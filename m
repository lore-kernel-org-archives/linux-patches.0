Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CAB3A7D9E;
	Sat, 17 Oct 2026 17:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256578; cv=none; b=NHMaD5RKX7X2g9cxtUaESK/tv2WaO4dUPTTevbA86HNsQFiHu12nxefLdyQegJL7cfrDnXe5mIAhxcHg4Je0yKmaFX6A6xOtNtJyL8xlL8O7P5hgi425ZYXvuqBSJAMQLyAH4F6eijBHF76qtsIT5fdLfs76y9ztnS+j1OMKJMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256578; c=relaxed/simple;
	bh=Doo0T9qTybwIYUzWKDojxs9tM5vaSUFnWCWmZDSf8Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WO9PR95nrDELjGGWd7lS5gRMt/y9B0T+IQuEMKFPiNTJbSJ8VlRd9y5rCDyQUN24bT/Uhi6osRJHyUO2DE0gYU9+vNQbWbkciXHDbM+INzfFxHc4FcSepiAuPebkKqsEVO1puPomPA7QgfocTP5vsEMCT1kJ5FzjFERi70BX7S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vAxD7TE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vAxD7TE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105DE1F000C4;
	Sat, 17 Oct 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256577;
	bh=H6+NI+LynejZo3GJSR+TSWCdd0GtqvOXm9Pq1wST8+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vAxD7TEyK/kLQ8lv6I05uvX4Cf5nUHh5V4zeuVNlRglNJBJj5d5y4AU8Jp3zvv8M
	 h4kUa5P/3HyHHVZLAis0hNXcIW1oWgkllhnDfXVCuk1NHUZKoy6cbTPPugpW91BSLz
	 SQcMmtWgqiD9bvsL3ddq3wREty+h1/r4c0AA99J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joshua Rogers <linux@joshua.hu>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.6 0281/1674] tty: vcc: zero-initialize control packet in vcc_send_ctl()
Date: Sat, 17 Oct 2026 17:42:33 +0200
Message-ID: <20261017160438.328678053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Rogers <linux@joshua.hu>

commit 1f71f565e3585da1098ff19ca3c24687dab59185 upstream.

The stack-allocated struct vio_vcc pkt was partially initialized,
leaving the tag.stype_env field uninitialized before being sent via
ldc_write(), potentially leaking kernel stack data to the LDC peer.

Assisted-by: AISLE:Snapshot
Cc: stable <stable@kernel.org>
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260803-aisle-tty-vcc-v2-1-a50bc9b15193@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vcc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/vcc.c
+++ b/drivers/tty/vcc.c
@@ -492,7 +492,7 @@ static ssize_t domain_show(struct device
 
 static int vcc_send_ctl(struct vcc_port *port, int ctl)
 {
-	struct vio_vcc pkt;
+	struct vio_vcc pkt = {};
 	int rv;
 
 	pkt.tag.type = VIO_TYPE_CTRL;


