Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9037015AC2
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 19:39:45 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c0d5b16aacso39412015ad.1
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 12:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694461185; x=1695065985; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZS9exdhsXGWlwAB3PPHAHPTpMkYjkQ66zHV37ZNnIo=;
        b=GShbjDqfYq33HsbhaYq9ieQiNlDP3XIgBVioaV0Y+czfxy9nYrLq3Yub0MxXEukb89
         irwXKsiUFo5Ur1mhqh1eCXREsRyMlkgZez+OXqJUY6vWmLyiYqDD6gQ1/S2qPdNaxUDw
         D8Pe+qOg3D2hV9GWzQGGSyo/bXGmsgZyr/JMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694461185; x=1695065985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iZS9exdhsXGWlwAB3PPHAHPTpMkYjkQ66zHV37ZNnIo=;
        b=v3ROyGHaVKM3V+LsaIs51inpTOdw9b5aItyoODAA7i5NkkLlzO8TJD9+eRPFfEV7iy
         eriw8QUL9VfneySeMjQgff4e6xbkVbxGMzZoQ64a36S4S+HE1Vzt5P6dnUFefV6e/1Bn
         vGqqZRoaSHRXHAq6RCKW3oAM7/Pq+qCjugSwoAndrwkYYp6hE3q4P+bMGAgX+BHLJQCI
         TLZ3H4ulMtyP23mfG5/CM3GQmCEdmrzfZidV0EERXfBBc7XQaFZIczP85z/vlQExU/3O
         Zs6aVVJBZRO2CgxBQm+WIHcRqi+FU2wO/GCFM7j5fZY+LdYHit9F7kTsurvOYMuDApq8
         QE/w==
X-Gm-Message-State: AOJu0YzkyFTUr9eXUuA1buRSXvOBwxDA0E4Q4fPz53z5SnzZHK7k3lhq
	C5ECuz7RhCdjCcWjTsrMX2fNOA==
X-Google-Smtp-Source: AGHT+IE7TogpeCC/K5uuUl78NkURxmB6xAcGOF09QSqED+BJ2qE4ZV0Dxs2vBHRHl4QM+fNIhII6jQ==
X-Received: by 2002:a17:90b:164e:b0:268:10a3:cea8 with SMTP id il14-20020a17090b164e00b0026810a3cea8mr8146677pjb.9.1694461184937;
        Mon, 11 Sep 2023 12:39:44 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:d487:5e33:6656:3711])
        by smtp.gmail.com with ESMTPSA id fu8-20020a17090ad18800b00262e485156esm7736543pjb.57.2023.09.11.12.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 12:39:44 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Gross <markgross@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>
Subject: [PATCH v3 3/4] platform/x86: intel_scu_ipc: Don't override scu in intel_scu_ipc_dev_simple_command()
Date: Mon, 11 Sep 2023 12:39:35 -0700
Message-ID: <20230911193937.302552-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230911193937.302552-1-swboyd@chromium.org>
References: <20230911193937.302552-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Andy discovered this bug during patch review. The 'scu' argument to this
function shouldn't be overridden by the function itself. It doesn't make
any sense. Looking at the commit history, we see that commit
f57fa18583f5 ("platform/x86: intel_scu_ipc: Introduce new SCU IPC API")
removed the setting of the scu to ipcdev in other functions, but not
this one. That was an oversight. Remove this line so that we stop
overriding the scu instance that is used by this function.

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/r/ZPjdZ3xNmBEBvNiS@smile.fi.intel.com
Cc: Prashant Malani <pmalani@chromium.org>
Fixes: f57fa18583f5 ("platform/x86: intel_scu_ipc: Introduce new SCU IPC API")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 8be1686e22e9..6958265db29d 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -443,7 +443,6 @@ int intel_scu_ipc_dev_simple_command(struct intel_scu_ipc_dev *scu, int cmd,
 		mutex_unlock(&ipclock);
 		return -ENODEV;
 	}
-	scu = ipcdev;
 	cmdval = sub << 12 | cmd;
 	ipc_command(scu, cmdval);
 	err = intel_scu_ipc_check_status(scu);
-- 
https://chromeos.dev

