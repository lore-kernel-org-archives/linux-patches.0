Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC75E1D5141;
	Wed, 25 Feb 2026 01:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983518; cv=none; b=ktfRUYJMqOpdjfRVIqIuz/Ih7CrGVVAKTmUo9uVL05ENyeBxkpYDJ//5omY2FVSc03PnbMf83HaB0SCfGqkCJgOxUrV/cZ8pcs65COpxWMvZXAPSyJBV4E3nklstmqFeBkFFLBrdWLsBrUr6oagEirg77eSuvicN4E5JTEBE658=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983518; c=relaxed/simple;
	bh=2SyhXR6q+lOb2Aym7D1/157qvKQusLm94C3q/vvIQM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkQvmNNyc6KhdGjJ+MotpvSzYMxBedBjlEbyQ3FXEgq/tExrE75pXSaf09ETyYZPVd5MpxYFF8a9TP4AHmPy5iAaIWM5PSc0OSXeYP+/PX6/JcuVjDTHeOrKFodZTBnFBpOy3TYXfz+iiMj/oLCt3g5jdIRTOqmGVMHWnEC2NqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhGFdyFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhGFdyFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A17C116D0;
	Wed, 25 Feb 2026 01:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983518;
	bh=2SyhXR6q+lOb2Aym7D1/157qvKQusLm94C3q/vvIQM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhGFdyFV3RG+009oYkageaH5AjWxZ75UHfHljde1Scu3nzxcl6vw6p7mhSiFiZE4V
	 8GKLAHbCd8Emtd8OSSvyoKPFOQmWrQAeAMn2rpgoAUwLTEzW5m4joFSSQBp2RCbcFi
	 uFqfZlMH4maJGFqOrcf/I50LmZQXI307WD9a7Oyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 573/781] gpib: Fix error code in ni_usb_write_registers()
Date: Tue, 24 Feb 2026 17:21:22 -0800
Message-ID: <20260225012413.855501053@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 484e62252212c5b5fc62eaee5e4977143cb159c6 ]

If ni_usb_receive_bulk_msg() succeeds but without reading 16 bytes, then
the error code needs to be set.  The current code returns success.

Fixes: 4e127de14fa7 ("staging: gpib: Add National Instruments USB GPIB driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aSlMpbE4IrQuBGFS@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpib/ni_usb/ni_usb_gpib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpib/ni_usb/ni_usb_gpib.c b/drivers/gpib/ni_usb/ni_usb_gpib.c
index 1f8412de9fa32..fdcaa6c00bfea 100644
--- a/drivers/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/gpib/ni_usb/ni_usb_gpib.c
@@ -566,7 +566,7 @@ static int ni_usb_write_registers(struct ni_usb_priv *ni_priv,
 			retval, bytes_read);
 		ni_usb_dump_raw_block(in_data, bytes_read);
 		kfree(in_data);
-		return retval;
+		return retval ?: -EINVAL;
 	}
 
 	mutex_unlock(&ni_priv->addressed_transfer_lock);
-- 
2.51.0



