Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9954409;
	Mon, 23 Jun 2025 21:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714682; cv=none; b=qLak+k6eu7M+iXXMBzyjOgjO0vmYzPX3A24Scy5hocA91jqjkNkw8tyyHfxEYgQ/eBSHBpR2rbe50KObH7pBgcuiwU55QK0rgnt9zoiTOT0DfLM6ijyRN0n7Cxv5+b4ZFq2x1Xi+yyBEoUX69pT2nn/OPyeTt5BRNBSnqS6Ohik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714682; c=relaxed/simple;
	bh=/YGEN6vaLP3OgPJkUOwhJwwFfWZ6xj9+ljOkETDMfTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwAYg21FSbSsT2Hm5MlJ89uf9B5+uXzWNwnus43SSWCqebmMvhOtZJKwDRfHF8KgP+PfsRPsBc6uLHeQucqEEvVsniFJbQiR4vHT2kU7KYrSo1zl4/vT6OaiyMrIIf17FrrHP68zWgeVJ5Y2pH8BxP8ecRJVIJ3DkoJdHX8tiuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tda4VHv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tda4VHv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83131C4CEEA;
	Mon, 23 Jun 2025 21:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714681;
	bh=/YGEN6vaLP3OgPJkUOwhJwwFfWZ6xj9+ljOkETDMfTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tda4VHv0U94ZFcGS6OzeXIpEqBWV6iOdzGjnPaWYazfbZ0k/TkGlQmMEwkxzVHmE3
	 XP4zuITzLu9K8QkYkHQgmtU8eYnKOJvaogk9I5umuAUNCcYVNkD+PagbgalnS+lhjN
	 Niu/e0G6+ZK7vHPG8BvCoah0TKxR1rgqBStghoM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Linxuan <chenlinxuan@uniontech.com>,
	Winston Wen <wentao@uniontech.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 409/592] RDMA/hns: initialize db in update_srq_db()
Date: Mon, 23 Jun 2025 15:06:07 +0200
Message-ID: <20250623130710.165786840@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59352d1b62099..bbf6e1983704c 100644
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



