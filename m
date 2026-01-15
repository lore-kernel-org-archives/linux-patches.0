Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC1B3C1975;
	Thu, 15 Jan 2026 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498332; cv=none; b=TNYHZGBwedy0mEhmAOeGrxxt6GywskoeUIBujDvdmsYFwHcS/R09CDrdD8LNGXPZH7zxDjEcPE0GCJNwA2V7hpS8P6PvXC9gh/iaU8IqqcjTYV4JpAAgtrdGoOZjmDoSy8CxUITFSVyduCvcSBhoPrYc6uXk25HFn7qe2E1jDu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498332; c=relaxed/simple;
	bh=TQyB83BZawHCIKJCP0ISOSiebGPA3hizNON54bAHdHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYoN3DcXNivfN9SA7E2/vooXeR6fBsG/DFORlveVTcH3B1JNjsMHcL9qO8cAkDTtV6QNO8U9/VYRFpoB2RTCVrVHcQZGtqsdqBroJKH6Krm4AXF3x0LEf0EtLnf+Kg7SQuHHjzJPQRoSG9PCQ/xu0F6ViEoq7nAwhfWZpMVpDnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BO0ETR+f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BO0ETR+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811DBC116D0;
	Thu, 15 Jan 2026 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498331;
	bh=TQyB83BZawHCIKJCP0ISOSiebGPA3hizNON54bAHdHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BO0ETR+f0h0KvEiVnCpUY1G6zlysmyWD5o9DGviVad6OMWAWfkFFoKFkNw+MQBqm2
	 ADriYzzomu/XGlYK5OG28H5rmDF4i0agF57ZM3T/FniepIMKVhbN75YCn8WXm4chlL
	 19ycj6gbanXyor7sEHyqlmoD19S12W+xlwj+KMUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 395/554] media: cec: Fix debugfs leak on bus_register() failure
Date: Thu, 15 Jan 2026 17:47:41 +0100
Message-ID: <20260115164300.533459057@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

commit c43bcd2b2aa3c2ca9d2433c3990ecbc2c47d10eb upstream.

In cec_devnode_init(), the debugfs directory created with
debugfs_create_dir() is not removed if bus_register() fails.
This leaves a stale "cec" entry in debugfs and prevents
proper module reloading.

Fix this by removing the debugfs directory in the error path.

Fixes: a56960e8b406 ("[media] cec: add HDMI CEC framework (core)")
Cc: stable@vger.kernel.org
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/cec/core/cec-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/core/cec-core.c
+++ b/drivers/media/cec/core/cec-core.c
@@ -433,6 +433,7 @@ static int __init cec_devnode_init(void)
 
 	ret = bus_register(&cec_bus_type);
 	if (ret < 0) {
+		debugfs_remove_recursive(top_cec_dir);
 		unregister_chrdev_region(cec_dev_t, CEC_NUM_DEVICES);
 		pr_warn("cec: bus_register failed\n");
 		return -EIO;


