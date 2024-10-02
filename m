Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E591D0799;
	Wed,  2 Oct 2024 13:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876811; cv=none; b=MhGx5XBikGbNvr+8FvIGOWpB5t8vDq8uJfY8Vc33fp/zDX72H9+bQXckVdfk6sb7pKNhtScBYJSPu85P+UvSL1xo9S3AV5uG69vqKyAGyowBzngMEcjRcin/xnvyZH1UsfXRu6/LK3nMS/S9CUuYHzkvl8z4TC8rjq25ZXw6/xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876811; c=relaxed/simple;
	bh=joghncegTWccOZFg7v9OKZdf3czqNzzZTvSaV+UENXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGMKGRLwnmNomWIQWEf69D+QlfqLXjbHuIlAcQUPl2vlf8IeHEQqRXgYi2pPBp09tvgd9QR/JpQtiXW+lNgLmzax8e7BCicl2kceKVOcbr/kDkuWWXbdvu+tqAOUb1k9hVGEC6/F4EW6n8kzeNhiTNYmWFUByZaPCOR0h0LTYDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ep9EINqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ep9EINqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1112EC4CECD;
	Wed,  2 Oct 2024 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876811;
	bh=joghncegTWccOZFg7v9OKZdf3czqNzzZTvSaV+UENXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ep9EINqrs22pPBoJXlkm8qpYPHarxBQMYMvr4lNdTH7X5BqD18NiH3HTRHmoOGqK1
	 rbfyCFp8G2W4ho/REW9NNc1HKFmFab7g94xv75sFSIIFsFj0veKDa6HJIvCHyr374i
	 IWRbQHsfvc1CfU4uFm402dZ9DAzZ0IcXF6JhBte4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.11 570/695] scsi: sd: Fix off-by-one error in sd_read_block_characteristics()
Date: Wed,  2 Oct 2024 14:59:28 +0200
Message-ID: <20241002125845.260964001@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3404,7 +3404,7 @@ static void sd_read_block_characteristic
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb1);
 
-	if (!vpd || vpd->len < 8) {
+	if (!vpd || vpd->len <= 8) {
 		rcu_read_unlock();
 	        return;
 	}


