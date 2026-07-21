Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E4831F99C;
	Tue, 21 Jul 2026 15:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648723; cv=none; b=C9FZ9MKBa6O3sJ3jOhbpgbhMBMcOwQF9kRnQvVS8gYlrcBZJ5zRnfoSD2jUObab4+A8mTOEOKYARrkNnuR4A+5DtCGvG/Yk9wX7pUzuZD5h7KX5xRv+Zke6H/xjkTCY0PITdD7JIpyOaJjY+ZxLxq2/uD/rvwMRiDCZPqqFbsbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648723; c=relaxed/simple;
	bh=1GtBVF0e9XXvU0DJgjvryQRImvfBLv9GKrYMrOz5RRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDuV6xzqS6Phagk515EJWJ36YGfH3pbmVf3WiYuReb9uU0Ef3WkAdu51GXyXL0Tk1DopkBq6Jb3wLn+dlDtEu+7GuDruGY81uz5/bxOZxbY4klsfKWNvkxPIX2UlbCe18sjUu5Q0XtRUWJOz+hCHY3iGplmfWHqxJCwxY/x9H/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sbB0J/W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sbB0J/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173831F000E9;
	Tue, 21 Jul 2026 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648722;
	bh=Y+jaYMH8Sk8PHklMCB1aRqkImfXJ3AP2LuHw0PmtD64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sbB0J/WvIJRIcRSMBiXc8+c0CcF0r8TMUFUut9+IPD8db9MUzZlJ4XVqifhfvCJl
	 HG5rERV0O1fgSwQNE2gpscGw14Cf+vfAi5nbihHQOSPtU6COkXg/x0WtB+RZEQ1ctt
	 EHlr+/pB5j/7ApZvvdDxECC64RUMm5ixWApVumzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0306/2077] ACPI: PAD: Fix teardown ordering in acpi_pad_remove()
Date: Tue, 21 Jul 2026 16:59:39 +0200
Message-ID: <20260721152559.895467753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 5776575d9a7e50e77c45e0ab0271c000496f341d ]

The ACPI notify handler installed by acpi_pad_probe() needs to be
removed before calling acpi_pad_idle_cpus() in acpi_pad_remove()
so it doesn't schedule idle time injection on some CPUs again.

Fixes: 8e0af5141ab9 ("ACPI: create Processor Aggregator Device driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/2064153.usQuhbGJ8B@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_pad.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index ec94b09bb74716..bff702835cfebb 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -435,12 +435,12 @@ static int acpi_pad_probe(struct platform_device *pdev)
 
 static void acpi_pad_remove(struct platform_device *pdev)
 {
+	acpi_dev_remove_notify_handler(ACPI_COMPANION(&pdev->dev),
+				       ACPI_DEVICE_NOTIFY, acpi_pad_notify);
+
 	mutex_lock(&isolated_cpus_lock);
 	acpi_pad_idle_cpus(0);
 	mutex_unlock(&isolated_cpus_lock);
-
-	acpi_dev_remove_notify_handler(ACPI_COMPANION(&pdev->dev),
-				       ACPI_DEVICE_NOTIFY, acpi_pad_notify);
 }
 
 static const struct acpi_device_id pad_device_ids[] = {
-- 
2.53.0



