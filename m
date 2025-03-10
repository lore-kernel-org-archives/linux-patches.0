Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A7922D799;
	Mon, 10 Mar 2025 17:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627607; cv=none; b=lVc+8QCcvq4Uzot17xvVlEfnPXKkEvrjuOVE5+raCNV9ZcXnpw2AnFpPoiOF4tIKJCJRLjhjCp1Ibqk5doW/LEbQEeS+l5ZCtzp4c3H4OJR4cUHX50Lr8JIL6t6jZqZSDlCjY9EAjnsK5BTVn5+hGF6JwBf2z5GErGD9q/w2unk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627607; c=relaxed/simple;
	bh=TLfDX9vNKrTrTpbbibGQ5sjRfVU4adhat0sRI4kIxTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gy6e53KQYo9JpRxl22N3se3Jw7ZaHxF3xj04No7mrLVDjfla2anHsflaGwP5rEZrJA4PJlQyN88ruDwvqhP0WdV+o38G80UCp1RLoXhMgrC1ul1LkfcaGdhJ24HCdKw5WnFR4mke/lUiaJS/tOva2DBCLmr3lFWPuTza7QiyJ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMpAFd1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMpAFd1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDDFC4CEE5;
	Mon, 10 Mar 2025 17:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627607;
	bh=TLfDX9vNKrTrTpbbibGQ5sjRfVU4adhat0sRI4kIxTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMpAFd1s+Q37ciwaA3IEwiXHsp2VP5u2y2bKzdW5b4G10vNb1cKXsOARrGtQtYU2F
	 B9H2fJugO6bQH6t9PIttG4epfx5xFu4tcZnGjJgy9KYC7ntP+1YLgka0/n3s530ZX5
	 xoORt2vfwzqvHRIT7dlQkFA7ERrInjbrwM0bdj0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/269] net: hns3: make sure ptp clock is unregister and freed if hclge_ptp_get_cycle returns an error
Date: Mon, 10 Mar 2025 18:05:33 +0100
Message-ID: <20250310170504.883574193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Peiyang Wang <wangpeiyang1@huawei.com>

[ Upstream commit b7365eab39831487a84e63a9638209b68dc54008 ]

During the initialization of ptp, hclge_ptp_get_cycle might return an error
and returned directly without unregister clock and free it. To avoid that,
call hclge_ptp_destroy_clock to unregist and free clock if
hclge_ptp_get_cycle failed.

Fixes: 8373cd38a888 ("net: hns3: change the method of obtaining default ptp cycle")
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250228105258.1243461-1-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index bab16c2191b2f..181af419b878d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -483,7 +483,7 @@ int hclge_ptp_init(struct hclge_dev *hdev)
 
 		ret = hclge_ptp_get_cycle(hdev);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	ret = hclge_ptp_int_en(hdev, true);
-- 
2.39.5



