Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD3D2F12B8;
	Fri, 17 Oct 2025 15:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714484; cv=none; b=EThLLtXdZkovplsRMGgqUIig/b0m0lgb7lYNxiFB1i6nHXUBz4Yx10ln+d45pBywbkmf6/e1lS+TrzsWid/bCd/rPSuY0eFjVa/y8Q9hi9j2GMYoTIq/Cc6iTAH/tHsBfA8Ck8ZBbpUCZA2uTbtN+oSEnYbB6CwIdEgix75QvdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714484; c=relaxed/simple;
	bh=SAL2uPm3eoKuJAIJF3m+1dogv5n1eo3B3Hwm6szkgK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iq8/mJPGj0VnvB3NQ686jkXd+wdX5yQiDnrxkWvP/V6F0ug6eh7D6qkr7oY5RVKeM+o5dTLqGGDHtTlEJzFreyOVQujkriQ5Rka6JJ30CMZyS6x5R4X+6xS/3lK36sKKJ9fWq9GSK6dt8wnrXa4brL0zHfm4WTkTDjkwckuguMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuKSI6/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuKSI6/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD941C4CEE7;
	Fri, 17 Oct 2025 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714484;
	bh=SAL2uPm3eoKuJAIJF3m+1dogv5n1eo3B3Hwm6szkgK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuKSI6/Vciu5PBGlzIowPfiXFu/N3bfM0YsgkM4tlOw2xQeOl/izZeZK6Rnm/1U8j
	 25G7YFFc8l++Yjcx0jSkJwy6kw/LtBtypSAjo24p8esXVREkd1JXNLxsBIDHFwvj1M
	 /1i+8FOzElG0b/bPOJ8ENLJ+5TdFD8uIkoo88m3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 161/277] scsi: hpsa: Fix potential memory leak in hpsa_big_passthru_ioctl()
Date: Fri, 17 Oct 2025 16:52:48 +0200
Message-ID: <20251017145153.005516542@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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


