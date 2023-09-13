Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AF122EF4
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 21:27:30 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-68fac16ee5fso235833b3a.1
        for <patches@lists.linux.dev>; Wed, 13 Sep 2023 14:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1694640450; x=1695245250; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0FSXe6bNCBpdZi03aeP0wSp6h1r1vEv3fBGeHHeswAM=;
        b=YK/jkZ55YuwlZR1qEfCSHY/7OQu3Sx9tyhH0jDDSVLgQicTXYEYDQ/LcWQkiojkwHq
         8e2BfmPGi2jK8SiuIhd2cCQK0mHgWUa8ndUOvxwNlvwukdwbFF7pEiIqxveoE3QCe37X
         2QQRZLJ4dt8iCqWyoV6zcIy1TXBRbRRWuE82M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694640450; x=1695245250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0FSXe6bNCBpdZi03aeP0wSp6h1r1vEv3fBGeHHeswAM=;
        b=k9FFclZrCZZCFGfRBfivRbdB3z+iRuFvm9C3VCIRdQfD88W9OM7PvlWcSzF53k3B8u
         TG/BrIrtgSxKXyBOOQ8Zw1GJb55Jbkb2HoRyEXaZzcjI/RponVf0hEMCE21qrF7d4jU2
         h7oqJYzZSOD5F/go8dOjPnnqYJbuN5869FAth22G4hxobtQPLQYc1TevTD3KtA4inGrb
         6e1cD3f+M6vCJdq1mqEFRigmy0jQTrBYl3tvGrGTSr1TLFnnYMfraCq2LQF2cqjFPUr8
         TWyJ0OWAW2qboBwNRDB8TcqFOhI9Wbtp/4V8DUXs4P3WvFHsI8ESOje7PHa2udibUlpe
         NEcg==
X-Gm-Message-State: AOJu0YxTyThNO8JPa3lmd0bIEWk3xZ2i7X04GvyQASN/s+ei7fNjyoJ1
	UukJCm8QEQsf9bBtNIvnek0Afw==
X-Google-Smtp-Source: AGHT+IHrBsutj053PgCBAoa/lMn4hSREkeQcGtlYOD1ODQzI8J5LrpGMDWvF5QcJgJC4rleFbOHPXw==
X-Received: by 2002:a05:6a20:3d14:b0:152:8774:e1ab with SMTP id y20-20020a056a203d1400b001528774e1abmr4265873pzi.52.1694640449755;
        Wed, 13 Sep 2023 14:27:29 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:11a:201:ae97:c6dc:1d98:494f])
        by smtp.gmail.com with ESMTPSA id a10-20020a17090ad80a00b0025bdc3454c6sm1923976pjv.8.2023.09.13.14.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 14:27:29 -0700 (PDT)
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
Subject: [PATCH v4 3/4] platform/x86: intel_scu_ipc: Don't override scu in intel_scu_ipc_dev_simple_command()
Date: Wed, 13 Sep 2023 14:27:21 -0700
Message-ID: <20230913212723.3055315-4-swboyd@chromium.org>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
In-Reply-To: <20230913212723.3055315-1-swboyd@chromium.org>
References: <20230913212723.3055315-1-swboyd@chromium.org>
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
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Fixes: f57fa18583f5 ("platform/x86: intel_scu_ipc: Introduce new SCU IPC API")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 299c15312acb..3271f81a9c00 100644
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

