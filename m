Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8493D966A;
	Tue, 12 May 2026 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607826; cv=none; b=fYCZdCUuuw62KuLcJz08DloaCQSnGy1zJwwPQA9SmeuGVmXooCKDqpRMTCKj8s2CRT0nS3tpfwwg2R2WiyjSw4oLgrhVU/ORf4CIn0j9QvP6KT/zKrBPqXwNJZSA/HUlQELTrcdDLzEBwKImgRVh+ZgobjjIRxSiK9/nggn0vTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607826; c=relaxed/simple;
	bh=4WcwqHkNqtrcOoyzBE2cOcATZijTMqnodxWA2Skln3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSKSPPK7P0QpZ3E96NLrgLv+mqTSJcZzQwWrsIfsinFpdo8umqVyFx9LKFgxIjAC91iC7S27NcZQRiCBlDPUiBqs9zjJHt5bzv1/m0J+J8RPfIoDV9syHEIoT+SAt76vaTgZa+TYGzFgSfsWOrreOWH2jBP1toaZhWu/gx5jr4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnTMCM4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnTMCM4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97BBC2BCB0;
	Tue, 12 May 2026 17:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607826;
	bh=4WcwqHkNqtrcOoyzBE2cOcATZijTMqnodxWA2Skln3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnTMCM4/YirDVTsRq1/x9BaiMObJHfK6QUsXbqNtrb5Bf8l/Mvgvd7uvr4J7qPcsc
	 lIXyXv03ZAtAh/vQbtodGi6TdXxkY4uBzU6A/qCMdmhznf5auzdRl7bbzgsd/yvvFm
	 +r1a7hjytaHcLuYtulVI4UavAuD4YCZbNR5/+8Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 049/206] usb: ulpi: fix memory leak on ulpi_register() error paths
Date: Tue, 12 May 2026 19:38:21 +0200
Message-ID: <20260512173933.875738624@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 0b9fcab1b8608d429e5f239afb197de928d4de7d upstream.

Commit 01af542392b5 ("usb: ulpi: fix double free in
ulpi_register_interface() error path") removed kfree(ulpi) from
ulpi_register_interface() to fix a double-free when device_register()
fails.

But when ulpi_of_register() or ulpi_read_id() fail before
device_register() is called, the ulpi allocation is leaked.

Add kfree(ulpi) on both error paths to properly clean up the allocation.

Fixes: 01af542392b5 ("usb: ulpi: fix double free in ulpi_register_interface() error path")
Cc: stable <stable@kernel.org>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260407-ulpi-v1-1-f3fafe53f7b2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/common/ulpi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -286,12 +286,15 @@ static int ulpi_register(struct device *
 	ACPI_COMPANION_SET(&ulpi->dev, ACPI_COMPANION(dev));
 
 	ret = ulpi_of_register(ulpi);
-	if (ret)
+	if (ret) {
+		kfree(ulpi);
 		return ret;
+	}
 
 	ret = ulpi_read_id(ulpi);
 	if (ret) {
 		of_node_put(ulpi->dev.of_node);
+		kfree(ulpi);
 		return ret;
 	}
 


