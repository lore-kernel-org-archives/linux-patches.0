Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA6624397A;
	Tue, 29 Apr 2025 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948652; cv=none; b=bFf3pZj20yueRp3Q/jtIS/AGWicOdsVQbo0mFXEdLCw1qIjtKmlEHwjFz/eBc2MF/xSQfNNesyJgSi3U8yqtu2vNdgfzOusm64UvFtwjxq1BvpSAlHBzLBOiDXFjGz5n74nCLdwIR04i4+7wc0SgtKjNM9z0UuTFG5ao4ce/MPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948652; c=relaxed/simple;
	bh=npYWyG8DbKFkaAv47UsiPDLGmJO11y1EH/5UUM995sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3p/MdYfs1HID69rvS9UXkEibcNUb9xoK2fIb2qbup23Z6EuhXmUTF64vnM4ki4OzcE7IVB7e3VZ5U3+TCi7vMNohbyhZnPQpX9thU6nEb7a0zKQzq6EZvrIxfrmoUeKpRb38BQQ4DQFI+u4rUryH9jKIpSOmWvG7ut6lWCab6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTNiW61p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTNiW61p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A60C4CEF5;
	Tue, 29 Apr 2025 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948652;
	bh=npYWyG8DbKFkaAv47UsiPDLGmJO11y1EH/5UUM995sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTNiW61pmlsxm3s5/dSUpM9OgsFCwajrDslBEO1DJqrrUUDStbueQf/4VvCrXuRRS
	 iKDNrTiTkbu6zt6+Z8FJ58PtIUkY95UA61nfoFRDxCK9rSymgrX6U119jjPvKGprmg
	 fb7lTt/BDlDb428+GnrfbvY5qV92dBeYMbsUzCD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 072/373] media: i2c: ccs: Set the devices runtime PM status correctly in remove
Date: Tue, 29 Apr 2025 18:39:09 +0200
Message-ID: <20250429161126.106565274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit e04604583095faf455b3490b004254a225fd60d4 upstream.

Set the device's runtime PM status to suspended in device removal only if
it wasn't suspended already.

Fixes: 9447082ae666 ("[media] smiapp: Implement power-on and power-off sequences without runtime PM")
Cc: stable@vger.kernel.org # for >= v5.15
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3677,9 +3677,10 @@ static int ccs_remove(struct i2c_client
 	v4l2_async_unregister_subdev(subdev);
 
 	pm_runtime_disable(&client->dev);
-	if (!pm_runtime_status_suspended(&client->dev))
+	if (!pm_runtime_status_suspended(&client->dev)) {
 		ccs_power_off(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 
 	for (i = 0; i < sensor->ssds_used; i++) {
 		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);


