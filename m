Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C5B29C339;
	Tue, 26 Aug 2025 11:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208858; cv=none; b=CHaH58/TR4Gxppa1yzsSSxWL+l94/74xbU+mx1hhJ9HRsafchw/nxXub6PjCNh5BW22p/89L6iODwJdSFEgtGAoOJwjxK98p96Niv/yXbMBtdNpIK2VMEexO5fR4I2tI8srx1TdBD6KWMZZRsrEKXAuoX9RB0MvpCakjyUIQQ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208858; c=relaxed/simple;
	bh=mylbnHggEMU14jT/P6dt5P5DIRkvg0/r3JisuuG6mfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=koJ45YEOnvc+HadKelgwZKcN1uO6FVOieSViSvIuquPcZ/UNvTlNPmVbnPTcUVYa9nfI+1hWJrTPm9WBifQxWgX2kas7UHkjfCk0an87bi4Dj4C94D/T9V1J1+MoOweKs/KWHxUEkBXGcqkd/lOsc3jYBQ/Bq/hnEFMT4n2HhyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOqygACA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOqygACA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482DDC4CEF1;
	Tue, 26 Aug 2025 11:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208858;
	bh=mylbnHggEMU14jT/P6dt5P5DIRkvg0/r3JisuuG6mfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOqygACA+Dur2qdcp6VxH3A4TAS1Jx58/QEpS/PJzEwyuQNzPX/DoqKk/IQI1TP6S
	 SpeZ5aeoLjRS+Vb6TZLEOwpJHSkF9w3NjwzxG19CXJvXPuEfc8efa+fGhNwGgY3VLe
	 gzS1GFncWBIOGL2Z2pJf7HBdmS6GxcLywXLIUFu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/322] RDMA/hns: Fix dip entries leak on devices newer than hip09
Date: Tue, 26 Aug 2025 13:11:26 +0200
Message-ID: <20250826110922.619365398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit fa2e2d31ee3b7212079323b4b09201ef68af3a97 ]

DIP algorithm is also supported on devices newer than hip09, so free
dip entries too.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250812122602.3524602-1-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index a7b3e4248ebb..6a6daca9f606 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3028,7 +3028,7 @@ static void hns_roce_v2_exit(struct hns_roce_dev *hr_dev)
 	if (!hr_dev->is_vf)
 		hns_roce_free_link_table(hr_dev);
 
-	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP09)
+	if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
 		free_dip_entry(hr_dev);
 }
 
-- 
2.50.1



