Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981191F8904;
	Tue,  3 Dec 2024 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241956; cv=none; b=KRb40EA6BcqOmNGX6P3V3Y0FhnYnKhkUUkiMx/Wogbvhipkw6YbDPQ2gfWY997+/4XRMk5De2jB6mpoLGKJgf+/jb24z017qA/0v1JIUEL3NOetDWoiRdDuMUYUtGLSViDe2vKT6y8ttr53xURrgwojzDT9Yqme+uFNNU2pM4cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241956; c=relaxed/simple;
	bh=BXAZPAPXg0GpKmmY0tXehrO0G2xv+th5geDVzLU574o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DznEWeUj4yOISxNyv/ub7L9340KsELvAM2+OhWSgljrBCZqBY2IFMAozmpeHou++kZ7lJmTum7ReGUli9QK/0JxqIDm5bGmbUWR1GZM8frDwlnuvtt94sOap4Hh2e4tTny8kvv+res2JOctX6UiR7pQ1+bb1/YwlgQIJWeSIeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+5LtD64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+5LtD64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D83C4CECF;
	Tue,  3 Dec 2024 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241956;
	bh=BXAZPAPXg0GpKmmY0tXehrO0G2xv+th5geDVzLU574o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+5LtD645iqhaneRcU0tJ4yn1U6pENAYUvQegRimVf9xJ+NDswspWFMoiP47E7jCX
	 tqfl0NZHf+8qM+Mrb/lF6Z55Kw5dYb3zEl9D2+2ssGTIMTJHT+9juocnHwj5TpZR+w
	 17DZD7RZh35vmTfKpzffGKIzqmVN8SkuGHJ+yizA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 565/826] rtase: Corrects error handling of the rtase_check_mac_version_valid()
Date: Tue,  3 Dec 2024 15:44:52 +0100
Message-ID: <20241203144805.784556341@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit a01cfcfda5cc787552b344cbc92f9c363c81ad4f ]

Previously, when the hardware version ID was determined to be invalid,
only an error message was printed without any further handling. Therefore,
this patch makes the necessary corrections to address this.

Fixes: a36e9f5cfe9e ("rtase: Add support for a pci table in this module")
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index 7b433b290a973..1bfe5ef40c522 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -2122,6 +2122,7 @@ static int rtase_init_one(struct pci_dev *pdev,
 		dev_err(&pdev->dev,
 			"unknown chip version: 0x%08x, contact rtase maintainers (see MAINTAINERS file)\n",
 			tp->hw_ver);
+		goto err_out_release_board;
 	}
 
 	rtase_init_software_variable(pdev, tp);
@@ -2196,6 +2197,7 @@ static int rtase_init_one(struct pci_dev *pdev,
 		netif_napi_del(&ivec->napi);
 	}
 
+err_out_release_board:
 	rtase_release_board(pdev, dev, ioaddr);
 
 	return ret;
-- 
2.43.0



