Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2702B847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:52:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92768C4339B;
	Fri, 10 Mar 2023 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456375;
	bh=z9Av7GPwa8suSv/7ygSdWHqXrR0LyMPHIQ7VukyEij8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpSNaMgjbY9EOY38xva/YUvO3S38ZuNA1mwmNBC/TIZVSWL0yG9v7+FdyRiwO3rIC
	 ktiY2ddBfn4q6JlUkfKt2Zc94NWffZjUnCo6LzOyXJVcJkNNVL5JX7/PMNUzbnxWwN
	 2ZJtrdx4E3kQ8nTpy9zau3wBEpUkOSWhe101dxpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 176/193] thermal: intel: quark_dts: fix error pointer dereference
Date: Fri, 10 Mar 2023 14:39:18 +0100
Message-Id: <20230310133716.967520349@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f1b930e740811d416de4d2074da48b6633a672c8 ]

If alloc_soc_dts() fails, then we can just return.  Trying to free
"soc_dts" will lead to an Oops.

Fixes: 8c1876939663 ("thermal: intel Quark SoC X1000 DTS thermal driver")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel_quark_dts_thermal.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/thermal/intel_quark_dts_thermal.c b/drivers/thermal/intel_quark_dts_thermal.c
index 5d33b350da1c6..ad92d8f0add19 100644
--- a/drivers/thermal/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel_quark_dts_thermal.c
@@ -440,22 +440,14 @@ MODULE_DEVICE_TABLE(x86cpu, qrk_thermal_ids);
 
 static int __init intel_quark_thermal_init(void)
 {
-	int err = 0;
-
 	if (!x86_match_cpu(qrk_thermal_ids) || !iosf_mbi_available())
 		return -ENODEV;
 
 	soc_dts = alloc_soc_dts();
-	if (IS_ERR(soc_dts)) {
-		err = PTR_ERR(soc_dts);
-		goto err_free;
-	}
+	if (IS_ERR(soc_dts))
+		return PTR_ERR(soc_dts);
 
 	return 0;
-
-err_free:
-	free_soc_dts(soc_dts);
-	return err;
 }
 
 static void __exit intel_quark_thermal_exit(void)
-- 
2.39.2



