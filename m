Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5317EFBE0;
	Mon, 11 Dec 2023 18:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkE9vN4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6399C433C8;
	Mon, 11 Dec 2023 18:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319671;
	bh=F4xXdyqlr6TH5a1Eo/Fh7c+pkfslbp8qwgBrLQcTnTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkE9vN4QaS6uz12kCE5X+gsNjBAEF0KSlMIalat8pVhyzl3nXg8UzN2wFZ4SrI03b
	 vR0BX5ahb8h5iW/wLRC0Djmd2B6pzaM+PGc4mp+4CMTsk7GiT3Mq5bIS1zG9OeFzSM
	 RtX3VdweHCg59sBWepaHcH3t2s4IWkaEOGNkyM1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 191/244] hwtracing: hisi_ptt: Add dummy callback pmu::read()
Date: Mon, 11 Dec 2023 19:21:24 +0100
Message-ID: <20231211182054.512409866@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit 55e0a2fb0cb5ab7c9c99c1ad4d3e6954de8b73a0 ]

When start trace with perf option "-C $cpu" and immediately stop it
with SIGTERM or others, the perf core will invoke pmu::read() while
the driver doesn't implement it. Add a dummy pmu::read() to avoid
any issues.

Fixes: ff0de066b463 ("hwtracing: hisi_ptt: Add trace function support for HiSilicon PCIe Tune and Trace device")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231010084731.30450-6-yangyicong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/ptt/hisi_ptt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwtracing/ptt/hisi_ptt.c b/drivers/hwtracing/ptt/hisi_ptt.c
index 49ea1b0f74890..3045d1894b81b 100644
--- a/drivers/hwtracing/ptt/hisi_ptt.c
+++ b/drivers/hwtracing/ptt/hisi_ptt.c
@@ -1178,6 +1178,10 @@ static void hisi_ptt_pmu_del(struct perf_event *event, int flags)
 	hisi_ptt_pmu_stop(event, PERF_EF_UPDATE);
 }
 
+static void hisi_ptt_pmu_read(struct perf_event *event)
+{
+}
+
 static void hisi_ptt_remove_cpuhp_instance(void *hotplug_node)
 {
 	cpuhp_state_remove_instance_nocalls(hisi_ptt_pmu_online, hotplug_node);
@@ -1221,6 +1225,7 @@ static int hisi_ptt_register_pmu(struct hisi_ptt *hisi_ptt)
 		.stop		= hisi_ptt_pmu_stop,
 		.add		= hisi_ptt_pmu_add,
 		.del		= hisi_ptt_pmu_del,
+		.read		= hisi_ptt_pmu_read,
 	};
 
 	reg = readl(hisi_ptt->iobase + HISI_PTT_LOCATION);
-- 
2.42.0



