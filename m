Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E74B281353;
	Thu, 13 Feb 2025 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457330; cv=none; b=P893dYUhCacqRM1rXRpWywIdLfKJebdIb+EN6OmK5ajXlsGQOOn30ecrkDVxwqMq+hu4R+SbWzMQ6xYc2BvKg7PShrvTAZGlLX9koerqzXJ/nwHqXqQiwMy6isj53KVgyzd0s5AZbCG2WzTq7g4lx6WQDG1RrrzH0kInGzJxmno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457330; c=relaxed/simple;
	bh=VX4EcunK/uITKQQpuIohMPsEQAG8YnhLXMqpow89iWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EoH0AYsvvifxc4gOUxnKJAEknPK96F5pBf2icXCUmVQeUvJGhNP0Pp1we9yYcXkyImDomjWHMiNvXjvYonN+ykQcEkxr7k+8NqFbpe7rPnZ+N6eENc+fC6S8P0vSc6nJ7DT60InreMh6l+d0BFe0IsyJTARA30irzcfcUp4axFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/yRnO8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/yRnO8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC71C4CED1;
	Thu, 13 Feb 2025 14:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457330;
	bh=VX4EcunK/uITKQQpuIohMPsEQAG8YnhLXMqpow89iWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/yRnO8Zi6lqLk7z1AwIb7dCp4jwpyNzuIgNtN+2e+bQdaEuodwgM42JN8XIb2/S7
	 UK3U5UJfLyptKUfbTXT/vaF0BnsBEV84cG3ZEVFsAC9Pw0oc3CkIca3lpnzH9D7j4J
	 vSkq+zRwrS3CN5EOKiPRxPuinKTVsXUDSLcmhjRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/422] platform/x86: int3472: Check for adev == NULL
Date: Thu, 13 Feb 2025 15:23:50 +0100
Message-ID: <20250213142439.679746445@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit cd2fd6eab480dfc247b737cf7a3d6b009c4d0f1c ]

Not all devices have an ACPI companion fwnode, so adev might be NULL. This
can e.g. (theoretically) happen when a user manually binds one of
the int3472 drivers to another i2c/platform device through sysfs.

Add a check for adev not being set and return -ENODEV in that case to
avoid a possible NULL pointer deref in skl_int3472_get_acpi_buffer().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241209220522.25288-1-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 3 +++
 drivers/platform/x86/intel/int3472/tps68470.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 3de463c3d13b8..15678508ee501 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -336,6 +336,9 @@ static int skl_int3472_discrete_probe(struct platform_device *pdev)
 	struct int3472_cldb cldb;
 	int ret;
 
+	if (!adev)
+		return -ENODEV;
+
 	ret = skl_int3472_fill_cldb(adev, &cldb);
 	if (ret) {
 		dev_err(&pdev->dev, "Couldn't fill CLDB structure\n");
diff --git a/drivers/platform/x86/intel/int3472/tps68470.c b/drivers/platform/x86/intel/int3472/tps68470.c
index 1e107fd49f828..81ac4c6919630 100644
--- a/drivers/platform/x86/intel/int3472/tps68470.c
+++ b/drivers/platform/x86/intel/int3472/tps68470.c
@@ -152,6 +152,9 @@ static int skl_int3472_tps68470_probe(struct i2c_client *client)
 	int ret;
 	int i;
 
+	if (!adev)
+		return -ENODEV;
+
 	n_consumers = skl_int3472_fill_clk_pdata(&client->dev, &clk_pdata);
 	if (n_consumers < 0)
 		return n_consumers;
-- 
2.39.5



