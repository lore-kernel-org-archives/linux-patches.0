Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257A22264A3;
	Fri,  4 Sep 2026 05:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500460; cv=none; b=iDvsQeN89moJaTMtGhknIr/CzucRRuzqWv/mbsOGZoWoz3splalTTQWdyHbISi4YYccAAxiVDrO9O8jlVuFtlxd2nn2v4Q1IiHaj40EC4Ze/HlcT/LEkFqIydSLe/RCgpUnAEUy1a7+5b/0brQR8I2q0XOf4oWWp++G5MFWsD9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500460; c=relaxed/simple;
	bh=N50MghqRJrympRJ4Mp58TzAYKvbSqMgti4D6uA/ZGgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4eMEf2PM0WockrSPnDt/xq3blu8VNmSs+AaXCd7EaAKc02zPus97worHiRs8asrHCfGnvfTWdIBGYQfiP+M1UzBoxeV538WR15uwkCDp84E1tlWOsJNg6dS0jyYEA8P4Ewr5VEigfKnunEscXGNp8DnvMjFY9wAlP1exHX/T3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq02PIJr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq02PIJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802B91F00A3D;
	Fri,  4 Sep 2026 05:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500459;
	bh=kHAPRCNu6p0Dvzsnr6bURTaT9LXVcqQj6MQ0jNJVqnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lq02PIJrcPmlZtubhgYLnkXEyZLGiWycaxpFds34aiD67tmVzO1lhrZ0IzUAinSk3
	 KcVPGWyurOkkMU3cWelGAUtMWZtjt6QyVSAXefIxvavsGhpturPZ6z4e8nFvo/F+qX
	 1PHSf10JWpvefaOqE75TXvtIFyXl7Xf7oizjIy1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	Nikhil Agarwal <Nikhil.agarwal@amd.com>,
	Nipun Gupta <nipun.gupta@amd.com>
Subject: [PATCH 6.18 063/552] cdx: Fix double free when sysfs file creation fails
Date: Fri,  4 Sep 2026 06:53:40 +0200
Message-ID: <20260904045749.276461440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

commit 6f4acc3a3c300e174e3f586b97b04ed8f5948c36 upstream.

In cdx_create_res_attr(), if sysfs_create_bin_file() fails, the code
frees res_attr but doesn't set cdx_dev->res_attr[num] to NULL. This
leaves a dangling pointer in the array. Then cdx_destroy_res_attr()
frees the already-freed memory. Fix the double free by initializing
cdx_dev->res_attr[num] after sysfs_create_bin_file() completes.

Fixes: aeda33ab8160 ("cdx: create sysfs bin files for cdx resources")
Cc: stable@vger.kernel.org
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Acked-by: Nikhil Agarwal <Nikhil.agarwal@amd.com>
Acked-by: Nipun Gupta <nipun.gupta@amd.com>
Link: https://patch.msgid.link/20260724092712.2119149-1-ptsm@linux.microsoft.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdx/cdx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/cdx/cdx.c
+++ b/drivers/cdx/cdx.c
@@ -745,7 +745,6 @@ static int cdx_create_res_attr(struct cd
 
 	sysfs_bin_attr_init(res_attr);
 
-	cdx_dev->res_attr[num] = res_attr;
 	sprintf(res_attr_name, "resource%d", num);
 
 	res_attr->mmap = cdx_mmap_resource;
@@ -754,8 +753,12 @@ static int cdx_create_res_attr(struct cd
 	res_attr->size = cdx_resource_len(cdx_dev, num);
 	res_attr->private = (void *)(unsigned long)num;
 	ret = sysfs_create_bin_file(&cdx_dev->dev.kobj, res_attr);
-	if (ret)
+	if (ret) {
 		kfree(res_attr);
+		return ret;
+	}
+
+	cdx_dev->res_attr[num] = res_attr;
 
 	return ret;
 }


