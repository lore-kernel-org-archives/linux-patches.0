Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E20C63C
	for <patches@lists.linux.dev>; Tue,  3 Oct 2023 00:34:33 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-692c02adeefso239955b3a.3
        for <patches@lists.linux.dev>; Mon, 02 Oct 2023 17:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696293273; x=1696898073; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kv8GuqsvKsi/EUYP1j3AWhIWAgjVOKJZXtPzqkrmwyA=;
        b=JUjKOy/H0I/cCGgdZjAuZHnQY3QJEd05swsE46GVimhjv1/DAlyj0s1tf3E+gr+VwG
         1ihyWjce/97533KQbmeNETXRkSeoCjF3TQgzgh+Z1uRZQBYY2p4zx8CF53HlovKpzw9U
         K1r3PbxKuDzeZgnViRUM5+mNWCP0dUKHMrIuo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696293273; x=1696898073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kv8GuqsvKsi/EUYP1j3AWhIWAgjVOKJZXtPzqkrmwyA=;
        b=KX1cxt8s2qATlATsxDCnoxm2gdhfWATKgYvgYzOzmdVo8BP3knZmB7mD+pxe1hCYTy
         kS4bDbAZbNSq3eFtK5+3M45SpRPf4FbstB2h0Q26A0kDZUWcCmh4dbEFphTsHuqBkWKD
         4tHMDbJ9lQsUMM/NXUX1bf5U5140A1SIV2Z5Cs3MAJywniuVjgKe4eKhY9fsj6uUUcj1
         GkXDvDEP2tpyNhPJEYko7cv0KKsZO7EWct+2CzKcxE8MIx6P/WTRE1P4YYPflW+JmG/o
         N7Z7qx24ivhb00b4DCVh/co5lNDQAOx807lZfKDTYpS99yCc5uEWGgmHdq5jcU6VheP1
         l4uQ==
X-Gm-Message-State: AOJu0YywUScMA5XcRhGD6e2s8IHDEO0rrFjqpyhy7x9siPzxaE72OsS0
	3iz1kXnv08OR4xl9ke0l0E3hqg==
X-Google-Smtp-Source: AGHT+IFmyY1Jz5vTG+gHqh7YJUJXUAwzo6atPGN8MYVl4TgNouohFY5Mk9dCNjzr0dbhxeAvEeGuow==
X-Received: by 2002:a05:6a00:392a:b0:693:42d2:cde0 with SMTP id fh42-20020a056a00392a00b0069342d2cde0mr11023259pfb.22.1696293273499;
        Mon, 02 Oct 2023 17:34:33 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:f676:8db:8677:aefe])
        by smtp.gmail.com with ESMTPSA id bm2-20020a056a00320200b0068a13b0b300sm101368pfb.11.2023.10.02.17.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Oct 2023 17:34:33 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	chrome-platform@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>
Subject: [PATCH 2/4] platform/chrome: cros_ec_typec: Use dev_err_probe() more
Date: Mon,  2 Oct 2023 17:34:26 -0700
Message-ID: <20231003003429.1378109-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
In-Reply-To: <20231003003429.1378109-1-swboyd@chromium.org>
References: <20231003003429.1378109-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's some debug prints here that can be upgraded to dev_err_probe()
so that we don't have to fish out the error messages when a true error
happens. If they're simply probe defers then the kernel will keep silent
but if they're true errors we'll see the errors in the logs.

Cc: Prashant Malani <pmalani@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/chrome/cros_ec_typec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
index 82e7d08b52c7..67000e4a8082 100644
--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -80,28 +80,28 @@ static int cros_typec_get_switch_handles(struct cros_typec_port *port,
 	port->mux = fwnode_typec_mux_get(fwnode);
 	if (IS_ERR(port->mux)) {
 		ret = PTR_ERR(port->mux);
-		dev_dbg(dev, "Mux handle not found: %d.\n", ret);
+		dev_err_probe(dev, ret, "Mux handle not found\n");
 		goto mux_err;
 	}
 
 	port->retimer = fwnode_typec_retimer_get(fwnode);
 	if (IS_ERR(port->retimer)) {
 		ret = PTR_ERR(port->retimer);
-		dev_dbg(dev, "Retimer handle not found: %d.\n", ret);
+		dev_err_probe(dev, ret, "Retimer handle not found\n");
 		goto retimer_sw_err;
 	}
 
 	port->ori_sw = fwnode_typec_switch_get(fwnode);
 	if (IS_ERR(port->ori_sw)) {
 		ret = PTR_ERR(port->ori_sw);
-		dev_dbg(dev, "Orientation switch handle not found: %d\n", ret);
+		dev_err_probe(dev, ret, "Orientation switch handle not found\n");
 		goto ori_sw_err;
 	}
 
 	port->role_sw = fwnode_usb_role_switch_get(fwnode);
 	if (IS_ERR(port->role_sw)) {
 		ret = PTR_ERR(port->role_sw);
-		dev_dbg(dev, "USB role switch handle not found: %d\n", ret);
+		dev_err_probe(dev, ret, "USB role switch handle not found\n");
 		goto role_sw_err;
 	}
 
-- 
https://chromeos.dev

