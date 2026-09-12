Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D08B372ED0;
	Sat, 12 Sep 2026 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239378; cv=none; b=dRUss5VaXJDUK2BSPR6MrkpBWMVzz6ojjFlwItEB8WUTpxvjzYnflNxOu7gJsU6X+UAu3/rbgq/KcvPPV5vNlfV/Im4KfRjde61yVAmjjD0T3Xpo1tcwR9nHmE1QUeMh8FG2qxYtX9/8Cx7aBhb7FObKivxLX6W3g+iBo3gJuPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239378; c=relaxed/simple;
	bh=zME6kCoqnk6NmxldCzlhVAHmMguKBGlgIEPuFkB43uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHRpWyEhcPbaxgUlRGJNhk8wAr+kLDdRrv/XE8SqJHep5siCSO5yFSDW214B9hyezGQoTLhEsTSj5V9QLOSMOdf4ap4O5To4U29+z0nCvhV/b6gR9u5C7eY/6DyIufRiXls6R+jL+ddB4VLn4/MrBMl01ybb1nCA0TM7W/xJf2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYcgY/Gl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYcgY/Gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F3F1F000FF;
	Sat, 12 Sep 2026 18:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239377;
	bh=bnw7Ml0Sgde7oQi4yJMJyaXzl2n93kwcXCxFv5y5fdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYcgY/GldnjEGt7f4xL0XSu81gPY+0ZH0dAYP4huv+9+jOiYcTQgj8hUjoD7bcPfv
	 XIqBRUqrJObTV5A/wN2skUCMxubo6EagRNOgznDZF9fYvGdAo6x9RhTPveO1A0zBec
	 211D4qIvwgBem/DOnRPUYRN2rIuqocroYXsWWnNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 652/935] wifi: ath11k: fix leak in ath11k_service_ready_ext_event()
Date: Sat, 12 Sep 2026 09:01:22 +0200
Message-ID: <20260912065541.796756923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc55b2e96ad54..46110169b7272 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4355,6 +4355,7 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 	return 0;
 
 err:
+	kfree(svc_rdy_ext.mac_phy_caps);
 	ath11k_wmi_free_dbring_caps(ab);
 	return ret;
 }
-- 
2.53.0



