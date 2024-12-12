Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A50223E71;
	Thu, 12 Dec 2024 16:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021120; cv=none; b=kDn9l75C8/sosvVzuq6R5rbaTXyfAiXsI1h5p97blNJ0dPjHM8ruXnLiQyjIpJNBlw+RT1S31/B19owNLmQlN6g8BEETMo75FWRhlwZMwiwsBNJeWlb92h4r76H/mpRh0ITI8Vg9jb/Bjs1PS/k/pHsFVXTLH66Sh76cGm4BL+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021120; c=relaxed/simple;
	bh=StcDWsG/Nl870v8NpMGovLk9zB6LcvZEFb77mg4zSOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tG/bdLrGYMec2wyBfcV6DOfkZRoqNSE2bXZyF3aHf2bmMJZdeDjR6kLcDpO5bzO+oi26peW/t8tPwtYkwkGaKDgo3SupO3e0rV8F+V4Hoyyhl1nA1wI1PJFv13XVG62wOBgCCZT36gxgMC5DZlIvNHYbiRMguCPsT1IPLALweeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3gnkRJe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3gnkRJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD99C4CECE;
	Thu, 12 Dec 2024 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021120;
	bh=StcDWsG/Nl870v8NpMGovLk9zB6LcvZEFb77mg4zSOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3gnkRJecf9WjaB96d1hFk/zFEqgVE8NqN5OV835ZGNiPg9m7larMwZOqDhqAlsfe
	 J+C3jFooEecc8RIM3f83190X2SCz+URFzpvYWoRSqBFWOaYcN36ArX9tAXy3ouf97G
	 6zNpcEwArqTjZ/dtW/fPwyJC5qAgPPFXgGS+3L+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwendal Grignou <gwendal@chromium.org>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 621/772] scsi: ufs: core: sysfs: Prevent div by zero
Date: Thu, 12 Dec 2024 15:59:26 +0100
Message-ID: <20241212144415.586604385@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -452,6 +452,9 @@ static ssize_t read_req_latency_avg_show
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[READ])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
 						 m->nr_req[READ]));
 }
@@ -519,6 +522,9 @@ static ssize_t write_req_latency_avg_sho
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[WRITE])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
 						 m->nr_req[WRITE]));
 }


