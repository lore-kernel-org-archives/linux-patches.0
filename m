Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9BF35F5F8;
	Sat, 12 Sep 2026 12:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216896; cv=none; b=UAE7GnV8nSB+WqMhdoqM0rgVusbipcoU+bOiHmKnWArQqNPM3c4q4wEWTEA2f9MKxDgkHmgZpB28TVt9jR6d42VjmK1Kv04VDcf4Tuv0fOjXCEKmNfQEMO+yOIECagaTQ9gC171D4d4DgwPZqCeD9KbXWeDABEBI3G/H5BKKxMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216896; c=relaxed/simple;
	bh=u0NHyaIyOQRchfIvRebmWN+2UjO78OwhLhbUOFkvKNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ni+X9KCPP7MtptJL+FJfZPnzIu4b5z/wfiL+MuO80bZrHtSfF2VtCjSjRUR2/HnlAaKZxT4TDIlDGAcyjYlrB5cyc/Dx9/mnv/aIm8WMXAEBF48FZNK4eCRih8usMQAkfp/e1b2KQOEkmrtaE0H2C+K61DtTQNgaRLj9JWQfds0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrx/zHMe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrx/zHMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE911F000FF;
	Sat, 12 Sep 2026 12:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216891;
	bh=5OeDObey2D96ceJSSR7oAYw1VPYWxBXb6dG9RDxUsro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrx/zHMeWtz8pO0Q7XTHdMlvkwfqG7c7UW4AhtS1WojGsDZVFY+JKMsPjjALEMQeX
	 L8mQejQ/x+h7mc6nx6VtKD+MSBvTlATkfevTvIROgpEe9bd5tpnap0M1XSsZ1epu/z
	 WaXYRO1xxZ2/Bp129V8veEylhc7ZUvc+RKPa4Q4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0827/1376] wifi: ath11k: fix leak in ath11k_service_ready_ext_event()
Date: Sat, 12 Sep 2026 08:54:13 +0200
Message-ID: <20260912065625.977155538@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

[ Upstream commit 0293be2212d319d59589082461abf2a9b626cd1c ]

Currently, during ath11k_service_ready_ext_event() processing,
svc_rdy_ext.mac_phy_caps can be allocated during TLV parsing. This is a
temporary allocation that is freed on the success path, but not on the
error path. If parsing succeeds far enough to allocate mac_phy_caps and
then fails on a later TLV, the allocation leaks. So free the allocation
on the error path.

Compile tested only.

Fixes: 5b90fc760db5 ("ath11k: fix wmi service ready ext tlv parsing")
Assisted-by: Claude:claude-sonnet-4-6
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260727-ath11k_service_ready_ext_event-memleak-v1-1-e8373d27bdd1@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 540faacee41d8..a184a7e3452c0 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5077,6 +5077,7 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 	return 0;
 
 err:
+	kfree(svc_rdy_ext.mac_phy_caps);
 	ath11k_wmi_free_dbring_caps(ab);
 	return ret;
 }
-- 
2.53.0



