Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147C5340D88;
	Mon, 18 Aug 2025 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525746; cv=none; b=YAeTsnDo9otWfOwnLF+V6lYUIXmxYRruWgYezHVH/yRkIdQz8R7e9WYTPPPnkmRJZnpF19qDP8Mag+ULmyVPxzRJruQ7Bj6KB7Hw6l8UCPjGs+S9PoBoNgf+5KTRh4RmxfVgqeO7mfWR8X8G/I+R/QwY3+vfllAeX72kPtqUgWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525746; c=relaxed/simple;
	bh=DuUxAijdx6LjyPDeeXZiZNEopiUWPMWKQ0X6RaUoDZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b1qAFbQ3gosADNsZhUSpNmcZPGS6y8py1hlJh6Hosv9FUqlChkBx0LpqB1IDHU41uD9hh/IqouKqCFlYZuE+0G9wR2cp6kgJFi3RhQQhCAh8bJgvlr44aykXp0WxoTQIBsxnoNuz+Kskgu6T1JXeKiUTxMA5e9IE/5coOMNcCK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kkbEW2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kkbEW2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C24C4CEEB;
	Mon, 18 Aug 2025 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525746;
	bh=DuUxAijdx6LjyPDeeXZiZNEopiUWPMWKQ0X6RaUoDZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kkbEW2DeKJFfMhErt08/1FxFdlR6+hyF5AephHu2/d3XcNhK4z8QqYoYadN66orx
	 ZP88BfzuXU1XXWVMJICwDXMzi7aosUZ2GsIA1I6X33I9ol4JeKEtMYcceC1udh9myA
	 Qi7dotRvEDF8XmWrL4FzlzPPn+QPPeP3IwrxbYBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 355/570] vhost: fail early when __vhost_add_used() fails
Date: Mon, 18 Aug 2025 14:45:42 +0200
Message-ID: <20250818124519.536366842@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 84c9bdf9aedd..478eca3cf113 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2983,6 +2983,9 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
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



