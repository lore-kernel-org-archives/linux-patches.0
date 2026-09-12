Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8595C3909A4;
	Sat, 12 Sep 2026 19:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242988; cv=none; b=nKBHk+p5E3DD6L80HA9UyIeB69ucyel+YoEERCNmzGIrQR8vvKjM6k/FZ1KR9PocsbgWd9j1HS0w8FNMqdJQP+TJWoVTq3hZ4MhvyCjfz3/GRVcaD6sjzJdwTDTRjuFYXBRMVNnkLQ1O9HzpDOihfByBTR9YV6fl7Q/0nGe+pEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242988; c=relaxed/simple;
	bh=YY9JCXQ2wnkpsJ6X34Bi2MMuhCz/FarTvsKDlllSgGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMyvI9mnZ2ex14pvcH0eogGXVcKFrVfPjJhXoUEg8/OAHiyVwNW9niLqW5Cu1LdyySE7WnouNdYuEK6XKhssXP1zypDwRvZnrps3aZtAV5On8lQgzgqAIJjskq7MGxiIcPN2nNoaJEynFzmNh+wIGNGGqecRcjBxT/A1NUeRNj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjhiDHqU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjhiDHqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A701F000FF;
	Sat, 12 Sep 2026 19:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242987;
	bh=dlZSJo0Q82xJoiAq0dA16kH+hb1mg+wk0e7Tqqf45JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjhiDHqULUgAJdPBB46HH8Ef2rCAnQPVmIr8YG3xS2OyVKsfrvDasKD64aO7PT7ZI
	 DwjNlnl8AfdhDkZ4k3E5BBFExg571R+W8bpM7ZXqXVI5XCjleLiKlUN/bUa/mwwAf+
	 Gxvu97yrjFI5y8EyJ+Rd26s1DBhWlCHQ9k9nR1qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 560/798] wifi: ath11k: fix leak in ath11k_service_ready_ext_event()
Date: Sat, 12 Sep 2026 09:03:08 +0200
Message-ID: <20260912065529.963145697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index fad0a4a4a0240..6434d3ff0ac6d 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -3952,6 +3952,7 @@ static int ath11k_service_ready_ext_event(struct ath11k_base *ab,
 	return 0;
 
 err:
+	kfree(svc_rdy_ext.mac_phy_caps);
 	ath11k_wmi_free_dbring_caps(ab);
 	return ret;
 }
-- 
2.53.0



