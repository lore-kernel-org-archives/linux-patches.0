Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750D83D8912;
	Fri,  9 Oct 2026 14:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556527; cv=none; b=td3IoASmYL4eA3QdVuHFwSb/YyH1e9fqjDzRV3k/sdVtPLn7CX6DEQLthe24q3NPpneFxpDPVtHspLJMj6m+z8La/NUw+kn2A44QWlaVU2+bpsCMDyHlMLRxsK+YxEiDKMsbBfgM0ZNNWcy4bD8QbPhBdk2F4jwGvKcob2mJwxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556527; c=relaxed/simple;
	bh=jp5Us49a39eTsVc7jBOkJwA4r+PWdGcpHqVRFHRvwxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFjt9x8DjJPTu9n9ECQ1XKUcGRvZ8xkE+Gk8NLE/DfCrysy/bYF+ifK3rXYmZCQ0DwwetM1N758Cedy0/lOUwP5UR9TZnoGq9K6BpxLBmLM+2rhd59/11O1zHgErbL/NTRHlXbLUfIyFdl29hOerqaZEtMWxUes+4yQPjUICT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zq7CqUco; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zq7CqUco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61BF1F000FF;
	Fri,  9 Oct 2026 14:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556525;
	bh=1GC2jVTfV4c3fiylw0AB/BLwTYwVPCpVxNCv3ndki6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zq7CqUcoXQiuuaSQLpdJ7GqOL5JIuY8gPF65qF4TEwravAuYM177G+1hdhn3aJzrH
	 TIigEirLL3c0oyv+g31uvKMWXSqYDRe2lqgfSrCRIa7tH0+M8swOYz4IV7n9pJ9hco
	 ex+NxQDOPDjWmHMCcMitSjfGNLXbbbzZz6wyzx3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 7.2 195/428] kgdboc: Fix tty driver reference leak in configure_kgdboc()
Date: Fri,  9 Oct 2026 16:08:52 +0200
Message-ID: <20261009140950.422377325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


