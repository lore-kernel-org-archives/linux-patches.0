Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59CB3C414F;
	Tue, 16 Jun 2026 15:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624964; cv=none; b=bCqm17y3y8+xzAX21b2QkGGAPgAUE7zhCOaeRnntMceiEN/cHrT3tLDn448kfIXGtHPCuM4gyLqCczGK7t9Ar0sXHV1LH1eNjV8VSR7Ro8x8PXn/vlWkIYaJknh7GAE8Oanj4Yxi4qpKt8UTj2iiJdhRcNCkwYv/t+w/gjEyC/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624964; c=relaxed/simple;
	bh=vSxeP5VtksRWW6pr8QXiM/mPhqKCz8rTpZu2H37wNlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8sukgrh7iTowAMMmdGqMfqAKxrT9zfm/JKC7dFYc9zqAG+SIrKjUp0/Oiq1PM1myY6rEoIkS50FdtcwcAQmgeMY+dHqWChwbN2OCeSfCAGEgKTDg9uc962X290Dd0DCI7tVH+JjkgkLbPWWoqHmBRGHbIcPK9tcoVC69w+dPwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N3p521Xn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N3p521Xn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A8A1F000E9;
	Tue, 16 Jun 2026 15:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624963;
	bh=WlaaXlVcbvaIZwSvvNPmZmz4fUYVQUWNVpiA6D6ReVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N3p521XnGtCAI+33YOyYPB+HepbOX93rb4cBSie1a36dutnbpGia06tKa9C+FVFFK
	 hY4V6JGTqIR+63rhgLJsF8Ih3i0drAuLG1lPATUsSITKhb0jKEen5vQJcyWtAVDhAb
	 a4O+7CSKkiIvAzgmQf4zBnr66/P3aL2pPKA9l69M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/325] net: airoha: Fix use-after-free in metadata dst teardown
Date: Tue, 16 Jun 2026 20:27:34 +0530
Message-ID: <20260616145100.584047052@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit b38cae85d1c45ff189d7ecb6ac36f41cdc3d84d0 ]

airoha_metadata_dst_free() runs metadata_dst_free() which frees the
metadata_dst with kfree() immediately, bypassing the RCU grace period.
In the RX path, skb_dst_set_noref() sets a non-refcounted pointer from
the skb to the metadata_dst. This function requires RCU read-side
protection and the dst must remain valid until all RCU readers complete.
Since metadata_dst_free() calls kfree() directly, an use-after-free can
occur if any skb still holds a noref pointer to the dst when the driver
tears it down.
Replace metadata_dst_free() with dst_release() which properly goes
through the refcount path: when the refcount drops to zero, it schedules
the actual free via call_rcu_hurry(), ensuring all RCU readers have
completed before the memory is freed.

Fixes: af3cf757d5c9 ("net: airoha: Move DSA tag in DMA descriptor")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260602-airoha-mtk-metadata-uaf-fix-v1-1-3aaa99d83351@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 9781a6fc9bf9a8..f30bace944d694 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2933,7 +2933,7 @@ static void airoha_metadata_dst_free(struct airoha_gdm_port *port)
 		if (!port->dsa_meta[i])
 			continue;
 
-		metadata_dst_free(port->dsa_meta[i]);
+		dst_release(&port->dsa_meta[i]->dst);
 	}
 }
 
-- 
2.53.0



