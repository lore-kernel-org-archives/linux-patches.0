Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B6214389F;
	Tue, 23 Apr 2024 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908648; cv=none; b=NmSBdfpeg1R4Q4QG9rvyYxOvSJ8C790zmgHBXZgKNHXiH+Yi3+qXbb6mXkERdT2e8DxT8ayyNePmgwlk9wBUkQx4F/oliG4BaZ/qULx87xLHgmhCRk4LKWG2OW9NQssklLtdm+tqZ+RsIXDvUZgpNBDS7o43kaXzHMKIAEhWLUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908648; c=relaxed/simple;
	bh=Ir7FPIXFTq1wkjoyNyKVlxvy0Ojx2hZj3QUOM/KZgVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNsF0ZR/3DzGUYjqie5qWEPTFZOoJjk3/anT/WlHy5ngjV6VLrVWJImuliPxwfSGx9z5CVTMqBpxwE4B16hcpzQvpi5eUJE0Azj8Cs19qvAsa/sblHk3Sz2Qh4XfZ1Fgh08WG6rjdHK7yHjId4MR6NNKbI0FUj1l5BGh3m7ugGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvgBYoYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvgBYoYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012A2C3277B;
	Tue, 23 Apr 2024 21:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908648;
	bh=Ir7FPIXFTq1wkjoyNyKVlxvy0Ojx2hZj3QUOM/KZgVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvgBYoYTiWbflhFk+xN5WX4CDLqNdgqwqEwiRZXbybZYTHIcASxnCyLqZLjn7bSLL
	 UQYkex5M5BMso4hbjS/7ivLjck2MkIDeR+8k5bkYdvCYPCJoNopnmyYvI4mh1wn188
	 Vpk6U/e/ZWO1DDWbkEo91YCv3ZeKXg3yp3RxdkYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Fine <gil.fine@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 107/158] thunderbolt: Fix wake configurations after device unplug
Date: Tue, 23 Apr 2024 14:39:04 -0700
Message-ID: <20240423213859.230891176@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gil Fine <gil.fine@linux.intel.com>

commit c38fa07dc69f0b9e6f43ecab96dc7861a70c827c upstream.

Currently we don't configure correctly the wake events after unplug of device
router. What can happen is that the downstream ports of host router will be
configured to wake on: USB4-wake and wake-on-disconnect, but not on
wake-on-connect. This may cause the later plugged device not to wake the
domain and fail in enumeration. Fix this by clearing downstream port's "USB4
Port is Configured" bit, after unplug of a device router.

Signed-off-by: Gil Fine <gil.fine@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -2949,22 +2949,29 @@ void tb_switch_unconfigure_link(struct t
 {
 	struct tb_port *up, *down;
 
-	if (sw->is_unplugged)
-		return;
 	if (!tb_route(sw) || tb_switch_is_icm(sw))
 		return;
 
+	/*
+	 * Unconfigure downstream port so that wake-on-connect can be
+	 * configured after router unplug. No need to unconfigure upstream port
+	 * since its router is unplugged.
+	 */
 	up = tb_upstream_port(sw);
-	if (tb_switch_is_usb4(up->sw))
-		usb4_port_unconfigure(up);
-	else
-		tb_lc_unconfigure_port(up);
-
 	down = up->remote;
 	if (tb_switch_is_usb4(down->sw))
 		usb4_port_unconfigure(down);
 	else
 		tb_lc_unconfigure_port(down);
+
+	if (sw->is_unplugged)
+		return;
+
+	up = tb_upstream_port(sw);
+	if (tb_switch_is_usb4(up->sw))
+		usb4_port_unconfigure(up);
+	else
+		tb_lc_unconfigure_port(up);
 }
 
 static void tb_switch_credits_init(struct tb_switch *sw)


