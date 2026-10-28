Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210908;
	b=e7mhG2PrW8TBPVkmM8cKbv8g3B8gjgO0AEwcG4hHWHWXUEWLXcR6kgRfKxYyASECMrax
	 nA4wYE2/5hKIcPZAgsVGC650jVpSqvthJEJji42ZttR6TYp2zPxv7u/xq4ZWNVLiFUk5K
	 KZcP38dB0iin7jnoAqgys9Lmq0AYXV3/xOJkZBA9kb5eac4tHWask/gCk3yK6vxLahBo1
	 NGDlHlEJYtPw1g99SaTln6sB7XOOY8zWxNJVP3p6FSg5T8BgMtbLzZiVR5GJU3wIVOUyQ
	 4EAMfWoU8h/V3QGqzhrT+MiDlt23jHMB9qqfXWeeruylTW5Sm8XKCa0jxRQ9Pf5EA+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TCLT7vbs33K4OIlcRiKFwkeJh8BUUCUk5G+fkM0voOQ=;
	b=pbVvWihsv2/MrXX6DWxlYQw9qEDQOCFzsmn84cwfymN01fmRW47VVcJU/K21tXefKY8p
	 hfxAGZh6PgVKn5aPag9ZDQTexbHvBwT58Uxl7NFsQspf799w4PhF7i8GSP9muL/E1INQD
	 YG844IsiaIjsBnXtDKhSbPgSZnWnBikCGykMVhG6J3N8+0z3fZhKc5xoKqb2Ko+efqa6E
	 U60HBTsBV3rzi1lqjQ1ZueHVhuYAnLed5sb35CTCppZRgFzMbKmd9AKku0ZeMFjMNo88c
	 tPcBA12w+NW4t4kpJ3glxMpxB9BT7gJEKOwBhMn9A7oPLDnp73GbGgfMzoTdNPsXejA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE4OkUvh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BE5606A31D;
	Wed, 28 Oct 2026 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vE4OkUvh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317511F01825;
	Wed, 28 Oct 2026 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210907;
	bh=TCLT7vbs33K4OIlcRiKFwkeJh8BUUCUk5G+fkM0voOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vE4OkUvhEiDBHfp17zGJs6nYpdtwB0PeHq6bXh+LBQkE0BbnsFG6ihUbcPpS8hQY7
	 EdvUJ+cw4nrkWSbkS4KHotJxmnBybRs8VkR7BTcmi5BtceeZnrNIL3ozChHpkfA55u
	 QeEv6q+cHbLYQgMvMXLeDoL9adBP1bNnGBIUjv90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 5.15 192/571] kgdboc: Fix tty driver reference leak in configure_kgdboc()
Date: Wed, 28 Oct 2026 17:55:39 +0100
Message-ID: <20261028170012.565282872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit ef3134cd0d4831ae2137aee2883987859b80b2c6 upstream.

tty_find_polling_driver() returns the tty driver with an extra
reference taken by tty_driver_kref_get(). configure_kgdboc() stores it
in kgdb_tty_driver but the reference is never dropped: it is leaked when
kgdb_register_io_module() fails, when the configuration is cleared, and
on every reconfigure.

Release the reference both when unconfiguring and on the error path.

Fixes: 7d7b93c1452f ("tty: kref the tty driver object")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260917155523.2161202-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/kgdboc.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/tty/serial/kgdboc.c
+++ b/drivers/tty/serial/kgdboc.c
@@ -190,6 +190,11 @@ static void cleanup_kgdboc(void)
 		return;
 	kgdboc_unregister_kbd();
 	kgdb_unregister_io_module(&kgdboc_io_ops);
+
+	if (kgdb_tty_driver) {
+		tty_driver_kref_put(kgdb_tty_driver);
+		kgdb_tty_driver = NULL;
+	}
 }
 
 static int configure_kgdboc(void)
@@ -250,6 +255,10 @@ nmi_con_failed:
 	kgdb_unregister_io_module(&kgdboc_io_ops);
 noconfig:
 	kgdboc_unregister_kbd();
+	if (kgdb_tty_driver) {
+		tty_driver_kref_put(kgdb_tty_driver);
+		kgdb_tty_driver = NULL;
+	}
 	configured = 0;
 
 	return err;


