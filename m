Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E293AE1A2;
	Tue, 16 Jun 2026 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635800; cv=none; b=DMymhVB9V2NqIdGarf+jaR+wjqoY4zgJqNxzMXsrWMsx5HKWW6cjCBTpsAM+zTQD4YuliwESEUk8LubDAkSsfE2jtPKXKeM6x0bIiL7FET6bi6LBfXaJ1EsE52xCg/L6Y6OpGCYInJIRk8C/NoSCWX7hlw1JhdVUucU4HwZbfXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635800; c=relaxed/simple;
	bh=pOQH6OIQzxFqHAJRlWpKzM/wKwEUR/xpIQ5YymIduv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGXKl/ob0i1eVvBS8UOANIqFm/3XFdaeQHgNd9U+JtGcHoPB0KZKylvYvwKz2jNd71yf9z2GikV7Nn+4fa9R8730Gc5j8P3FH5TazI38Un+hZoeCH3I2QVHxDBZ6Ev3iz026lZMfeoFnWzmG9kUqr/XnEYeA1vHk4VO/qIKAJ08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGUyzR8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGUyzR8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6C31F000E9;
	Tue, 16 Jun 2026 18:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635799;
	bh=7WaDSrn1CQNrHdLdYyoiT8KtJ69ZuMy/UxbN7Q8U9kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGUyzR8B01EDL+gnRbTLgA6+7xTO5TKCC8CC+bGnaIUaI7kKx73Yy9iPhW3DIYS9m
	 ZRkMnk+gzzyqL5p9+Ei3j9evNgy4VnIKwnRcu70ACjdqUMB0L+z0B4Osl/oongFFFw
	 XuW+pPuUj8iQdnswFRrFzUrjaLXIcdicnIHZDUCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/342] USB: serial: cypress_m8: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:26:52 +0530
Message-ID: <20260616145053.617227596@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit e1a9d791fd66ab2431b9e6f6f835823809869047 upstream.

Make sure that the interrupt-out endpoint max packet size is at least
eight bytes to avoid user-controlled slab corruption or NULL-pointer
dereference should a malicious device report a smaller size.

Fixes: 3416eaa1f8f8 ("USB: cypress_m8: Packet format is separate from characteristic size")
Cc: stable@vger.kernel.org	# 2.6.26
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
[ johan: adjust context for 6.18 ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cypress_m8.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 82d2e076ea9a09..e924fb212f5b24 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -447,6 +447,14 @@ static int cypress_generic_port_probe(struct usb_serial_port *port)
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
 	priv = kzalloc(sizeof(struct cypress_private), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-- 
2.53.0



