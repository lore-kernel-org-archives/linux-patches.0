Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34231FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26619C433D2;
	Fri,  3 Feb 2023 10:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419897;
	bh=aNU1B65HKTeCEfVyCNfC70O/XZudIRAfxi046krNWEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gejDrsPjcgyi0JBiY48Yomzoi4i+Y73hazUDqHDiKZOGGNCpycDZem5Q4Y8eUHgrw
	 k1wY4PcWPJKhvEgvwyoeAyyjZ1iGaWjxSOBodOxp2D5Hs2TzB/a3AmWd4WfcJhgw1z
	 Jem2ncvrjq1sMQKZ0Djbztd1eQthwSzNhgOKkwkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dean Luick <dean.luick@cornelisnetworks.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/134] IB/hfi1: Reject a zero-length user expected buffer
Date: Fri,  3 Feb 2023 11:11:59 +0100
Message-Id: <20230203101024.504443222@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 0a0a6e80472c98947d73c3d13bcd7d101895f55d ]

A zero length user buffer makes no sense and the code
does not handle it correctly.  Instead, reject a
zero length as invalid.

Fixes: 97736f36dbeb ("IB/hfi1: Validate page aligned for a given virtual addres")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167328547120.1472310.6362802432127399257.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 4d732353379d..28f1b3c37a4f 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -325,6 +325,8 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 
 	if (!PAGE_ALIGNED(tinfo->vaddr))
 		return -EINVAL;
+	if (tinfo->length == 0)
+		return -EINVAL;
 
 	tidbuf = kzalloc(sizeof(*tidbuf), GFP_KERNEL);
 	if (!tidbuf)
-- 
2.39.0



