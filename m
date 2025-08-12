Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578F02CA9;
	Tue, 12 Aug 2025 18:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024414; cv=none; b=iGFsDNN4618dIzcL2SmM7pmQeb1InvbgjSTDqog+kHbkOg9TbvCbShbmcBO+IsopJ/h7E35eUOj5qsheuSfKlfKm8mKKfh2nl78kR4nhjruUbNU/GjdYEUCbfyVS9vBfN1l72A04NcjKqaLmiA9Uld5xreRjpSuMoSMgs+KP8Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024414; c=relaxed/simple;
	bh=ycjv02oZjGVUy+11VuOhFWU+uMt82sWR7Teg9PA++xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egLichWdqZPQlYJo40A8Orvnk7AJaigT0ZvzGRthbTVjminvduP+p9ek7h02MEu1mPDCSzlvYvb4RIh8GQcTpCATowEVWVywx20ug7SbQuVAoHr5wIqb+ULoDz186JJPw6CGcbRTmgGIsdLGJyiqfa34JlJes7y64QkpYOBbrGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7mbpqu1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7mbpqu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FA9C4CEF0;
	Tue, 12 Aug 2025 18:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024414;
	bh=ycjv02oZjGVUy+11VuOhFWU+uMt82sWR7Teg9PA++xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7mbpqu1STJ7VWngZBvghUeZs5gtA0fK0oIykobaZ7tWfUEKxd7TVrdHXI/Pei3vK
	 gNpNhT4nOC+25XrCquO7fKn6dkbT2ObA7bHZK7DAsPBkWu+Fu+1bpgOZrhGM5+3pb7
	 PSDiYP7pKb6k6kqIVMofSQ1Faj0/3tfx5mcOLtlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 366/627] RDMA/hns: Fix HW configurations not cleared in error flow
Date: Tue, 12 Aug 2025 19:31:01 +0200
Message-ID: <20250812173433.226666469@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit 998b41cb20b02c4e28ac558e4e7f8609d659ec05 ]

hns_roce_clear_extdb_list_info() will eventually do some HW
configurations through FW, and they need to be cleared by
calling hns_roce_function_clear() when the initialization
fails.

Fixes: 7e78dd816e45 ("RDMA/hns: Clear extended doorbell info before using")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 29068be052d9..2b04e25c6b09 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3001,7 +3001,7 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 
 	ret = get_hem_table(hr_dev);
 	if (ret)
-		goto err_clear_extdb_failed;
+		goto err_get_hem_table_failed;
 
 	if (hr_dev->is_vf)
 		return 0;
@@ -3016,6 +3016,8 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 
 err_llm_init_failed:
 	put_hem_table(hr_dev);
+err_get_hem_table_failed:
+	hns_roce_function_clear(hr_dev);
 err_clear_extdb_failed:
 	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08)
 		free_mr_exit(hr_dev);
-- 
2.39.5



