Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC902350831;
	Tue, 26 Aug 2025 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216363; cv=none; b=JcFK6uM6jXkaV2mdp7kYd/+JXohbZWFsxTuJa8IksybaDaYYS8w6l5RQ8iOrpspDf/Z438P+YrlbyYkgLXEU7d/TeiFAMjuoyDmHxf2704kws5uTlTjV8Zlx3eXFBCXOwdb3tcZU08o0tGfwGirDsaJZRRJTADWCRBwsbwC3G34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216363; c=relaxed/simple;
	bh=TgpbG8ehZGrnzRZ2AZ29hGyWPCxFq6nbtOKv/iwQuD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ptsYLNFqlQGWrI3Cc45DaC5QSRB0tzfcT3m3bI683hlJnRj+dtF69AJbVZYqRNFCbCmTin2WazfBwELr6r3ipH/8TZkZGGg/k/A/Yd1nWmmrBNlvUNCosCX1lD3gHocz41LxATkcn8ogUWw0KHXAP9RTEdxdko+JJu+B+vSwDtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6OllnN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6OllnN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4B3C4CEF1;
	Tue, 26 Aug 2025 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216362;
	bh=TgpbG8ehZGrnzRZ2AZ29hGyWPCxFq6nbtOKv/iwQuD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6OllnN/eyuiEoZmuuDu+1n8glLtqoURhu/dkhq9BaR4k9gkaBLDjCfOZUe3OG5Cj
	 SyXp2iqhBSHBz2at9w0/IqkIZcawmIpGOk9Zw7b9vChd6cv7zc0SP9SW1rD0oPpaAn
	 E/HwzcmWKtubPtATlPPGG1w2xn+VmEyV5n4++jiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 382/644] vhost: fail early when __vhost_add_used() fails
Date: Tue, 26 Aug 2025 13:07:53 +0200
Message-ID: <20250826110955.906088389@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit b4ba1207d45adaafa2982c035898b36af2d3e518 ]

This patch fails vhost_add_used_n() early when __vhost_add_used()
fails to make sure used idx is not updated with stale used ring
information.

Reported-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20250714084755.11921-2-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Lei Yang <leiyang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 061af5dc92e6..973e079025a9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2421,6 +2421,9 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	r = __vhost_add_used_n(vq, heads, count);
 
+	if (r < 0)
+		return r;
+
 	/* Make sure buffer is written before we update index. */
 	smp_wmb();
 	if (vhost_put_used_idx(vq)) {
-- 
2.39.5



