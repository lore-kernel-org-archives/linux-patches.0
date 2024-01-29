Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1A415A4A4;
	Mon, 29 Jan 2024 17:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548130; cv=none; b=GGSkqaw/q35plg21ZnZrWUEuAI+5Ur3DPPgfVzQUjjmLCkOK6Ccy3Xh5fvYx7wsay5j25Syw3TKIQt+Ex5T/YSYX2Sn0jIDUPUl/ew5EU0hgWOpfu4y+Ml/0kemLu2/aIBm65n/lLAc+A3BPTB0EM/ZCqhDgqRNalZzoNfdmfLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548130; c=relaxed/simple;
	bh=f5T0R6MulC3tIeIRPEZthtDkT/o5kpf0tZ4UzEawFnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABBlDP1dNuV3yPhch9QzQMhldUA95Qi3hZXI6eGIBoFTiEuDZp+Q37eauExwJEMY+PlIuYlTd+LKeMd8XyhjDZ84f679rb6UPH22wo1MbQ+a28OjnIqv64F3BoPOWosobgWBaDvtcTMCIYysjSHNEWFDF20gWEXz19z6KHKWn1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXyolMCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXyolMCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262A2C43390;
	Mon, 29 Jan 2024 17:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548130;
	bh=f5T0R6MulC3tIeIRPEZthtDkT/o5kpf0tZ4UzEawFnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXyolMCTdh5hIdi96n0OErG91B2JrjxhnGUP3xQ2Kb+X+g0fOgbnfC4in0qPMMiup
	 L0ycAm6qIsBG4qpCdGxkRAvNUIdRmQ4gFY9NmrgpQCHwHkN0+7m41MhK5+/IrTNhRG
	 LRZiMh/G4YEprI8C+l+yRoT5VE5RJpHFIE5v+oF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 159/346] tun: fix missing dropped counter in tun_xdp_act
Date: Mon, 29 Jan 2024 09:03:10 -0800
Message-ID: <20240129170021.079151906@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 5744ba05e7c4bff8fec133dd0f9e51ddffba92f5 ]

The commit 8ae1aff0b331 ("tuntap: split out XDP logic") includes
dropped counter for XDP_DROP, XDP_ABORTED, and invalid XDP actions.
Unfortunately, that commit missed the dropped counter when error
occurs during XDP_TX and XDP_REDIRECT actions. This patch fixes
this issue.

Fixes: 8ae1aff0b331 ("tuntap: split out XDP logic")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index afa5497f7c35..237fef557ba5 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1630,13 +1630,17 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 	switch (act) {
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(tun->dev, xdp, xdp_prog);
-		if (err)
+		if (err) {
+			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
+		}
 		break;
 	case XDP_TX:
 		err = tun_xdp_tx(tun->dev, xdp);
-		if (err < 0)
+		if (err < 0) {
+			dev_core_stats_rx_dropped_inc(tun->dev);
 			return err;
+		}
 		break;
 	case XDP_PASS:
 		break;
-- 
2.43.0



