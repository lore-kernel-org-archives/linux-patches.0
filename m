Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A2322B8D0;
	Mon, 10 Mar 2025 17:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626827; cv=none; b=DZ4WP5MM0AuLg/9pNkcmb4dmarDOR/M5ykeoUJBQCHlX6V4EzPppGLAthk9OH4YlBmJyoRUF7ZlMYrdP2N6qo2JPp5q6TKE+TWNohT5mc8C47FfQMRNXcrvnpZnEDtrihLoJNCMAIfjVdmUe/koM9aU5V2jcpXyGTboPnhhiRp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626827; c=relaxed/simple;
	bh=3HSskLKaCss0320X0mPegXaLY6wGRIMjdGsid41yxxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPDcShxegZVjtRqshgoLsla1erOm+Qk+rsDokbj6RGtjVPQ8LoYm3arcLXBer5W1xWzES0/bAVDJOvMx7+VYki2FGjB7f8fQ8J4YrSWM7+SUgse32N27s59uH2Z2eGzRI9UB5NUcKwWTdLA2DuGTo8pecuge5kosub+ucWLR8/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4m4ovLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4m4ovLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5734FC4CEE5;
	Mon, 10 Mar 2025 17:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626827;
	bh=3HSskLKaCss0320X0mPegXaLY6wGRIMjdGsid41yxxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4m4ovLHUnBN9rGBiqpn/7h6x48GVUGgGnLVyIvTY0L03OVkY+63pNsIl90YXypA8
	 e7p/1KgH99M4bDKvw/OrSI8BzQWKhhgwfZfm1EiyJ9iZibUL+1rko/F35KJ2UWUKTh
	 Qn7yLuMnGVwTfuCSi7BE+DGbIsDfLdXuX1y2Ry3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 126/207] net: hns3: make sure ptp clock is unregister and freed if hclge_ptp_get_cycle returns an error
Date: Mon, 10 Mar 2025 18:05:19 +0100
Message-ID: <20250310170452.814131916@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



