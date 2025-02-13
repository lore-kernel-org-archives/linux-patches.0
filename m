Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634C219C54B;
	Thu, 13 Feb 2025 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459123; cv=none; b=h8CCD6X1quqjgsdfu2VjBmouu3wWBsGF+ZaPVVr7iKq26uGGkDvSFH93QfrX+haM8/jE/N9tpspyiGpsdnI6G87QtaOYFZqML1+0z16snW6Zo9EbJ38KNCgSrdAKDhkjSYJTMnAvQXntFoKsjJsBspruFY65dKzabDUKpGzdJv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459123; c=relaxed/simple;
	bh=jc5oYu0Cffetk3r2xrlZjnBYoldtUfpqX2RQ8ULSRiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeOQqIqE2/ha0//48THQguGAqZU6YSfhD7dfECuwPFV8JcpuK7s5e6BRtrhrGs3Rd15NkZual8LFsSld/9jTlxYxHlx9QkFv5FAySWI+wybDJ01XNkyah/ByoULUOmdc2qpNgUNdFDMJ8gWcg+wMGtiEcbg1pVtqMy0iVUdlgT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k95Mhpwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k95Mhpwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC396C4CED1;
	Thu, 13 Feb 2025 15:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459123;
	bh=jc5oYu0Cffetk3r2xrlZjnBYoldtUfpqX2RQ8ULSRiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k95MhpwvkylfibmwXMZuho8lcXJxpvSWuaUa8Nk7iSysnaYGNWPMAFNc6pB8ZkJWJ
	 L4+Ul0HdkxZilwChpsPlAp1I5aMfKN9YDI6BpE1x2somVLRIP25aGTn1u0cpapMvoa
	 NW2MgUqZhUAnHaIZKv7H2+oCsM5b0ZZvHJ0r0HO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Radu Rendec <rrendec@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 6.13 142/443] cpufreq: fix using cpufreq-dt as module
Date: Thu, 13 Feb 2025 15:25:07 +0100
Message-ID: <20250213142446.079302795@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

commit f1f010c9d9c62c865d9f54e94075800ba764b4d9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/Kconfig              |    2 +-
 drivers/cpufreq/cpufreq-dt-platdev.c |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -232,7 +232,7 @@ config CPUFREQ_VIRT
 	  If in doubt, say N.
 
 config CPUFREQ_DT_PLATDEV
-	tristate "Generic DT based cpufreq platdev driver"
+	bool "Generic DT based cpufreq platdev driver"
 	depends on OF
 	help
 	  This adds a generic DT based cpufreq platdev driver for frequency
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -235,5 +235,3 @@ create_pdev:
 			       sizeof(struct cpufreq_dt_platform_data)));
 }
 core_initcall(cpufreq_dt_platdev_init);
-MODULE_DESCRIPTION("Generic DT based cpufreq platdev driver");
-MODULE_LICENSE("GPL");


