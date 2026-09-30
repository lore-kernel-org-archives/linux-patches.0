Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A67518132;
	Wed, 30 Sep 2026 17:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787764; cv=none; b=aKSRos0jfzhGONxYAhcDro6FOiRdB2YVrCv/dUMxOUxGNo78EgzUWV8IA++K66Fi5eqZhQ28XGWvfuFbd3LaJ+nlpnMvpSsbtF90eP3zBW/GwaJwoqdfRpzzc/srRc/enu9tCPHRmKierHaqCHVdhecIirXWKcTVNs+MdQfZpnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787764; c=relaxed/simple;
	bh=AWONSKLAd6WqSr+2CN11EfQ4ujQOEWRlqPKxalGSfOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGJIv8vDfr+xKqj1FVv8cDwq3Wgmiq8n9jEju+PxQvPapnquiWZvDN5BAX4ulLhzkzU2zPoTkn/eaWLWduhU+d7ogNjQ1XLD8Ae2R8IANIuClWGCf760SzL9fzXBugGquKGMOIqzblyTfaPRVViA9hHMo/e2Hil6a0MBt/oOvJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BlrzVE9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BlrzVE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07AD1F000FF;
	Wed, 30 Sep 2026 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787763;
	bh=Y7sjjSzw8xeumezqNy8Ll0Auzr5h7rosZEnb6y9GYis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0BlrzVE9ugSBao0HoO4riVITT7ex+fM2CllyAnywmOwoD2AFgncpY6XQMkZ/WjJve
	 L1lCT2La40d3EFjNrPuqFptYxX+kRMT1vHH0C7jBLOQYjCIPZY0xTll5CwPjwRs6eP
	 Zev4E8lVYWE2pYiDO+A36oK2JT/P5ZaoMppP22x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 343/457] net: ena: fix PHC cleanup on probe failure
Date: Wed, 30 Sep 2026 17:27:28 +0200
Message-ID: <20260930152353.417495886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 0958ea4355e2e9220ad4e13da3b7d94f365ed34f upstream.

ena_probe() initializes the PHC as part of ena_device_init(), but the
probe failure path does not destroy it before freeing the PHC private
data.

The normal removal path calls ena_phc_destroy() through
ena_destroy_device() before ena_phc_free(). However, if probe fails
after ena_device_init() succeeds, the error path reaches ena_phc_free()
without unregistering the PTP clock or destroying the device PHC
resources.

Call ena_phc_destroy() in the probe error path before freeing the PHC
private data.

This issue was found by manual code inspection.

Cc: stable@vger.kernel.org tags and describe this as a consistency cleanup
Fixes: e0ea34158ee8 ("net: ena: Add PHC support in the ENA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: stable
Link: https://patch.msgid.link/20260921154202.471662-2-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4126,6 +4126,7 @@ err_worker_destroy:
 err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
+	ena_phc_destroy(adapter);
 ena_devlink_destroy:
 	ena_devlink_free(devlink);
 err_metrics_destroy:


