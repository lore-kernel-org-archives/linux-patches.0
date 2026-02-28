Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AA6340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301057; cv=none; b=IUNZc+fjc2jmk2ztJztEr7fHwnHMPHJTjehAHzmPeZ5tLCp+ojp0jxWRLrxgUY5992DHKkyuQt2EXSG26lI3Ymh8Vsnrl9F0afvCv77NUPWy3L5wTu8rkrjO91kSHxwBjlHJHW0Rdfuk5l/KaWvPuX3U+BauMXEPuQduh6bkbDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301057; c=relaxed/simple;
	bh=e2nLUu8MmNd6l5CuMURTnwn6ibpsiDxSDRgNZmh8Gyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Psz2PoQrrN+rVPY4dAR5sU8yQ/g7KABZIvtrHcJOv0hYFZfW8J7DUauaHGuSNmmRrKeBLhm1l8SfH712NUi2zolg66qvqsCxvNtUVQbkM8fu52DOBVVZskg60+0E4EO3ifiLz/sejfzocrxV+Xy4fDOeDukChgstIRA7v9oi2Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RG0IywDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RG0IywDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3E0C19425;
	Sat, 28 Feb 2026 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301057;
	bh=e2nLUu8MmNd6l5CuMURTnwn6ibpsiDxSDRgNZmh8Gyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RG0IywDSF7PD25pNQU2TkUBjebC7xgXc8CnGjZROjAdhmXufno4NIX/HnZZubZSWc
	 mkIhLbBVN7UsMCulefxodTIJdCECSQRKSBSXeaNv0BuextwhJPxNVLGNFs4CPNYU0u
	 WTfnEV10x8yl2jZTONxgc0kVER5Edf1sE3zC2EFz9IpWeWGNiMTjvj4ERako3ctZVX
	 uT32A50EKXHNzKFUMDtn1egYFJBMmRYXvB7Zvs6FwM+BWB32DqFyapH7lg+1YqVfC8
	 9+PZS/+FVLtAJVZ629NNqN0PsXhy5r7Xd+c61/jnnWg+yI2qalGkTgx6a1A6uikUx3
	 5DNftKJ8qoYCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <gu_0233@qq.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 198/752] hwmon: (emc2305) Fix a resource leak in emc2305_of_parse_pwm_child
Date: Sat, 28 Feb 2026 12:38:29 -0500
Message-ID: <20260228174750.1542406-198-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <gu_0233@qq.com>

[ Upstream commit 2954ce672b7623478c1cfeb69e6a6e4042a3656e ]

When calling of_parse_phandle_with_args(), the caller is responsible
to call of_node_put() to release the reference of device node.
In emc2305_of_parse_pwm_child, it does not release the reference,
causing a resource leak.

Signed-off-by: Felix Gu <gu_0233@qq.com>
Link: https://lore.kernel.org/r/tencent_738BA80BBF28F3440301EEE6F9E470165105@qq.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/emc2305.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/emc2305.c b/drivers/hwmon/emc2305.c
index ceae96c07ac45..67e82021da210 100644
--- a/drivers/hwmon/emc2305.c
+++ b/drivers/hwmon/emc2305.c
@@ -578,6 +578,7 @@ static int emc2305_of_parse_pwm_child(struct device *dev,
 		data->pwm_output_mask |= EMC2305_OPEN_DRAIN << ch;
 	}
 
+	of_node_put(args.np);
 	return 0;
 }
 
-- 
2.51.0

