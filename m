Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230B2140391;
	Tue, 27 Feb 2024 14:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042463; cv=none; b=VyJDwsPPoRfnniAF1WaMsvi0qD7dzNZDlkbfgZY1Bjr1GmnSEKyXO4F2GoXyRbziBCoeDdtzvpd74lSBAMwaCNm/db458uBOa5mBo6ARpkD/mn8Tl6z/JaB4VSYx5NKQth0wVWIaxFOALu1HFB4K+ysFxLVcABG0po9FSTFeWx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042463; c=relaxed/simple;
	bh=ImnBog0UoiYQH2DsJ19nxQh65njyWxmMxmVgIUDJGrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jxq2TQLg5RsQv1Hr2Q2tibSLtXWdiT9f4MFoYG0iI56nautn4Tp5u8f44AqSv6zzzFqwEDCh96+HIxv57P2J8aRiQaZWvuPm0OkD6TC6hb88sTze8PmgtEvwyehVVn1/2LCSryiiX6lwLAv3r4ETzogUAzD3N+dkox8upxiuDqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SdotCAon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SdotCAon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D61FC433F1;
	Tue, 27 Feb 2024 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042462;
	bh=ImnBog0UoiYQH2DsJ19nxQh65njyWxmMxmVgIUDJGrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdotCAonC6AneVumovwN4ZACqGjfvl+tH+1w4Qqvv21kUh88fZaW+DDYgwt3AfKjp
	 qm1JSlD+SLhuKbJW+oNYJV4q+wkxCSgorNUSyXg9zMWxw+psfOwTlaLIq70jufYin2
	 Q8/dycwd23LgyQmxe3GJr0UQUdOP20eCN6Cn8pMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/299] net/sched: flower: Add lock protection when remove filter handle
Date: Tue, 27 Feb 2024 14:26:31 +0100
Message-ID: <20240227131634.694306099@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 1fde0ca3a0de7e9f917668941156959dd5e9108b ]

As IDR can't protect itself from the concurrent modification, place
idr_remove() under the protection of tp->lock.

Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20240220085928.9161-1-jianbol@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index efb9d2811b73d..6ee7064c82fcc 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2460,8 +2460,11 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 
 errout_idr:
-	if (!fold)
+	if (!fold) {
+		spin_lock(&tp->lock);
 		idr_remove(&head->handle_idr, fnew->handle);
+		spin_unlock(&tp->lock);
+	}
 	__fl_put(fnew);
 errout_tb:
 	kfree(tb);
-- 
2.43.0



