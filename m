Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BDF4CDEC;
	Mon, 14 Oct 2024 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918363; cv=none; b=P600P+Of69WLnJk6DkJKpn0yDCfSO8u9DYBssoS71oRQz8roZ94cHfT7u4sNA0EwO8OvjyH7srhLCL5XPsiPL59lR3+R5u2Ka1wXXC8stExtR+EPAK05qP7cqY/wwQ/zj+zHGrOd1UOpisEco4HFUrLdPUq8Is+P4sNo4q9Eu8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918363; c=relaxed/simple;
	bh=Z6qdDxrrf2h8CS7Iowl7E0rtX4boAzNBbTxiZkI+3QY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oseSLJLDgMFeG0KhWgqS4t3zuvX0mGXOi6C8ZPS/wf9ZLgV4bGWRTcc7xe5qNlIOcdguVqyFHHkMEFfaKto6datd39RqKRut/qRx+vMZBF99M9iH2/i5IvphsOoVSiCUsTtQLblks8B4CQM7gwCPf7mAwrJJswlS0iewIElMtNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzyLow6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzyLow6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6864C4CECF;
	Mon, 14 Oct 2024 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918363;
	bh=Z6qdDxrrf2h8CS7Iowl7E0rtX4boAzNBbTxiZkI+3QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzyLow6IKzs2WD8lFGLRcv4lmw/8vGdTPbqBi8FpF6OUnY+zHu7PfNGry0tb3SbmR
	 XY+8fe5JucLWXTuIiv33c65q7Y4T5JTw7uBLc0riZziCZoLegFQ9cNN/uvCJLnx153
	 Ihn6E8Gr1bzbpqHn0sgnF4jXPhZ6/wcGJZKRawek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 301/798] scsi: sd: Fix off-by-one error in sd_read_block_characteristics()
Date: Mon, 14 Oct 2024 16:14:15 +0200
Message-ID: <20241014141229.770869670@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -2998,7 +2998,7 @@ static void sd_read_block_characteristic
 	rcu_read_lock();
 	vpd = rcu_dereference(sdkp->device->vpd_pgb1);
 
-	if (!vpd || vpd->len < 8) {
+	if (!vpd || vpd->len <= 8) {
 		rcu_read_unlock();
 	        return;
 	}


