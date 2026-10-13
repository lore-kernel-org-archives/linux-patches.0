Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FB05013A7;
	Tue, 13 Oct 2026 12:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892947; cv=none; b=g6jVrcSa22qP6Zb4YlVC9E1mSmlSxdkmFqhOQkXqHDAWUMw0G4ZE4cBAt3KrPwwGAxcKMExg0OBGWNHBSJDzvjoNbca1Jx+V3RHsX2Vc/I92ypA0pDCVuAVRMwh+JgaGyyYPL/p0SXdWJvHIdIjv2+sahs2bJHiwOZ4H8kZOXFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892947; c=relaxed/simple;
	bh=8Wr9ufKQIV6xKWJw5/50dHis7vivSRQ7pnSLXPKwQW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKa4vuBfb9dBdh6o32yArJ1QmipSkhMD/3Fty1jFciWmgm0m4ZRX3W5277Hu9QzWBq9k8VaTxqXeVjfvHqhSZBFB6A/8FuapVfJE8YmhDg7/0EklxV2V+5qUrMMq3fSu9mafEhwn87Sayl6bqLvSo8wJeJgowtAxOK62V+nt+b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8TA4h83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8TA4h83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 733EF1F00A0A;
	Tue, 13 Oct 2026 12:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892946;
	bh=TmXPfpYH/is5fwoSmjMGH0co3qQeuJgItme8lgRBMmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8TA4h83CFtbJu0zUqBAxe3xEXLtAR4eIFJyMzflLRbCmj6njTgx5Z9P5J3INbWlI
	 MHOzRYwCDHJVsqowevNLduCxNRcIlYHGfbW8DVqs2TiCRr99ow8ZvIOIs6+WtCnoAN
	 pddFSs/EPOI52HTN/GVtdMl0qkNOrUxSA7S1jgdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rhee <jordanrhee@google.com>,
	Tim Hostetler <thostet@google.com>,
	Joshua Washington <joshwash@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 059/621] gve: fix XSK buffer leak on error descriptor
Date: Tue, 13 Oct 2026 13:30:54 +0200
Message-ID: <20261013112922.263598832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Washington <joshwash@google.com>

commit 9fed6a8ab8a5bacba2c709cb19d2dd6d2fa9112e upstream.

When the error bit is set in the RX completion descriptor, the buf_state
and its attached buffer should be freed. In the case of AF_XDP ZC, the
XSK buffer was not freed, leading to a leak.

This issue was caught by LLM.

Fixes: c1fffc5d66a7 ("gve: implement DQO RX datapath and control path for AF_XDP zero-copy")
Cc: stable@vger.kernel.org
Reviewed-by: Jordan Rhee <jordanrhee@google.com>
Reviewed-by: Tim Hostetler <thostet@google.com>
Signed-off-by: Joshua Washington <joshwash@google.com>
Link: https://patch.msgid.link/20260930214735.3288780-3-joshwash@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -818,7 +818,12 @@ static int gve_rx_dqo(struct napi_struct
 	}
 
 	if (unlikely(compl_desc->rx_error)) {
-		gve_free_buffer(rx, buf_state);
+		if (buf_state->xsk_buff) {
+			xsk_buff_free(buf_state->xsk_buff);
+			gve_free_buf_state(rx, buf_state);
+		} else {
+			gve_free_buffer(rx, buf_state);
+		}
 		return -EINVAL;
 	}
 


