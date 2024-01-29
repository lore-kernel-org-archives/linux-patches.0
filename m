Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B399673748;
	Mon, 29 Jan 2024 17:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548539; cv=none; b=RFeYKbQy7sZZgCISXXNtZVPeIZYD5PYVQum/Dw3uV8J0YCXrxP0jGiAXAh1AAC3RtfGajRkR6twiXtICl2KDTe+wdUNYmfiwGeJASupdCSES37Fas5NzgBs6xNaJgfwCqrYfx1BwbA97V13+K0fxTHA2b7DVIfFT8oHiIZgiqoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548539; c=relaxed/simple;
	bh=yIsfTkso4vuNqt+h1Eh7AYhI+4hTyX5ErHaKF+pqVnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6NmI6LxqdwL79UkwprYMRnN4pmztdVeDtbXjIyuofvxiDW1fIHpcY2F6VFNTABtaSLWi4av2jH/68rIK5AxU78ZxnJdeKYqxdWNBRR6eOGxTnDlggM80Qiz6b8nRx3YhB68+8akS8yeQduUEFvyhFoZ8E2cfgf+OfZohOBYnL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adPjDH0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adPjDH0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD12C433C7;
	Mon, 29 Jan 2024 17:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548539;
	bh=yIsfTkso4vuNqt+h1Eh7AYhI+4hTyX5ErHaKF+pqVnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adPjDH0ZVMfEKxlQkinl+iVbTzBsa63Ize8rD6w58iVgfShoPMgOZ7Z8OZ+yZDQPa
	 TCmtaJPbJh0YOILkZfa4M2Utw8I7DquAIqtXR6Qx0BlW4OaMIzqLhtKStesQ5FLB5b
	 6yOxefn7Q9ErEMKt90eZnSKnnoD55BNloQhDF4O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/331] tun: fix missing dropped counter in tun_xdp_act
Date: Mon, 29 Jan 2024 09:04:03 -0800
Message-ID: <20240129170020.140209493@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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



