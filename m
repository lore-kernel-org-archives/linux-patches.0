Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D37D2EAE5;
	Thu, 12 Dec 2024 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015718; cv=none; b=qrl2xgNhL6rW7PjmmHhqoaWGgFRCl9Ju46YLmfy9E2OlcqA1cQnj9B3HZoVghAojzYPOtL0N9NG2JfsMXvyPEESGEM0TLbOGWJw19QA/Rrsvxcha3NW/iQoXW+hX9fmCv+QtKz47+bVtiCCWy/8loXgCeohPdhbWQ6qa/A6tLn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015718; c=relaxed/simple;
	bh=7Sj87azbfa3EoKh1XbctN9JlT7uaI3wXA0P9j51z3nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlFLpK7rXpunCuNdsGicm5ce1zs/Kf4B94YQJiCpI2R04R0xOWYLiMqN8QN4UiPmwtRiwZHPQLVDbAOBLScq2Liyx6drYZ8ECoC93jvQ7IvIYBLsf7Ae5VBc0ADbytmOat3IlQ7IVwcX8bv+j/xPos+8q+L5RYrtZEeTrd5uO1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3j0vJ1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3j0vJ1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85BCC4CECE;
	Thu, 12 Dec 2024 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015718;
	bh=7Sj87azbfa3EoKh1XbctN9JlT7uaI3wXA0P9j51z3nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3j0vJ1NyQv5AvWei26hvnNjp9WjvoLk2x40oEzZbinY/fdMW1R4NJbtDWjsjTX81
	 wTg7VYP0FKVVcPnvQuLzvHWtKT/X1b+PMCyYW3FYLRGEAGvAkbLY+L6dWI8rc9TRVN
	 dF1UeRifQBS1QW/AAthcaSafOI8xo1OUooXS8f/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/466] bnxt_en: ethtool: Supply ntuple rss context action
Date: Thu, 12 Dec 2024 15:53:13 +0100
Message-ID: <20241212144307.644730387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit be75cda92a65a13db242117d674cd5584477a168 ]

Commit 2f4f9fe5bf5f ("bnxt_en: Support adding ntuple rules on RSS
contexts") added support for redirecting to an RSS context as an ntuple
rule action. However, it forgot to update the ETHTOOL_GRXCLSRULE
codepath. This caused `ethtool -n` to always report the action as
"Action: Direct to queue 0" which is wrong.

Fix by teaching bnxt driver to report the RSS context when applicable.

Fixes: 2f4f9fe5bf5f ("bnxt_en: Support adding ntuple rules on RSS contexts")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Link: https://patch.msgid.link/2e884ae39e08dc5123be7c170a6089cefe6a78f7.1732748253.git.dxu@dxuuu.xyz
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 20ba14eb87e00..b901ecb57f255 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1193,10 +1193,14 @@ static int bnxt_grxclsrule(struct bnxt *bp, struct ethtool_rxnfc *cmd)
 		}
 	}
 
-	if (fltr->base.flags & BNXT_ACT_DROP)
+	if (fltr->base.flags & BNXT_ACT_DROP) {
 		fs->ring_cookie = RX_CLS_FLOW_DISC;
-	else
+	} else if (fltr->base.flags & BNXT_ACT_RSS_CTX) {
+		fs->flow_type |= FLOW_RSS;
+		cmd->rss_context = fltr->base.fw_vnic_id;
+	} else {
 		fs->ring_cookie = fltr->base.rxq;
+	}
 	rc = 0;
 
 fltr_err:
-- 
2.43.0



