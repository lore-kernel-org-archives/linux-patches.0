Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ECA33688F;
	Tue, 16 Jun 2026 16:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626231; cv=none; b=tZ+u8Tt7u7jZCj4LdrYVDCOvHtAVlUaMG+H03mAF4Qs2W1yyw0FLblHdZAT4MJmXyrg+g8KQxB8ecXv3suUvQ3A6p4J9RqR+jWCx4AMmy/OIIygIqKLEmz5JlUUpJPP6tWjqOR+hANKy4TFrhvF3Xi7HCRx524hYi/sHWzZC1rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626231; c=relaxed/simple;
	bh=WBBUOAtnVe/F6A2e2LRQVnR7OWpEOphKOdbPuHQYboY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuLgtYHQec9zMmmW3nTJVdYCIddMn94z5lg50eTwsZ3LVl+aU/D5bR2CKbej2hJxdjJ0RBKWtpBeIjG1Yh72kYpDjmwJtJFuryGIGYRQHzsEPNsf0YG8GP75KW8UN/k1VKFJLTSC7EOUizoOwFeKHDxxmx9PqlpMntY+gthbKOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luGJwVrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luGJwVrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4132A1F000E9;
	Tue, 16 Jun 2026 16:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626230;
	bh=W9ql1PgQ96gYG/QtqeVfJT1k4jWf+Ollopx6+IqCPXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luGJwVrMRP9WPIsVhHPQXZ3NY6a7gPaRtitR1I34xhrb/qZuSyOYrbfesA3V8PCyS
	 0AhIiBhfXa/arlRGwnVUAXuojqxcKRliTWvf0CARG9c5u/Z0Cs69J9k0bp/XPiuAsj
	 vTP06q4Sg/H52YufU/3VqHW/zA7ouB/cgTrobClI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Zilin Guan <zilin@seu.edu.cn>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 245/325] octeontx2-af: fix memory leak in rvu_setup_hw_resources()
Date: Tue, 16 Jun 2026 20:30:41 +0530
Message-ID: <20260616145110.687848302@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit 09a5bf856aa759513afc4afd233d15bcc711b84e upstream.

If rvu_npc_exact_init() fails in rvu_setup_hw_resources(), the function
returns directly instead of jumping to the error handling path. This
causes a resource leak for the previously initialized CGX, NPC, fwdata,
and MSI-X states.

Fix this by replacing the direct return with goto cgx_err to ensure
proper cleanup.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing
v6.13-rc1. The tool is still under development and is not yet publicly
available. Manual inspection confirms that the bug is still present in
v7.1-rc6.

An x86_64 allyesconfig build showed no new warnings. As we do not have
access to Marvell OcteonTX2 RVU AF hardware to test with, no runtime
testing was able to be performed.

Fixes: 3571fe07a090 ("octeontx2-af: Drop rules for NPC MCAM")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Link: https://patch.msgid.link/20260604143756.1524482-1-dawei.feng@seu.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1135,7 +1135,7 @@ cpt:
 	err = rvu_npc_exact_init(rvu);
 	if (err) {
 		dev_err(rvu->dev, "failed to initialize exact match table\n");
-		return err;
+		goto cgx_err;
 	}
 
 	/* Assign MACs for CGX mapped functions */


