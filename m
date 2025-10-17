Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D08632E141;
	Fri, 17 Oct 2025 15:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713337; cv=none; b=upFodc62gVadgJGs00E5JHytfffpQPb+BINWIIICuqZXNrCOV3R4JmZoVmW19tt4M6urlm9MK1UdybOjxfx0MYJ2ldM0uKkKNuaFWkjPclQDe3VJLB3FsyIpmMs/+mWC7G7rke3EUyZZUhyZUSrMxvpFqBRuKJ4ZeZMvNtVbBEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713337; c=relaxed/simple;
	bh=87yihUqgUkUmXd6f25/iWeg/uesGiWhZAPja52s2HUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeY6qs/m7Ghd+mwwGUWyAjNOz+Xk/iHGJYx0jY6w2rhzDcqkXMfnxx2hzKCqON1fn102n6w+wcraCbni6ByiO1VTmfMWlJJGivNT3IgmWFJsP7ACplitpn6tdaIZ2nLoyDQygPad6VFNf9wal/yoeVR7JZPm9A45jerEui7MGJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7f9ijxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7f9ijxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D4EC4CEE7;
	Fri, 17 Oct 2025 15:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713337;
	bh=87yihUqgUkUmXd6f25/iWeg/uesGiWhZAPja52s2HUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7f9ijxn9ySuYjfou14te28u4+j3pD2EAoyy5h0Si9sCVM68PVm0cW1m2V8euv8r1
	 MtsBbz6i5d/OVqSKZDq3J2D0zac1hrPWSmVfpYnS/ATVVAGstkezd9jqnPvGWkTkcy
	 IoYjsJ+A2up17s8VzueiCm5O1X5vlYaXeDsxWol8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 097/168] scsi: hpsa: Fix potential memory leak in hpsa_big_passthru_ioctl()
Date: Fri, 17 Oct 2025 16:52:56 +0200
Message-ID: <20251017145132.600730894@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit b81296591c567b12d3873b05a37b975707959b94 upstream.

Replace kmalloc() followed by copy_from_user() with memdup_user() to fix
a memory leak that occurs when copy_from_user(buff[sg_used],,) fails and
the 'cleanup1:' path does not free the memory for 'buff[sg_used]'. Using
memdup_user() avoids this by freeing the memory internally.

Since memdup_user() already allocates memory, use kzalloc() in the else
branch instead of manually zeroing 'buff[sg_used]' using memset(0).

Cc: stable@vger.kernel.org
Fixes: edd163687ea5 ("[SCSI] hpsa: add driver for HP Smart Array controllers.")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hpsa.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6528,18 +6528,21 @@ static int hpsa_big_passthru_ioctl(struc
 	while (left) {
 		sz = (left > ioc->malloc_size) ? ioc->malloc_size : left;
 		buff_size[sg_used] = sz;
-		buff[sg_used] = kmalloc(sz, GFP_KERNEL);
-		if (buff[sg_used] == NULL) {
-			status = -ENOMEM;
-			goto cleanup1;
-		}
+
 		if (ioc->Request.Type.Direction & XFER_WRITE) {
-			if (copy_from_user(buff[sg_used], data_ptr, sz)) {
-				status = -EFAULT;
+			buff[sg_used] = memdup_user(data_ptr, sz);
+			if (IS_ERR(buff[sg_used])) {
+				status = PTR_ERR(buff[sg_used]);
+				goto cleanup1;
+			}
+		} else {
+			buff[sg_used] = kzalloc(sz, GFP_KERNEL);
+			if (!buff[sg_used]) {
+				status = -ENOMEM;
 				goto cleanup1;
 			}
-		} else
-			memset(buff[sg_used], 0, sz);
+		}
+
 		left -= sz;
 		data_ptr += sz;
 		sg_used++;


