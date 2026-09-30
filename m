Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F025C4DDB23;
	Wed, 30 Sep 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786974; cv=none; b=CyA1g57W6NFbuAB4scUaA//nh27gdKld0jIeMABqEspm4bdCYyLWcQZmKaCvS/XUbZmVQE/siwiOGLFFYJuHgu3AVOuji8VIyU5Czxqxp5V0UB8+1IAKastspKequ/c1VOKffH9lilzz2SPx3/ASAcXAd0yMA0Dk2Mpjpwd7PyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786974; c=relaxed/simple;
	bh=4rT0ccW0f2/YueHMzAWY/UlF5PU31EwvtTRog0XW9vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MCya5JyESLpYp+N8q2cu0kqtbZDng1A+LYe+eP4BcO2me0Mg5pl60piosb+T2nchCjTx5PbrrocAd+W7tIuNcrdbBid88XxUWi6SX4VTSue4aSmOjlW0c+FZeWIsRC0Xk1scozfu3Wigoq3O5xvfZFOaX3aQDUANmR6nbxfrImA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bivl45Ya; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bivl45Ya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8381F000FF;
	Wed, 30 Sep 2026 16:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786972;
	bh=Ht+SdO4S82wteH1fdPWVQOGuVPdQuuUQhDFcpCW6jSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bivl45YaDs+VArNtSC3sFMxnFIGcRmm0p6kgEgsE156+UOfakP7Pd2qZtNN9vXaph
	 RTyXOAwVSj1i0bUGIuAkEUA//ZPNxW6KXmONuIZTkEWkOP4rS0jziF9b5qjUcoiwuW
	 qHvJHN8QL+0RuJhV4+8JMyQZpawLKr9ZuM3MkoQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 068/457] eth: fbnic: Fix payload page pool error cleanup
Date: Wed, 30 Sep 2026 17:22:53 +0200
Message-ID: <20260930152347.514756150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Björn Töpel <bjorn@kernel.org>

[ Upstream commit 8e0b235bd918d06f54ba8fddd2c3ddc36ca59c15 ]

The payload page pool pointer contains an error pointer when its
allocation fails. The cleanup path passes that error pointer to
page_pool_destroy() instead of destroying the header page pool. This
can dereference the error pointer and leave the header page pool
allocated.

Destroy the header page pool instead.

Fixes: 8a11010fdd96 ("eth: fbnic: allocate unreadable page pool for the payloads")
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Link: https://lore.kernel.org/netdev/178915061000.219967.7726187707862333281@kernel.org/
Signed-off-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260915104917.3978113-1-bjorn@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index e7918d3f6aba9..661dee1661afe 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -1622,7 +1622,7 @@ fbnic_alloc_qt_page_pools(struct fbnic_net *fbn, struct fbnic_q_triad *qt,
 	return 0;
 
 err_destroy_sub0:
-	page_pool_destroy(pp);
+	page_pool_destroy(qt->sub0.page_pool);
 	return PTR_ERR(pp);
 }
 
-- 
2.53.0



