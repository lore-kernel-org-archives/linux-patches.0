Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C09034FF79;
	Tue, 16 Jun 2026 18:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634784; cv=none; b=MytnMLXC9Zel7uupmQrcdLROVecWcHz2MVDlv6GwnjAhdwLqsOFuKugKaHLXDE6mtyKz+kPLal66qoczfkSMEYZFDCG3laXvFpQ9I+wP3dpP/iQ5Ssj0NHqXk9dkOrlAUdwQCWyatsEthi2vxBqV+J+LTrb/e2NLp72V8yv+M8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634784; c=relaxed/simple;
	bh=Fgby+aQfbPhW0Hwpivj+bIyURb2mWKNs2/IaZVzvoKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5JuniNNB1Zi00pxT1arFEOSJvVTwgcpxVy1ZYTacadcmqhJQKGMNaSCvQtcSthhhnQQwkmgDFVzETwsMthQlSwrQ+jqeXu9GDBfFxbocMpOmDNIwoHOUItIx9/GbE+rKGYRBTURI7y+HXGAZBlhoXz+fbI9TtfBy4XXFVAigkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1c06QBXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1c06QBXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BBE1F000E9;
	Tue, 16 Jun 2026 18:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634783;
	bh=4ZJo4eaPX9PbBT0d6L+qMdynhTxuQh+VpjNaPcQebU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1c06QBXlJO1MI07qMrqBue+BTAxJ4FeQhjyoYKFmTQTtrwKhOYifjgrQQvGlgB0vy
	 gTUtWdWph688p/z631DfUEPXLt4Sb4cf5e9v31MXx+Jl0NF2VR43/TF2ICHiAacRJt
	 tDU/vm+0zwtyUk2GiageyURMDsVCoeWgtjZ0OLHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/411] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
Date: Tue, 16 Jun 2026 20:28:56 +0530
Message-ID: <20260616145116.994273908@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit 1e111c4b3a726df1254670a5cc4868cedb946d37 ]

If device_add(&sdkp->disk_dev) fails, put_device() runs
scsi_disk_release(), which frees the scsi_disk but leaves the gendisk
referenced. The device_add_disk() error path in sd_probe() calls
put_disk(gd); call put_disk(gd) here to mirror that cleanup.

Fixes: 265dfe8ebbab ("scsi: sd: Free scsi_disk device via put_device()")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20260330014952.152776-1-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3420,6 +3420,7 @@ static int sd_probe(struct device *dev)
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
 		put_device(&sdkp->disk_dev);
+		put_disk(gd);
 		goto out;
 	}
 


