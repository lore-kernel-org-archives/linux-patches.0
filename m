Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD53431AF00;
	Mon, 18 Aug 2025 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524057; cv=none; b=rkDUcKz37lSqxTXZrLdrsRhF93wwalty7XOrAjSXPRYZQU6/33qT49k9NyNFM7IzBEIXwgTSxaQnnLNJUsp/492KD7R/LjzAd6zt/eb+GMhAyftG1fyncY/JeFbEkRzQN1wExOYmiPHZbKkQNUo93KQk/fo2MhzEnl9Ld//TYmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524057; c=relaxed/simple;
	bh=0jkvZRqw9v3ihQbdduQ3gWv6VSzuwedy9tN+mq5gbjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nlkUJRI30s/qwHfrDZX6nTRLax3uNBOxullVgP1x3x8yLItwBXJulTFHKF7V9GAvq7yO42pEJNu5NDcsYSZ5Vrfbc7V2tZ3JFF4Zi3AoXXLf5dqeNo419b1eAzUQdE/sgsFQzUsd8VPkR5tLfIVW0MojFmJ01drEhZCdfvq7vPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtv0GUI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtv0GUI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70F3C4CEEB;
	Mon, 18 Aug 2025 13:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524057;
	bh=0jkvZRqw9v3ihQbdduQ3gWv6VSzuwedy9tN+mq5gbjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtv0GUI/NLuxJkBH3o6i+Sq1FMj/0KImTxlG2hz1VgwDD07IAm5Lq3s9ZdryHnNFX
	 Yo6TCLu+Kc/ghqj7q76b13OQplpgYkD7WI20zhO8GAna9yrpg76PG93kiaUFeNBW+u
	 T7wo+5kSjuye09/vPMCm0eHS1Zaun+3EZQq2cxCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 327/515] vhost: fail early when __vhost_add_used() fails
Date: Mon, 18 Aug 2025 14:45:13 +0200
Message-ID: <20250818124511.023950063@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 79b0b7cd2860..71604668e53f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2971,6 +2971,9 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
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



