Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D334F475B;
	Tue, 13 Oct 2026 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894999; cv=none; b=sDi0CJv775PVv04vwAeu1zYhVQU3jn+xLrWiC73Il8wWqbZHtrvVQM4tHDHFD8/aWs8s9MYFnrCIvvvPi2ONHCjP/+anAtmQZSXs0hwWeZeSWf/bHO1CFVMO0Mb3XMENLCOGBffloUMz9MQym0LWKl76KEiol0R/j1YxRisgGn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894999; c=relaxed/simple;
	bh=adsKuLQ3bw8AdP1GghB1CkbO7EilOoDkMTMp59rW+nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZexN26Qy76VyaN5ILjKmO8YL5JIbDLlEdrPzd4TOe6AKCsyJRJtiGDFJBM3VPdN8bSLe9y8BOzm6JUWQnOV9H83FT4f+Sd7X8wH28K62GL/770L5ubUqNutBhYuckCkfFB+lEC5lRe4tNqgukqGEwwrZjsW12ldMtV2z7pLnWNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5mJPXEK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5mJPXEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBB71F00893;
	Tue, 13 Oct 2026 12:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894998;
	bh=SL+e3Z1roRX4dqLT9YNz1Nv2c50L7orGfYuZxO45PjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5mJPXEKl+L+ZukJTPiBj7mya7hTWmQmFYw4UnccuU3t2egXz0VfA8LFMI7tpfa9o
	 XeEK3n2ydBL+vHGMK/RS63+IBjCxZY6Vb+NoV0vNQPa030yNwlXZ4CxdoUob+0KCzA
	 PBm7FSecEmcqRFhMjVnJVXZpMw5LiPbHOtbBdUKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.12 125/497] kgdboc: Fix tty driver reference leak in configure_kgdboc()
Date: Tue, 13 Oct 2026 13:34:52 +0200
Message-ID: <20261013112910.857823308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -262,6 +267,10 @@ nmi_con_failed:
 	kgdb_unregister_io_module(&kgdboc_io_ops);
 noconfig:
 	kgdboc_unregister_kbd();
+	if (kgdb_tty_driver) {
+		tty_driver_kref_put(kgdb_tty_driver);
+		kgdb_tty_driver = NULL;
+	}
 	configured = 0;
 
 	return err;


