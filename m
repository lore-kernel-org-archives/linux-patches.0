Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07801A682B;
	Fri,  9 Oct 2026 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555989; cv=none; b=q4Kp596YyTK6Gk13XZQwOsiqrlcedKjHdVHgpt5JyhIOIjs3lxXnpDp3X35JWhWBVa7Rh3ZL6v21c/c9ieLnnCktn8Jw3rwhG8f2jmE+vh76zMG1+1gY8+btO0r0oU/qVdgVdHS4dCySP3s0ByOA4RmGkSnUdbOb2ljMMQmZCW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555989; c=relaxed/simple;
	bh=XF68xoxHqIKdarV28Sk+Wj0/BotWlmxYNhsm5euQMnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NXbSysZvteLJdNKbTpdfJbu0qyK/u4Fdl2uFyxOlnYVelG7SEa9iC19SQuqpsvSgiUd4Q8bJ/2cIB55jn3OLUjwHL0sTAwZHeYwHZU+isa97J2eIpwwmMcWSc7RVY8S6QdWuhcwPM3dPWK79coKpIKDDh7h+e36GeczzxqVHzOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtirS8dn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtirS8dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE2D1F000FF;
	Fri,  9 Oct 2026 14:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555988;
	bh=2cNmJ/gCzN9GRRYOnKI2eFF0bMZircMvb51pHzt0MvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtirS8dnSdT8QHuVvJvfgpm5k19g81RPWy/708/rKfedID3r9N/lbqXoqqRrc85bH
	 Iz8rbsfrlwkrNCt6B+zk42VynE+nefC+7gbxkF2JbuJJwat1iTRGvfZLv+cLbzuIPT
	 Qf+dgdUaFrK+TVqP40iPdaDvjh3256xxqoO2t5P8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.18 150/403] kgdboc: Fix tty driver reference leak in configure_kgdboc()
Date: Fri,  9 Oct 2026 16:08:31 +0200
Message-ID: <20261009140955.580371871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -188,6 +188,11 @@ static void cleanup_kgdboc(void)
 
 	kgdboc_unregister_kbd();
 	kgdb_unregister_io_module(&kgdboc_io_ops);
+
+	if (kgdb_tty_driver) {
+		tty_driver_kref_put(kgdb_tty_driver);
+		kgdb_tty_driver = NULL;
+	}
 }
 
 static int configure_kgdboc(void)
@@ -254,6 +259,10 @@ do_register:
 
 noconfig:
 	kgdboc_unregister_kbd();
+	if (kgdb_tty_driver) {
+		tty_driver_kref_put(kgdb_tty_driver);
+		kgdb_tty_driver = NULL;
+	}
 	configured = 0;
 
 	return err;


