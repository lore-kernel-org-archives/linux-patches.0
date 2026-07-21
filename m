Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C613326D44;
	Tue, 21 Jul 2026 17:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655537; cv=none; b=Ljpokdn2A8eWrJeKsjd7lc7Sj8wmwAmFGw/GefGFl6NDA0aTi0MBdhTHorW71sK6rHtMrMaqP2MectzvDHS0idY/x1njysp7+/KvLG3sApMjdHJcDyr6mQ46eTi26T3wSydLQaMXBWcPHmXiPDokAUvO2yTG/RGDIpayWlhypvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655537; c=relaxed/simple;
	bh=shyHTw3i5ygPMGV6wllAsacnZeIIudngDOZXZE0eDnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgrHM/EbqhEsWybob5xKYgy45XwGSwwmkZt6Aiu3QJbhvObrjv6HqITQwBFx2LmhuQQZolGX7yKPNHM7CCGnC7JcXi9mYXTkdTlfU/QauVPsp/jnelPhrA0jzENDNi6GNQ2E+mQI5xR1ahnfaHhA6tcX5l9/r3DTEfspYN/t290=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M32r3m2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M32r3m2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CB31F000E9;
	Tue, 21 Jul 2026 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655536;
	bh=kYUHWx0HtKy8IVmw/BRNzPYtwuvX2eKJou3UjRVj3lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M32r3m2dxGMGb9i5d4Uf2lgjnKzcadgALPSeAqfFu5boZ6XMWzd1TzanmL5uPWxyS
	 tz9Jt6wfwVu8K4WVpiHIv8J0EVwpU5s5QZz6R3lxLmgxNVXLOOeJ2qUUk2HFDt/UE7
	 3scX1b2v4gDqpHtOUsGRa57Tq32YCmQxVG6cuSjU=
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
Subject: [PATCH 6.18 0044/1611] rxrpc: Fix rxrpc_rotate_tx_rotate() to check theres something to rotate
Date: Tue, 21 Jul 2026 17:02:40 +0200
Message-ID: <20260721152515.814765023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

commit a5462da5a349fc7f17ad5ebd899380260d03e7ed upstream.

Fix rxrpc_rotate_tx_rotate() to check that there's something in the
transmission buffer to be rotated before it attempts to rotate anything.

Fixes: b341a0263b1b ("rxrpc: Implement progressive transmission queue struct")
Link: https://sashiko.dev/#/patchset/20260618134802.2477777-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-12-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/input.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -236,6 +236,9 @@ static bool rxrpc_rotate_tx_window(struc
 		call->acks_lowest_nak = to;
 	}
 
+	if (after(seq, to))
+		return false;
+
 	/* We may have a left over fully-consumed buffer at the front that we
 	 * couldn't drop before (rotate_and_keep below).
 	 */


