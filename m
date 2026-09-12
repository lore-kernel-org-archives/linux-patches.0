Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2073B3803CF;
	Sat, 12 Sep 2026 07:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197906; cv=none; b=WYVzvmNy7lOEm2YAB3s2wToT1W2ZrH0KIHOQ/pUIXP67WVHorJJ3DEzFHfaO1b4fZU5OYz87YTCdmA3nHhWAVpdFbPy8jHfMQA3vAzYblu740mBsKKIFH8p3kNnRkUhcqFhTb4PivIrA4i+Y9JYXi1tKaoiYZLtvt/TAWV00Lvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197906; c=relaxed/simple;
	bh=cefdChgu+Ipn08cN0wlvJTq9jC00SFZQE0m8JwGeNow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iglWA5A9qQh58AdmDNF39bbN0N8rS/toEhRuz95m/cDYH5gwQaHlBk+BcZnjDWiWiwizrancNK5kyCOd61HqM2kHASt6h3IIGG1qNWFLsTMf8AfXqzaD4byK8V/HWdXQuO4jt/833tBQAb1rIGTRFyA1TJ6eqYlIFZxN2t19fWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LaQFVoy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LaQFVoy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E719E1F00893;
	Sat, 12 Sep 2026 07:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197905;
	bh=q8hLx423S+fZvaQrlZlhs73jv131dEyzi1eu+gf3ia0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LaQFVoyd6eZtY1QVel6udbMyv2IGLw+kx5Cw4WT75btgGbFqCNPQia8xNdMhHjUz
	 sCfGKykze67k3gZ0MjJAMi4JFiAEwGMHzcNszCa+g/eerPZIbBzHj82F/07k9+gVcD
	 MAS7S2zCysp2kxZkQBgFHYPC3Ye57sxhp3Sv32XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0269/1815] staging: media: ipu7: fix pm_runtime refcount leak in ipu7_init_fw_code_region_by_sys()
Date: Sat, 12 Sep 2026 08:33:39 +0200
Message-ID: <20260912065655.285612926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

[ Upstream commit 843644e1c3347670498d247d7cd20dff1569181c ]

ipu7_init_fw_code_region_by_sys() calls pm_runtime_get_sync() before
accessing the firmware code region. If resuming the device fails,
pm_runtime_get_sync() leaves the runtime PM usage count incremented,
but the error path returns without dropping the reference.

Use pm_runtime_resume_and_get() instead, which balances the usage count
automatically on failure and avoids the leak.

The ipu6 driver uses pm_runtime_resume_and_get() in the equivalent
location.

Fixes: b7fe4c0019b1 ("media: staging/ipu7: add Intel IPU7 PCI device driver")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu7/ipu7.c b/drivers/staging/media/ipu7/ipu7.c
index 310e3f24e571f..056af3a075075 100644
--- a/drivers/staging/media/ipu7/ipu7.c
+++ b/drivers/staging/media/ipu7/ipu7.c
@@ -2343,7 +2343,7 @@ static int ipu7_init_fw_code_region_by_sys(struct ipu7_bus_device *sys,
 		return ret;
 	}
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to get runtime PM\n");
 		return ret;
-- 
2.53.0



