Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A893534B68F;
	Tue, 16 Dec 2025 11:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885730; cv=none; b=TvVA0mcfqE4C84FzDaiE7d9a/jOi/gpMK3YhzzHzYzlGbtqMnnCGvcAwOUfsrS0oSWscTnSpIgndEeAA9xXAvYu7Zt1v8IVvoP5QlCdI59X3M/ckr26El/MIjFjXAMucg0siQYuM9ffknfWbwcohwAaTqaqF6aKJTfPr2uK2oDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885730; c=relaxed/simple;
	bh=9pcNIg26ycquaPA15fMlnRPzB1UnkvJRXNQmIn4uyYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW+sZ8ngwmroHBUsnczckNdYY259L8XEYP8iQYDjNjoITOnFhAGcXiYa6yrgOW4fcEd9e8kzs6eNnHfl0UPjjz9TBGb3Unte3CTxR3JUyKvaYOVQIePC0VbMPHHLdLgy21L2rnE0nGzo6jXPwwOH1Pk0Y75djGzKJmO8VFBdi6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q32GM/vu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q32GM/vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1087BC4CEF1;
	Tue, 16 Dec 2025 11:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885730;
	bh=9pcNIg26ycquaPA15fMlnRPzB1UnkvJRXNQmIn4uyYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q32GM/vu95wgIuN7j7tQ9HXsZFeF5Z3qREqIrTjGtpcdUZercD3GmVKDbr5g+7myf
	 moC2HdT1WTpjsubVghrXm1zuQW4y7ItGm4Kmqc89pdbsDTrOZoU6jHEXg7AC8fFWHS
	 L+6lJzkDZdnbMJ3bCL3iB7mha0r3HFScY4TrulmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 227/507] scsi: sim710: Fix resource leak by adding missing ioport_unmap() calls
Date: Tue, 16 Dec 2025 12:11:08 +0100
Message-ID: <20251216111353.729314805@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit acd194d9b5bac419e04968ffa44351afabb50bac ]

The driver calls ioport_map() to map I/O ports in sim710_probe_common()
but never calls ioport_unmap() to release the mapping. This causes
resource leaks in both the error path when request_irq() fails and in
the normal device removal path via sim710_device_remove().

Add ioport_unmap() calls in the out_release error path and in
sim710_device_remove().

Fixes: 56fece20086e ("[PATCH] finally fix 53c700 to use the generic iomem infrastructure")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251029032555.1476-1-vulab@iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sim710.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index e519df68d603d..70c75ab1453a1 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -133,6 +133,7 @@ static int sim710_probe_common(struct device *dev, unsigned long base_addr,
  out_put_host:
 	scsi_host_put(host);
  out_release:
+	ioport_unmap(hostdata->base);
 	release_region(base_addr, 64);
  out_free:
 	kfree(hostdata);
@@ -148,6 +149,7 @@ static int sim710_device_remove(struct device *dev)
 
 	scsi_remove_host(host);
 	NCR_700_release(host);
+	ioport_unmap(hostdata->base);
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	release_region(host->base, 64);
-- 
2.51.0



