Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738E141DED0;
	Thu, 30 Jul 2026 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423851; cv=none; b=FmKT5dN030I5FnTyrPBCBWVbyAki9vpztETGAki39URF62iGTW2bjfhSGOGmqsSzZ09TF134IT1G/dcR//r+0nWAcgrZA9R7psLNyYQ7L6i2FeXsMhkrF9f8SfUOsCZfDGzYnIgdOTKqCOwZNv8MO5Ut8CZe02ovtT7Wgf8GAz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423851; c=relaxed/simple;
	bh=hwrp/yKnW9y9scf7FwVGWqQyq7kL3RD+MoznuUxRWfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRuOUBMicCPS5guozANSMsYFDBxcwzmIWb2y6zfLWOHyo+0NsmGPsYKxK6t6Ao4bZkcjXDK5lyYWzFWf+1w/Pf1iMMsPfJXp9PsEhvJQAgoeSzbS6CiRx1hXaG+T+/AydAb8v2RBwDyKCI2hBVFSmRQg9cKVb4RQzZ7m3GD7GT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eH2CdE7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eH2CdE7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75861F000E9;
	Thu, 30 Jul 2026 15:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423850;
	bh=4ibWP/qykiwAWlblFDSV51NgOjpGWwpVRgYQMYttVOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eH2CdE7u6Z9c1xFPpQIZsRo0tP+JE4XhRRWNo1p9NJLZF1tMGvmqBGStsxnobetNt
	 YA7G2KGafrpSgOrSDpWL1iLbuXTB0pyr02PwhOfWL0DkK4LTPYfBhJ5xVEZGmRyJ47
	 36sx7uPNQUfasDT+2GWCeFY2NIur3OxYiHrjUr2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/675] hwmon: (nzxt-smart2) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:08:21 +0200
Message-ID: <20260730141448.770887075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 59d104b54b0b42e30fd2a68d24ee5c49dcc54d1e ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 53e68c20aeb1e ("hwmon: add driver for NZXT RGB&Fan Controller/Smart Device v2")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nzxt-smart2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nzxt-smart2.c b/drivers/hwmon/nzxt-smart2.c
index 58ef9fa0184be4..e2316c46629d61 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -768,7 +768,7 @@ static int nzxt_smart2_hid_probe(struct hid_device *hdev,
 
 out_hw_close:
 	hid_hw_close(hdev);
-
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



