Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B7C33710B;
	Fri, 17 Oct 2025 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713896; cv=none; b=fXuviy8Q07XNOwtXHwCPnxsJlyfwNrKreh3/rDq6KlI4CjRLOeE8n6B2YFfH6A7IpMZBaUiXnQsHor050JDh0C4uXuQZEY8gbA/XBfd+Ni0I5fNZDexzr3/uqSP6DTc6E44i7k3CmASVinqIXcr6g9dADApgFWLHJtaYfnUJ510=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713896; c=relaxed/simple;
	bh=Ff04YEs9R8NlLvkQUuyJ94H+D0BjW61oH2fEtnbO2yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTVp9IoynvgwNwYr/+m42vrFDGiFiFVweGAC3RgaMYBYwxI9xbcAhe0zMEj47EOPIn7Yaatbe4vCcLPDrsv7UwlRG7pTVfRMCcOQoUNjccScReTWw75U9JgUk01OrKnA4bycK7kfbKxdevMohYAReWGZwD4OrlDl9sAKuLuCt/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLj4V0Yk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLj4V0Yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA44C4CEFE;
	Fri, 17 Oct 2025 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713896;
	bh=Ff04YEs9R8NlLvkQUuyJ94H+D0BjW61oH2fEtnbO2yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLj4V0YkFcXlXUtnvkcVeT7vYO59w/1R3eLUTMUA1kQVtvph27NjNHKkaQpTgtfLs
	 fsLi+vYJec2FkSUxo9Q1oE1C/X26yK0RiO4AvsL7UuoAWlV5Q/bdklH/SlNui1JBKr
	 has7agqOYRMsjN7oiP+QwjWJ+vB+Xddy7cHUoxOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 114/201] scsi: hpsa: Fix potential memory leak in hpsa_big_passthru_ioctl()
Date: Fri, 17 Oct 2025 16:52:55 +0200
Message-ID: <20251017145138.932878469@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


