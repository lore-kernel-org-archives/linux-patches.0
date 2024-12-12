Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5AD6F2FE;
	Thu, 12 Dec 2024 15:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017983; cv=none; b=TYu0ArjspneIu0ssm+44hNcoTalXEA2jApRb/9STE7sdCDzg5aEjkpSgrNX4rCQjBknhKM+yvwlN5SzEItKCgGElzaQIRU7MItJGGJZL64Bqd3ZHrGZjgv03LsG/ppgIcYhOlWpOKcGVMQhI1AkOweeNGvQgEADHrpT2rOzcPW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017983; c=relaxed/simple;
	bh=aeQZywb7YmM9ED57E/T/KDNgJlwPyu0jH4zks9kRUr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwzDx7+Wes2Iq2YEF99UZGH9BD/dJ6Gn0R4IGSLwmhrF8sS+k5/sdqNm3w3t1sKVe7wgqxx8aWRox+HaiYQTkr9/Ntj+u+L/ROo3hSUZGw0/Dc9CXyRG1RgPv56vgaqKauCVcMedUhGCGnMSe3rLSw3DUv/72uSLS76Qd5Mhw24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uG4U6bI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uG4U6bI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFD6C4CECE;
	Thu, 12 Dec 2024 15:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017982;
	bh=aeQZywb7YmM9ED57E/T/KDNgJlwPyu0jH4zks9kRUr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uG4U6bI/JB9lDIr6KTJDlaPrvlprUONckH7WBfYFePf9dMdTyeJIlf/mIkkfF27xI
	 +mdTbsEEErY2GsPl74SA0P8uLXBX6cd1DXSSXpjbB5JMhUbObtFpwY6fPReY01z5Oz
	 TLYzkincq9t3ge9jvUzCAx9hU1F28bUKRq9fe3gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 157/356] scsi: ufs: core: sysfs: Prevent div by zero
Date: Thu, 12 Dec 2024 15:57:56 +0100
Message-ID: <20241212144250.841202964@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Gwendal Grignou <gwendal@chromium.org>

commit eb48e9fc0028bed94a40a9352d065909f19e333c upstream.

Prevent a division by 0 when monitoring is not enabled.

Fixes: 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance monitor sysfs nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20241120062522.917157-1-gwendal@chromium.org
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufs-sysfs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -485,6 +485,9 @@ static ssize_t read_req_latency_avg_show
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[READ])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
 						 m->nr_req[READ]));
 }
@@ -552,6 +555,9 @@ static ssize_t write_req_latency_avg_sho
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[WRITE])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
 						 m->nr_req[WRITE]));
 }


