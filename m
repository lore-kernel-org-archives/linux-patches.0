Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C623B8BA4;
	Tue, 21 Jul 2026 20:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667531; cv=none; b=Ahf7bY8fbbzLd1gNqY1sweVzemQhFh5hOPBHgcWdSPsS8hggXESyu8wy9/C+7WckiEq9VvYLQQC/K8Lg4nYHtfJ1j8I6qAOY+iddJo20dmzU6dJfZ9v3dTWjTvjQAYUNMSVvrESOn35fwfPtTZ4rP+YmfpfLuQJQlliylR7Uf10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667531; c=relaxed/simple;
	bh=2UDYK9JKf8MK8j5Rz/EcXsz3s3C1cWBJJR/9XdJILak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHRIeAql3q4NWGk20DVF6YAZ2bmBa61ol9igKtUsIGj7FCgtDoESY3UoLoBn6ZVwVqBsOByO5cz+C9QzttWaoq6AJdypYeiwmIgkCxwmTufn84nqm0WChE/7+ghC/A9qMpJx8S6gi54tAUojc3WvYguLF9aGdC0vYAMfn/5VBtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEyMrBJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEyMrBJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ECC1F000E9;
	Tue, 21 Jul 2026 20:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667530;
	bh=13MC3tc2+WUcmtHJ/jF6wkT0OQQdEyaLjRlgv59gRCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GEyMrBJaEq/TojUr2kwg52DGIpgPhv4AazrHWG//oorkXk71aoRScJhbq+8qwxOu2
	 1AphKVKusMb4NhliFi0OiIQyXjpkS6Qm7rDTE97stHZNx5MAH3NMxGzsAxr+IhaeTD
	 /UBrcEgDTYkLgA/iO5PS62Qvorq9U+Ivg2WnUoKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1095/1266] batman-adv: ensure minimal ethernet header on TX
Date: Tue, 21 Jul 2026 17:25:32 +0200
Message-ID: <20260721152506.307616964@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 49df66b7993c80b80c7eb9a84ba5b3410c8296a0 upstream.

As documented in commit 8bd67ebb50c0 ("net: bridge: xmit: make sure we have
at least eth header len bytes"), it is possible by for a local user with
eBPF TC hook access to attach a tc filter which truncates the packet and
redirects to an batadv interface. But the code assumes that at least
ETH_HLEN bytes are available and thus might read outside of the available
buffer.

The batadv_interface_tx() must therefore always check itself if enough data
is available for the ethernet header and don't rely on min_header_len.

Cc: stable@vger.kernel.org
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Reported-by: Sashiko <sashiko-bot@kernel.org>
[ move from mesh- to soft-interface.c ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/soft-interface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index e4d302c93478b9..9760ae08451ac9 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -206,6 +206,9 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)
 		goto dropped;
 
+	if (!pskb_may_pull(skb, ETH_HLEN))
+		goto dropped;
+
 	/* reset control block to avoid left overs from previous users */
 	memset(skb->cb, 0, sizeof(struct batadv_skb_cb));
 
-- 
2.53.0



