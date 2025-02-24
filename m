Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FB012E5D;
	Mon, 24 Feb 2025 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407887; cv=none; b=AjjJWBtC73iziXF+gJQAQpQha9a07GfWxBWb25OS4ftbMIF4h3naE9MABeiicyw9HfsS9SsetHxIGr8yCjahFwbLoe4GbvwkIM9kNjWEt2F6rk0FXCHIS5sheooTbKkbGJQ/yh5FGhtq2hWW5oroLj+2gZQG6OVCkQcTu2dQqmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407887; c=relaxed/simple;
	bh=uomXlVVSdp/ErZNEcUWmEw8dHP437ThpY8GmuWFSBRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr9rNHvQxVAQjoEc0AdD9Nw2rPqI+DPbs1t05nDOmKQq+17vahyMOr3dBa22ma3dtLp+EVTpFJpKV/8uv6UWAIUc21KbraMTxsM1b0wM84MTKq++g/zkEcTzUWrTFCfqm6DTHdY7YvxgO1+s6oacKQOONYGHXrvJn1iYm9Q5SKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLDYacOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLDYacOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0981AC4CED6;
	Mon, 24 Feb 2025 14:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407885;
	bh=uomXlVVSdp/ErZNEcUWmEw8dHP437ThpY8GmuWFSBRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLDYacOLOMNKnbtXYaJ1WF81ro/frisTgEsIBYrdl6Xnw/++AwRU4dx3RBeyb7FE5
	 tpNiIo93KxatpR0GDGJSn1MBhtCuW4ljKr2vMGaiy60+nnDS841+exDmH4VtwDdslt
	 muVYbVvKfp+VmdqaSjGOxezSYWWZZcduGnjhcYxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Radu Rendec <rrendec@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/140] cpufreq: fix using cpufreq-dt as module
Date: Mon, 24 Feb 2025 15:33:57 +0100
Message-ID: <20250224142604.505270114@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit f1f010c9d9c62c865d9f54e94075800ba764b4d9 ]

This driver can be built as a module since commit 3b062a086984 ("cpufreq:
dt-platdev: Support building as module"), but unfortunately this caused
a regression because the cputfreq-dt-platdev.ko module does not autoload.

Usually, this is solved by just using the MODULE_DEVICE_TABLE() macro to
export all the device IDs as module aliases. But this driver is special
due how matches with devices and decides what platform supports.

There are two of_device_id lists, an allow list that are for CPU devices
that always match and a deny list that's for devices that must not match.

The driver registers a cpufreq-dt platform device for all the CPU device
nodes that either are in the allow list or contain an operating-points-v2
property and are not in the deny list.

Enforce builtin compile of cpufreq-dt-platdev to make autoload work.

Fixes: 3b062a086984 ("cpufreq: dt-platdev: Support building as module")
Link: https://lore.kernel.org/all/20241104201424.2a42efdd@akair/
Link: https://lore.kernel.org/all/20241119111918.1732531-1-javierm@redhat.com/
Cc: stable@vger.kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Reported-by: Radu Rendec <rrendec@redhat.com>
Reported-by: Javier Martinez Canillas <javierm@redhat.com>
[ Viresh: Picked commit log from Javier, updated tags ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig              | 2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index f429b9b37b76c..7e773c47a4fcd 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -218,7 +218,7 @@ config CPUFREQ_DT
 	  If in doubt, say N.
 
 config CPUFREQ_DT_PLATDEV
-	tristate "Generic DT based cpufreq platdev driver"
+	bool "Generic DT based cpufreq platdev driver"
 	depends on OF
 	help
 	  This adds a generic DT based cpufreq platdev driver for frequency
diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index 99c31837084c0..09becf14653b5 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -225,5 +225,3 @@ static int __init cpufreq_dt_platdev_init(void)
 			       sizeof(struct cpufreq_dt_platform_data)));
 }
 core_initcall(cpufreq_dt_platdev_init);
-MODULE_DESCRIPTION("Generic DT based cpufreq platdev driver");
-MODULE_LICENSE("GPL");
-- 
2.39.5



