Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6CE2F7F09;
	Sat, 17 Oct 2026 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256477; cv=none; b=KtRzxQw0hmSKoTe4NuG96x2JyvUT9adXO1L/8NQ+2bxfqHMTogKjIevlRwxYRSUIQPnutuhlAAIgWHIzp1aETbc4TqHgb9ZYLwU8EzyI78SQVgmZG566Pha4ZXdTWuqVSz9NyGdvr266h7vzpG0Al3fz2o/egVg2E7W6eDsPfBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256477; c=relaxed/simple;
	bh=TWvliGNslw6cbnhZs/rgLmst3rUcShG9Tr9NiDWneqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QG9bglWS7RG/jjxdzigc0n/AjPY8N0+Klwmn3sx0rmZFLkhcyGJZlfYr9ye4v983SCSQrs5ekt3nUOPcGXArZDnrr1Lyk9bBe6MQ6GK0pYUOLAn5PLYKo5ZnTfl/QvNrpekG0QsX6x/lYNoIQcG5QZu0nFMK7SUL2Pd6zj6o+HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=koWrh0ss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koWrh0ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C2A1F000C4;
	Sat, 17 Oct 2026 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256476;
	bh=1TztK2DKscveJTn/cN7lizKuYRSdxJAj8z01Dqn/BMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koWrh0ss4FWyir1Gfz4MpdURCphp5aMO6+9rIOqwPxU3M1Yrfao9810Og7WD2kPf0
	 /aE0D18OylInTLefWdwmh513qp/yK55fiaixeWhORH7e1rCoGIVjTk66CC7pZrjpiO
	 Inz09HP6skAeynJldVaaU0vwuw3m/y6MIA7y0HKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.6 0247/1674] kgdboc: Fix tty driver reference leak in configure_kgdboc()
Date: Sat, 17 Oct 2026 17:41:59 +0200
Message-ID: <20261017160437.468418505@linuxfoundation.org>
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


