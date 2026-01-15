Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AFC2D73B4;
	Thu, 15 Jan 2026 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499007; cv=none; b=uPyyloP2F3TK3ezUOmhXBEeTKMvFncvaE9J0FKKUJbF96jcroLPqNxNVLaPuwnfMrVeRhrvGonKBOOpanGbTEFkyKqtyAJwgD4jMFlFhsjn9VzSnTria+93WL5umeLiiXAwJL2kJRqtuVok994HoXiuheEoP6ZVzr6bE8YhCuaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499007; c=relaxed/simple;
	bh=5eiVqiWLQ2102rJm71sGErBvWPwg3Ogmn+n4bML51p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XgBQ7O5r/U0vvnqFdQyBqrVPdreEeezTcLsXe36ylcMmRCRYe+8rUhWCSa34ZI0EyhRAVvctXPhpxdlong1RJ+O3QmoLpa71IcuMA0+9pDiCB0eW/U5TYcloKXVo37dHRKMOY4xvREFBV2ljD/XBt+tXdge47eSEmKtIg0hxLXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2bziiXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2bziiXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B453FC116D0;
	Thu, 15 Jan 2026 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499007;
	bh=5eiVqiWLQ2102rJm71sGErBvWPwg3Ogmn+n4bML51p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2bziiXGfKgByivuLVRpjUmR/TFJwhfrJGNwlbhELMIhP3dUp+SdSUXoCWKNi5ojQ
	 93hPwKVLJq3mrUf0ylCgGVBDw/A0x1zIACmFlRpoYeBki0doX0ZU9vV+dRSMnVrItl
	 jRM0wANh2tZL7VSVFDSTk0cLQQNJLLADP8HpYmNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/451] scsi: sim710: Fix resource leak by adding missing ioport_unmap() calls
Date: Thu, 15 Jan 2026 17:44:36 +0100
Message-ID: <20260115164233.616714591@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 22302612e032b..3c2a07bf92094 100644
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



