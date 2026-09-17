Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35CC4EF139;
	Thu, 17 Sep 2026 18:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668628; cv=none; b=AwjrwtyXgajDcxgQOjyjqMuY7gYnt06E8zq3GtmOUAljzwPTPauckadgzoSxxjizFR0ofRQuIaLvHeASzZB/61XDr/0DaQUsEfv9nI+DjouhgkXrfTJQ4kXpDpI3Ia89m1L2epXp2xG4oeFKZnDHukHoS5x/3ptr0YpFC2GZWAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668628; c=relaxed/simple;
	bh=KN5Mnn17WOqOthK4LgVfFjENFD4zod+sO4gwgTWK1Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hjBkrUMQh/zyLhSQqTVlhtwiTg4sAzslBggOsvtShQkWXBD/bQ8uFhHSTrtcPmVUwlxw4OkH+Bs75rBGDODgQmb2UteZle02LNE1krQhLzPFt1C9+4JoVT6RgH4eZNll26KSIyOkaXDCCpfvjYcJ8+4HeyVH+ZlNF8WJYo/litw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyDrEA9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyDrEA9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBA61F000FF;
	Thu, 17 Sep 2026 18:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668627;
	bh=+DXsEilhbfOoBxFdIWOjRy6EkyOmTCfurwBjMrGZIes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uyDrEA9/F/8YGfN+pim/C7r09nhowzN4kmXMjVWymEVfJM/PzlMf8WPwr0CxnCvdg
	 HVSblzsMSpMYlf00N4o3w7J9ORu0euQHbO8lJbnA2Dtxhs+HhhOiXkranW3AfBoxPH
	 e0nmmV53gx+Ym4LuVb7m4n+qJJP4AC4Mol9qqkEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0488/1102] RDMA/bnxt_re: Proper rollback if the ioremap fails
Date: Thu, 17 Sep 2026 16:07:11 +0100
Message-ID: <20260917151551.957151144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 87267803a8c824616eb147c5dad7030a5db6f878 ]

bnxt_qplib_alloc_dpi returns success even if ioremap fails.
Add the proper rollback when the ioremap fails and return
-ENOMEM status.

Fixes: 0ac20faf5d83 ("RDMA/bnxt_re: Reorg the bar mapping")
Fixes: 360da60d6c6e ("RDMA/bnxt_re: Enable low latency push")
Link: https://patch.msgid.link/r/20260615224751.232802-11-selvin.xavier@broadcom.com
Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index cf8208f652d3b..5a99fa8e9be39 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -737,9 +737,13 @@ int bnxt_qplib_alloc_dpi(struct bnxt_qplib_res *res,
 		break;
 	case BNXT_QPLIB_DPI_TYPE_WC:
 		dpi->dbr = ioremap_wc(umaddr, PAGE_SIZE);
+		if (!dpi->dbr)
+			goto fail_ioremap;
 		break;
 	default:
 		dpi->dbr = ioremap(umaddr, PAGE_SIZE);
+		if (!dpi->dbr)
+			goto fail_ioremap;
 		break;
 	}
 
@@ -747,6 +751,13 @@ int bnxt_qplib_alloc_dpi(struct bnxt_qplib_res *res,
 	mutex_unlock(&res->dpi_tbl_lock);
 	return 0;
 
+fail_ioremap:
+	/* Roll back the bit we just claimed. */
+	set_bit(bit_num, dpit->tbl);
+	dpit->app_tbl[bit_num] = NULL;
+	mutex_unlock(&res->dpi_tbl_lock);
+	return -ENOMEM;
+
 }
 
 int bnxt_qplib_dealloc_dpi(struct bnxt_qplib_res *res,
-- 
2.53.0



