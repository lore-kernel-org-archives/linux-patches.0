Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8610CF4F1;
	Sat, 12 Sep 2026 16:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230509; cv=none; b=fVa9OGopjtJ1eZrOfiMdnR14NFVGDpZlu66iuB9bgz8ExKQIHX+uIzF3HGqJTV3lxwA+rdtw2vkUFq2nCyb+auUONB9daloNGg7jaBScAzy9LyOxlyib4QdyMfwiE25ewiESLrRirBNwaizkyyoWmGGpgXmPMLn2Bk32UJRdWgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230509; c=relaxed/simple;
	bh=7BrzzxSiwI+0SgkigrEZhUIElqyZ0CqDJkP4N3HrKb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fptqLPEt7j+7ZWQKq1DwjEM5TFXiLfjDK6XgDsJUNxpgAT7CdoG2E/mZptoEkfRhMyk/SU28ShVteGstHPeYFXv9CkjpQoDpiQ5mWc08sXvncy6r3nEgP/ObruYbWHH10JKfe/VsmQmjJ5o6bOYIrj82mxCsYoXDVYJMlpG5AqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nh63GFFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nh63GFFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF041F000FF;
	Sat, 12 Sep 2026 16:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230506;
	bh=Ov6u5gdU3+vgyOKmHN5IM0BLmy2C/khoZTQO2+mjulo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nh63GFFiELulCZlfE4HLrWoSYZnLlN/thi+uE0vobSqeBVMC8z/0jtYn+1KpekkNA
	 /q5jRPRK3XV/VNL5xALreEASB1LJfXBN0oNroz0wKIOojD+9dFMX+dJJaCJ2l1vTu/
	 DVcRssa0+y1rBj0sZ3cjeY6+M5gFHL7GS/At7VOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0808/1191] wifi: ath11k: fix leak in ath11k_service_ready_ext_event()
Date: Sat, 12 Sep 2026 08:58:56 +0200
Message-ID: <20260912065606.418767096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b2b69985dfcbd..c3f440cae0bfd 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4821,6 +4821,7 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 	return 0;
 
 err:
+	kfree(svc_rdy_ext.mac_phy_caps);
 	ath11k_wmi_free_dbring_caps(ab);
 	return ret;
 }
-- 
2.53.0



