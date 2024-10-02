Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FFE1D0794;
	Wed,  2 Oct 2024 14:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880340; cv=none; b=OZmbL22GIjJfwKP7XzrDMVrZOO1iMVKIOHcrd5sVDj0XkcmdSzYRiJULSBZ3IDSiVmx0WI3jtafdiOIlzgomXtHzmHEatCCIGwDbPoIPCBi2vwvsUETittfPiTm5fY+vG960PmV3uGkZOpdgiEtVsWsMYeoqeyeHcSXitp556AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880340; c=relaxed/simple;
	bh=IFOfE3tlbkWssmSXddYKo0W32tAlxGqM2byWRMizScU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViwgkI+hKhzWZpf3xhMn3biDarauiUjPttY7ZXqLhLGq+2w/pCFgfNHkIIEoDl86w+DPDaABzUzv8QogbwQmdX9wdHEODYaEzOVstsPgAqI5b1e9l5vsEEoZtvi8PrR/pozoQDn5W9/MRKsNgaGgmnK80z5u0adMMI19E6moDqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pa4zJzZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pa4zJzZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE0CC4CEC2;
	Wed,  2 Oct 2024 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880340;
	bh=IFOfE3tlbkWssmSXddYKo0W32tAlxGqM2byWRMizScU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pa4zJzZyS3EPjLSS/xOgj8hKSDPHnbEpRCelu1u1faupDt/rfHS+UvkAaBwMyPb1r
	 op+apERppqHKrhsB4CT2VWWMitAXGaYx2NVGKPIfGkDUe6412RDt8xL4ag0alu5ayy
	 H8bGlKLr3R2YSGJh4nEL0OaOazrzkJcotNTMBY9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 425/538] scsi: sd: Fix off-by-one error in sd_read_block_characteristics()
Date: Wed,  2 Oct 2024 15:01:04 +0200
Message-ID: <20241002125809.212126446@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Martin Wilck <mwilck@suse.com>

commit f81eaf08385ddd474a2f41595a7757502870c0eb upstream.

Ff the device returns page 0xb1 with length 8 (happens with qemu v2.x, for
example), sd_read_block_characteristics() may attempt an out-of-bounds
memory access when accessing the zoned field at offset 8.

Fixes: 7fb019c46eee ("scsi: sd: Switch to using scsi_device VPD pages")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Wilck <mwilck@suse.com>
Link: https://lore.kernel.org/r/20240912134308.282824-1-mwilck@suse.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3118,7 +3118,7 @@ static void sd_read_block_characteristic
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb1);
 
-	if (!vpd || vpd->len < 8) {
+	if (!vpd || vpd->len <= 8) {
 		rcu_read_unlock();
 	        return;
 	}


