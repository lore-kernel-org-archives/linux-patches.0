Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431081F6688;
	Tue,  3 Dec 2024 14:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236880; cv=none; b=bXM7yGbtIek/ZhF56k9p+3fQ76CrD3Dg7NEGo+lRjYUW+Ug0HWO/+RxdVsI8LfjrtOJpkrUEWXcVHwYdcQ8d2/fnuDQ54/ZPP+U/40AZm8+lzYWeD2t+7KCkCeFr44tOj+j6x/XKwTn6/GEsmJYNrb0bIF4oV7Tya3h4gOxD6nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236880; c=relaxed/simple;
	bh=X19WZ+OInoOSFR54BoDPYsjyv9TopQVhj2bUuXpMRfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uij3zk/waNW0wgL+uMQH+xp4Vpfl9VgvfG1oRHmecLsFW+DZnUoNz9pPBRyoguwZ+hGFvpT8hnC0fJWlVNWZHPaiMmcD4erTrs5BDj3EK7WHBew8dxSj7CFz3RaAdDJHLxbjkU1qNPElkfy2GG3/fT8EKzeYxWQiEtbZfqCdZno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zR69BRd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zR69BRd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91AEC4CECF;
	Tue,  3 Dec 2024 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236880;
	bh=X19WZ+OInoOSFR54BoDPYsjyv9TopQVhj2bUuXpMRfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zR69BRd/Fa8bFVDBe1EZI0cDTvhQsUg6BSo7X3U9TkiSgYgdcPu2Fqrz4u4HkpslG
	 fgXfmo/b/q0gs1aFOK4HH+VuiXrRdpGiFJg/usj2gN93rpwrjKLKcLjUds0oXDuJ93
	 6w1gL1mZF4sWBV6baaicJPKJGk0Ik2yqzo9f3tZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Alexander Merritt <alexander@edera.dev>,
	Ariadne Conill <ariadne@ariadne.space>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/138] 9p/xen: fix release of IRQ
Date: Tue,  3 Dec 2024 15:32:45 +0100
Message-ID: <20241203141928.770976940@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Zenla <alex@edera.dev>

[ Upstream commit e43c608f40c065b30964f0a806348062991b802d ]

Kernel logs indicate an IRQ was double-freed.

Pass correct device ID during IRQ release.

Fixes: 71ebd71921e45 ("xen/9pfs: connect to the backend")
Signed-off-by: Alex Zenla <alex@edera.dev>
Signed-off-by: Alexander Merritt <alexander@edera.dev>
Signed-off-by: Ariadne Conill <ariadne@ariadne.space>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241121225100.5736-1-alexander@edera.dev>
[Dominique: remove confusing variable reset to 0]
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 77d7e6c3d7a27..33d8814daa888 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -306,7 +306,7 @@ static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
 		if (!priv->rings[i].intf)
 			break;
 		if (priv->rings[i].irq > 0)
-			unbind_from_irqhandler(priv->rings[i].irq, priv->dev);
+			unbind_from_irqhandler(priv->rings[i].irq, ring);
 		if (priv->rings[i].data.in) {
 			for (j = 0; j < (1 << XEN_9PFS_RING_ORDER); j++) {
 				grant_ref_t ref;
-- 
2.43.0



