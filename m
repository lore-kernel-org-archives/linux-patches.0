Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D21255F28;
	Tue, 11 Nov 2025 01:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824891; cv=none; b=uifFtBBz1wXdAeaQirYCvWgOHbgvMQltKSAIYvuCLNMeIdoKY8LvbAKkRoUBBdNoeU0fDCaS08MNm1QIamZNzfmZbkqXvPAIZ9pZb+v6CY9/NKhhidx7sLr5koWVgv2Swo2xOZ1U71xMPXFV16FY1Uj+RbOotD168mauuh4dw+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824891; c=relaxed/simple;
	bh=UzYyebwdVQKYug4wnmv+0OA+B8bS+42N7UuCyp6BR0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSGlE/dREaN/Ei0bqcG2wCzLFvifhtOTATB716romck43re6shLEpoqpjVXABPBMCpe+Lt81aiYme1WvKL9GG3OAcw4ZVCjXLPHB3/vxhN8gfRcP/hTSHwQy0WRKhzqGsS7v2iqJlSJn1COEclhi87GtDyYy12VlCZHaSYG8SFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puvBHop/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puvBHop/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464A1C4CEFB;
	Tue, 11 Nov 2025 01:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824890;
	bh=UzYyebwdVQKYug4wnmv+0OA+B8bS+42N7UuCyp6BR0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puvBHop/gXqe2rkGOR0g/m5lmyrJasgsErumYzkJddE2XgEf9z7E8y1Sg9PE1rBl9
	 7PAbjAOXJyHxnSdhEnOdV3/t7wprVP1MQgvJ8metmyGQQtsQ+ytpwar7K0vckvsPnG
	 8A78MkL+7JRdnvWiQCEyiZBgyXZwmeHxCZNJB6Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 592/849] mei: make a local copy of client uuid in connect
Date: Tue, 11 Nov 2025 09:42:42 +0900
Message-ID: <20251111004550.737438948@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit bb29fc32ae56393269d8fe775159fd59e45682d1 ]

Connect ioctl has the same memory for in and out parameters.
Copy in parameter (client uuid) to the local stack to avoid it be
overwritten by out parameters fill.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250918130435.3327400-3-alexander.usyskin@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 8a149a15b8610..77e7b641b8e97 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -641,7 +641,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 	struct mei_cl *cl = file->private_data;
 	struct mei_connect_client_data conn;
 	struct mei_connect_client_data_vtag conn_vtag;
-	const uuid_le *cl_uuid;
+	uuid_le cl_uuid;
 	struct mei_client *props;
 	u8 vtag;
 	u32 notify_get, notify_req;
@@ -669,18 +669,18 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 			rets = -EFAULT;
 			goto out;
 		}
-		cl_uuid = &conn.in_client_uuid;
+		cl_uuid = conn.in_client_uuid;
 		props = &conn.out_client_properties;
 		vtag = 0;
 
-		rets = mei_vt_support_check(dev, cl_uuid);
+		rets = mei_vt_support_check(dev, &cl_uuid);
 		if (rets == -ENOTTY)
 			goto out;
 		if (!rets)
-			rets = mei_ioctl_connect_vtag(file, cl_uuid, props,
+			rets = mei_ioctl_connect_vtag(file, &cl_uuid, props,
 						      vtag);
 		else
-			rets = mei_ioctl_connect_client(file, cl_uuid, props);
+			rets = mei_ioctl_connect_client(file, &cl_uuid, props);
 		if (rets)
 			goto out;
 
@@ -702,14 +702,14 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 			goto out;
 		}
 
-		cl_uuid = &conn_vtag.connect.in_client_uuid;
+		cl_uuid = conn_vtag.connect.in_client_uuid;
 		props = &conn_vtag.out_client_properties;
 		vtag = conn_vtag.connect.vtag;
 
-		rets = mei_vt_support_check(dev, cl_uuid);
+		rets = mei_vt_support_check(dev, &cl_uuid);
 		if (rets == -EOPNOTSUPP)
 			cl_dbg(dev, cl, "FW Client %pUl does not support vtags\n",
-				cl_uuid);
+				&cl_uuid);
 		if (rets)
 			goto out;
 
@@ -719,7 +719,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 			goto out;
 		}
 
-		rets = mei_ioctl_connect_vtag(file, cl_uuid, props, vtag);
+		rets = mei_ioctl_connect_vtag(file, &cl_uuid, props, vtag);
 		if (rets)
 			goto out;
 
-- 
2.51.0



