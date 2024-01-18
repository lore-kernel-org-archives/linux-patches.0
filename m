Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FBA1B96D;
	Thu, 18 Jan 2024 10:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575251; cv=none; b=nhJKwvDfFDoPXSTZgb+VRDodEYCMSWcsPZoPCizB/Z1fPI5JL+2IczT6Yt9HfKq1ruEKYNUSFE73HZ2yU0NMLHsfRYE2385UJgtVA5KoGmpbpxqJdILKQChwI4oW42cd6MR5kb2Rz6PQTddSsjQ6mFa8HWMg4f2rBKyi6Rk2a2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575251; c=relaxed/simple;
	bh=8hlBKuEbsTBw8XGsS+yQ/bcKjL1YN/zPwhzjjTFIwnM=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=jlXbsl8WziUqY6P+oBl1Gt6HNQo8b9CpuV24LmSFfUjBdHMxE0UzlhmIDlOvzcy50JY+tb+QLuzHGUgPGgfEzFZ9P9Zxq5k9BnVQz2BMmyjUfli7b9H/ifpA6oteEcyytdr6ycT1qn4mQJQV+eeFHknvLQt2QV2rm9Jo50THFUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTd4r2uO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTd4r2uO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A72BC433C7;
	Thu, 18 Jan 2024 10:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575251;
	bh=8hlBKuEbsTBw8XGsS+yQ/bcKjL1YN/zPwhzjjTFIwnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTd4r2uOCn2IujMbWWyFac8Ke10ikPU/qmzAHKSwsWfZZ8GNGVJxmveSrUOVNeJsH
	 WA1cwfluPTbgcE7bIVsc0PdNi9LHR6rNz/8WGs1k5ooQ9HbkFqlvPH9P8v8R+Mi6NO
	 FXav2D61wtdLk7dzameMDmYXNeB7DecqbCCBAC2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/150] hwtracing: hisi_ptt: Dont try to attach a task
Date: Thu, 18 Jan 2024 11:47:29 +0100
Message-ID: <20240118104321.333388412@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit aff787f64ad7cbb54614b51b82c682fe06411ef3 ]

PTT is an uncore PMU and shouldn't be attached to any task. Block
the usage in pmu::event_init().

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231010084731.30450-5-yangyicong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/ptt/hisi_ptt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwtracing/ptt/hisi_ptt.c b/drivers/hwtracing/ptt/hisi_ptt.c
index dbed4fd4e296..a991ecb7515a 100644
--- a/drivers/hwtracing/ptt/hisi_ptt.c
+++ b/drivers/hwtracing/ptt/hisi_ptt.c
@@ -1000,6 +1000,9 @@ static int hisi_ptt_pmu_event_init(struct perf_event *event)
 		return -EOPNOTSUPP;
 	}
 
+	if (event->attach_state & PERF_ATTACH_TASK)
+		return -EOPNOTSUPP;
+
 	if (event->attr.type != hisi_ptt->hisi_ptt_pmu.type)
 		return -ENOENT;
 
-- 
2.43.0



