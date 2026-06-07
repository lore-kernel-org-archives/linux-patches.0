Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187F43290D8;
	Sun,  7 Jun 2026 10:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828119; cv=none; b=FdGYKqzMGv8FEAsfJ2sacDnR697yIpi5xZ12MWZbjK6M07ZuPIb2uru070cYGNRro1eUvbfckHhrlaETQzHX/ZLey10eS7/tCs3UmarIzJI4HVlij31wdGUxaEH7SJsWDTEIYggmtrc+bbb5wIZnfzFrwuzpEl/9eTQpKygV7I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828119; c=relaxed/simple;
	bh=ieAfsMDttXmf9n0TZ8gVBs9JTqz4O1bP0o+ooS+Lyck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3oHbyWvTnkesrolMrZZTMHH8MiU4PNVtuvlLU05CoPuRVZRGowyQ/CPj4jr0pe034btZo6Z5NeyEWZjJT3SrBV6fLbL6P4qWzGQUuSNn3Aiw1EeBnfci0P/1QH3UsJb1vs2ceJoOs++Hv6iS+sVq4SVsEUpWpwcVmjB8Wv4T1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCgjIkH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCgjIkH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284F21F00893;
	Sun,  7 Jun 2026 10:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828116;
	bh=1z0/jljo8vg6a/aJwmPGpJVWk5OCgPHed0Gw8f9S3co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCgjIkH0g0KZCuxNBhAGT1QgMSawDd/3g2ZbYcxXdv3xyrFBPHD6fooZvNTDP/J98
	 fknDYD/jCnIp6Iyw04xRlMnC9Sn7Yb7Mehik8ZvP07Un5cRnL+9X1dwljOaFmO6dLt
	 SznVbHWDCypbh1N6HOTjVtq0oCV0rJcDlB6p3dKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.0 132/332] USB: serial: cypress_m8: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 11:58:21 +0200
Message-ID: <20260607095732.946549670@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit e1a9d791fd66ab2431b9e6f6f835823809869047 upstream.

Make sure that the interrupt-out endpoint max packet size is at least
eight bytes to avoid user-controlled slab corruption or NULL-pointer
dereference should a malicious device report a smaller size.

Fixes: 3416eaa1f8f8 ("USB: cypress_m8: Packet format is separate from characteristic size")
Cc: stable@vger.kernel.org	# 2.6.26
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cypress_m8.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -445,6 +445,14 @@ static int cypress_generic_port_probe(st
 		return -ENODEV;
 	}
 
+	/*
+	 * The buffer must be large enough for the one or two-byte header (and
+	 * following data), but assume anything smaller than eight bytes is
+	 * broken.
+	 */
+	if (port->interrupt_out_size < 8)
+		return -EINVAL;
+
 	priv = kzalloc_obj(struct cypress_private);
 	if (!priv)
 		return -ENOMEM;


