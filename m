Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB2B2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41D7C433EF;
	Tue, 18 Apr 2023 12:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822172;
	bh=aR4tzvaq6aFDgiKzOJuCoJ5m5puKPmDIg7ag4LBXosE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R99scWAto6a/j393kK2gm1Sh++74W6fy2vGmokRejrwL7/MZaw8N+m5EVVVDGg2hM
	 S/yr88eGhh07Ww0ldBOj8l7X020av7JtqX+qcIe0tS5Hd4hDU7L2uUjdizVHiz0GmR
	 94pZlRk0ED/6D2OEPJYEiLkeod++arHp6EqoDKSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 050/139] niu: Fix missing unwind goto in niu_alloc_channels()
Date: Tue, 18 Apr 2023 14:21:55 +0200
Message-Id: <20230418120315.590403052@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 8ce07be703456acb00e83d99f3b8036252c33b02 ]

Smatch reports: drivers/net/ethernet/sun/niu.c:4525
	niu_alloc_channels() warn: missing unwind goto?

If niu_rbr_fill() fails, then we are directly returning 'err' without
freeing the channels.

Fix this by changing direct return to a goto 'out_err'.

Fixes: a3138df9f20e ("[NIU]: Add Sun Neptune ethernet driver.")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/niu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index e6144d963eaaa..4bbf011d53e69 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -4522,7 +4522,7 @@ static int niu_alloc_channels(struct niu *np)
 
 		err = niu_rbr_fill(np, rp, GFP_KERNEL);
 		if (err)
-			return err;
+			goto out_err;
 	}
 
 	tx_rings = kcalloc(num_tx_rings, sizeof(struct tx_ring_info),
-- 
2.39.2



