Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6468238910F;
	Thu, 30 Jul 2026 16:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427296; cv=none; b=UXsL9ZHiSdDuh/jypsyKHXgf2iY/ljKg7hCk5WHx9T0FVDHU00XqGMSlhMs00/SjVp/WQDVAWz3Vlk+b4bwaEsWl4kM4lZARxsSeu4LlcpCLcYPkWcpQQoK050725qZLSzd/iUZ2ICY/J7zi07VBvA4WV9902c2/LwrJdBniW9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427296; c=relaxed/simple;
	bh=yYEqshzNRyyNiFTHfShGCd6q+LYbLpJuNF+1wQxZEVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oyt7kOP03Qo2ZwuvXd0Y9nitKyozN8uYZkO53BidaWyCZ/9u77dWj8ivvLhBPjxYaCssM4wHMUrUMgaFNFh2j3HzBCk1a7oYERrQNqRXI+gDfKMMnCqvcu8GB6Gi8sp7mmucsslFbNBvbc1F9JTqFHtOVlxBJQ4gC+dPD1wxu5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNw9+3TM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNw9+3TM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D39A1F000E9;
	Thu, 30 Jul 2026 16:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427295;
	bh=yAoJk5kltHXCPPc1+NzQHjd7/5o2Mub3ZQYMCuOcLTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNw9+3TM9DgQNIcU7DzgU+EbGlrXrG1GT5nYeEZ5KwRcIPf1+87KJ1Qi2O7iZtWZz
	 UEzy7jP0PdvS75X+B8SVEpsdgpZAO3J6GzSNl/XpgYBXNBh0et7pmw5zXEtVIj+jvQ
	 v2+U7DE8N5dy2ebZuX1O4UpSR9NZQkpisgOQcngM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/484] hwmon: (nzxt-smart2) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:10:16 +0200
Message-ID: <20260730141426.045439373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7aa586eb74be15..0ce956954378dd 100644
--- a/drivers/hwmon/nzxt-smart2.c
+++ b/drivers/hwmon/nzxt-smart2.c
@@ -774,7 +774,7 @@ static int nzxt_smart2_hid_probe(struct hid_device *hdev,
 
 out_hw_close:
 	hid_hw_close(hdev);
-
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



