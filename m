Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208619;
	b=K6V3vu1qToZgoWGmrSwKjQFYRdW8R/5/xrB/wEeh0+ke3HbLyDiPLW3M2goeDsd2+Zzp
	 7TIK5jMm9w1eamN+9coG/AWP1Aj5iD91I5M21yQXJdS1NsiRx3A0jTGh7prfPN/xv5cxZ
	 8px3nxMc7gv1NjWlpV3IkMguiO2QC2pYFgiXRjM1K3QYk3tvCXzJK0AtP9tqeHcl0dU/u
	 g06FU09fbb4AWDW7ReqEZZIR6fTpH5J8tzmpsjx9Sdj5MzXPN//WR08LEZBTTkJK2FfXQ
	 k1hAGFIaDewLKFw2XtzM3P8CFHXB0DYaLkjYYgFNoyZKf0JNPr9zlr1zLuLpnC9KxXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BzhS72adfVqKQp6zl4d2SgEuQQ9FbRP4mC+qYtrCHNI=;
	b=wc0scSlzVQZSy+1w817fuChM1bgWC0nRfLkQ6oRkv+MMhXu8Aw73Csr4uAPZCnlu0IbY
	 B+an4YdGcw1M96zIRqjh4kZ8yfXyzQ3ajngb9djyTSiELs4dqU2ZLIKKi9MtkjPrGMfoM
	 DJ7349f4jeaBngxcX3G+rDfctM9BzqimIjr3Vi4U4kuhH9LYn+MaXvkbrYlHQApaWkB/y
	 wWgCuhRpxWup0LblxpGvZNy+p5dO/JSK9RwSut98WtS2UFwon3S8SrUHvQD+9c6SFeeF/
	 OB9F9Aj1KWcy9TWscl6FpGPhREFeBQS78gcmjrzjV6Lg1irerzCCeb/yckmSRgU/DZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDsMpSE7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35136606A321;
	Wed, 28 Oct 2026 17:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDsMpSE7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856B41F031E4;
	Wed, 28 Oct 2026 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208619;
	bh=BzhS72adfVqKQp6zl4d2SgEuQQ9FbRP4mC+qYtrCHNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDsMpSE7aOIhpf2uo409jpr3ngz5S3Zvqq1XhZC7TUOECE6imljN0JtVPqIET5OR3
	 uvykt1/dwu0vvO6Z7+A0JURVlZMCoyf2K03b2Ku3m0vxtpI2m9EdAaKhID72qHqUdC
	 3qKjkSwm++dAEqIOjBD0onL4UL47Wvl042nkw8c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 5.10 181/516] kgdboc: Fix tty driver reference leak in configure_kgdboc()
Date: Wed, 28 Oct 2026 17:55:33 +0100
Message-ID: <20261028170007.792010280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


