Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A0A225785;
	Mon, 23 Jun 2025 22:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716625; cv=none; b=p63hjHNuf6TOwUxXzgwARxbzrXySzcrQ+5kQDsPJr62RIJuFytKZmbfEhPTFeGWh6aUfRKf9tyghCidgU+ZJ9F/250LUYjU5H6JgJ9CY+aKCPW2rocoTxfgu8WFMNG5o4PZ9+nUoRZpXDdMj+Ajtq15w+04HF9tyqvpER5u8BJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716625; c=relaxed/simple;
	bh=bb21ZLfaxtzH6NF70JxV6Ymh4lf7xcYXT9ZWXSFIXQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juH3Lptqgp1TPvSwqIyw+SsrWXY6oz9YmSbM7Nej8GwrY/4lHcZwn9cqeRmvvIDyqfOD4hXWMSdH2eckPG9C0g6m+Q8EtUx+bZ0SKogu4QiTor3SnCTq/5hoYw6PfKpktBO1CiAfOPVO3WLJ8E+RUJVs8v8ikcHMPwcaHpt4j2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evj5o2dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evj5o2dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74D9C4CEEA;
	Mon, 23 Jun 2025 22:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716625;
	bh=bb21ZLfaxtzH6NF70JxV6Ymh4lf7xcYXT9ZWXSFIXQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evj5o2dxfm8cxiJ3NfbNKyiHlaCMK7E40Ghw9T+lY588P+RyB1AFWv7zND8egho8v
	 tLdXiMlFCMaerk5QGvjeOtJfhXylmgq1pHL2Az0gjuZXqGuTxc4G/p8WqxpJMZK4XU
	 HyVUr2X7TPcZO3v+wkbMyGczuCzs062tVKBuvZhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	Winston Wen <wentao@uniontech.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/414] RDMA/hns: initialize db in update_srq_db()
Date: Mon, 23 Jun 2025 15:06:47 +0200
Message-ID: <20250623130648.780759975@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Chen Linxuan <chenlinxuan@uniontech.com>

[ Upstream commit ffe1cee21f8b533ae27c3a31bfa56b8c1b27fa6e ]

On x86_64 with gcc version 13.3.0, I compile
drivers/infiniband/hw/hns/hns_roce_hw_v2.c with:

  make defconfig
  ./scripts/kconfig/merge_config.sh .config <(
    echo CONFIG_COMPILE_TEST=y
    echo CONFIG_HNS3=m
    echo CONFIG_INFINIBAND=m
    echo CONFIG_INFINIBAND_HNS_HIP08=m
  )
  make KCFLAGS="-fno-inline-small-functions -fno-inline-functions-called-once" \
    drivers/infiniband/hw/hns/hns_roce_hw_v2.o

Then I get a compile error:

    CALL    scripts/checksyscalls.sh
    DESCEND objtool
    INSTALL libsubcmd_headers
    CC [M]  drivers/infiniband/hw/hns/hns_roce_hw_v2.o
  In file included from drivers/infiniband/hw/hns/hns_roce_hw_v2.c:47:
  drivers/infiniband/hw/hns/hns_roce_hw_v2.c: In function 'update_srq_db':
  drivers/infiniband/hw/hns/hns_roce_common.h:74:17: error: 'db' is used uninitialized [-Werror=uninitialized]
     74 |                 *((__le32 *)_ptr + (field_h) / 32) &=                          \
        |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/infiniband/hw/hns/hns_roce_common.h:90:17: note: in expansion of macro '_hr_reg_clear'
     90 |                 _hr_reg_clear(ptr, field_type, field_h, field_l);              \
        |                 ^~~~~~~~~~~~~
  drivers/infiniband/hw/hns/hns_roce_common.h:95:39: note: in expansion of macro '_hr_reg_write'
     95 | #define hr_reg_write(ptr, field, val) _hr_reg_write(ptr, field, val)
        |                                       ^~~~~~~~~~~~~
  drivers/infiniband/hw/hns/hns_roce_hw_v2.c:948:9: note: in expansion of macro 'hr_reg_write'
    948 |         hr_reg_write(&db, DB_TAG, srq->srqn);
        |         ^~~~~~~~~~~~
  drivers/infiniband/hw/hns/hns_roce_hw_v2.c:946:31: note: 'db' declared here
    946 |         struct hns_roce_v2_db db;
        |                               ^~
  cc1: all warnings being treated as errors

Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
Co-developed-by: Winston Wen <wentao@uniontech.com>
Signed-off-by: Winston Wen <wentao@uniontech.com>
Link: https://patch.msgid.link/FF922C77946229B6+20250411105459.90782-5-chenlinxuan@uniontech.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 985b9d7d69f20..81e44b7381229 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -942,7 +942,7 @@ static void fill_wqe_idx(struct hns_roce_srq *srq, unsigned int wqe_idx)
 static void update_srq_db(struct hns_roce_srq *srq)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(srq->ibsrq.device);
-	struct hns_roce_v2_db db;
+	struct hns_roce_v2_db db = {};
 
 	hr_reg_write(&db, DB_TAG, srq->srqn);
 	hr_reg_write(&db, DB_CMD, HNS_ROCE_V2_SRQ_DB);
-- 
2.39.5



