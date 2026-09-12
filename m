Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED03719E7F7;
	Sat, 12 Sep 2026 08:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201222; cv=none; b=h6meQKA0d5QyLo4We81PZjLQ1sF4ZCwCYsGpOGDN0AvLhJhl8MESiz/bRTwEK2Ersc2v/9L0dZiAMusuU0NskP7k91i8ESeoUsqCETc5VDggHhvzPN1KKnfWeJJowkoNcnnJoJ0WeyxBwPorNDMmGAsMJPumwuFDTsTw1dSYjaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201222; c=relaxed/simple;
	bh=hMOwabw/pYvp4VDgVAgaDyfoD0+ls891lwrTM4PnooY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lu+AdevAgoX28NVxZUKE6EfO8Jd3VcnTpF6Mbt/u9mRUQHi3zV3396NV0GxTwrDby2GGgK1iTHmHnu5v86xYlibHs+XXR9gza6dvMy16iWh6Z11NED7zyjgzIclqv7kNJ9gSc3eUeEGfHiJCZ4zhlGMMBa8oJxFuyzeaOFP6tNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+uJhBwc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+uJhBwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDEF1F000FF;
	Sat, 12 Sep 2026 08:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201220;
	bh=Z/aSngsqvWAov2KBONKIrij9AQrVASVrhbF/YDZzuA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+uJhBwcDhPzv3RWtkKdNHRmEjQsVL/K7Rc1u5nojJ3onMGOzAZkAgAwu6rI/3rxu
	 yYAZBfZhliwyWjRTH9OVxXAu8138XROsCR1sb6fa+qIkJYOJ8AEwoUVsGSslNPUn/i
	 GoHLfoV9NFaeVXXeXtK3TUEpm7cS1iZzyPmeJatc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0915/1815] wifi: ath11k: fix leak in ath11k_service_ready_ext_event()
Date: Sat, 12 Sep 2026 08:44:25 +0200
Message-ID: <20260912065710.403427396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 1575b7faac7d1..e46f4d7ddc80a 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5129,6 +5129,7 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 	return 0;
 
 err:
+	kfree(svc_rdy_ext.mac_phy_caps);
 	ath11k_wmi_free_dbring_caps(ab);
 	return ret;
 }
-- 
2.53.0



