Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81F1346E5E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302636; cv=none; b=rmVk9reO1VHDh4za/DS4knnoUvwvfrFuzj2DkFLOmNi23DTQISvhgkYoCTSIL1av4Dmyds/Sb5pjYx5Cwdu5EU04AS2Uxbfjx86OuxWV3ga+arEJynWrXFYvJvk2pMu07EeK6ZnK0RzGtoSFiVqbR856jM8F9eDjXy3HMOO23ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302636; c=relaxed/simple;
	bh=Uf1UZIon7C5DSW4giGDSW75xiD9DepQ5nBuFFONDb5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL1ERXuUhRG2vqrZptXGhhnh2NrXEEOygNbRSD/BMfYrs1LYIjYCMrYkeEt3hR+e4IESphNi7GQtR4fmUXTs0iWzBcTBjSoeeh84RrhYvAb0Tc4EytcM/3O0Koh35BQ1CcpCWrfMO57ZaEiYV7CkLApXJNlIHkEM3RpQWd/x6H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LlPhvu2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LlPhvu2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2065BC19425;
	Sat, 28 Feb 2026 18:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302636;
	bh=Uf1UZIon7C5DSW4giGDSW75xiD9DepQ5nBuFFONDb5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlPhvu2tW6WgPQdEyU0at1SyXqhMUZZlglQtwOQVh2siD4fzP191ghnJrTOr/Oe5p
	 lpsBaaRrOkLpwo9UlHPXWCNXh837JCqFQLgNNGDD7h9bZ9vfDMEtJ4ozqf4LkA6t/U
	 c6FvSrFN9Pa7rKc4NHDoyqagynkJmzyQPRRrWas+uRSIxYrGTI0sobP8Ym4jI+DdCM
	 wEXHBWx1ljNISkNXRu7ZFOXxxxppfDyf7MdYlpkpYrFWMWlARPgcF+EISaNU9tz7oE
	 OYEk4PAl63jIltVFoxNRIaQIeTzQlcBEG3JkOVLzTIP3X22C3UAaTdGNwU2KwMcpqa
	 8HEMpXT/L7J7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Juergen Gross <jgross@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/164] xen-netback: reject zero-queue configuration from guest
Date: Sat, 28 Feb 2026 13:14:56 -0500
Message-ID: <20260228181505.1600663-157-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 6d1dc8014334c7fb25719999bca84d811e60a559 ]

A malicious or buggy Xen guest can write "0" to the xenbus key
"multi-queue-num-queues". The connect() function in the backend only
validates the upper bound (requested_num_queues > xenvif_max_queues)
but not zero, allowing requested_num_queues=0 to reach
vzalloc(array_size(0, sizeof(struct xenvif_queue))), which triggers
WARN_ON_ONCE(!size) in __vmalloc_node_range().

On systems with panic_on_warn=1, this allows a guest-to-host denial
of service.

The Xen network interface specification requires
the queue count to be "greater than zero".

Add a zero check to match the validation already present
in xen-blkback, which has included this
guard since its multi-queue support was added.

Fixes: 8d3d53b3e433 ("xen-netback: Add support for multiple queues")
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20260212224040.86674-1-n7l8m4@u.northwestern.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index e85b3c5d4acce..5b78d9172aac9 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -735,10 +735,11 @@ static void connect(struct backend_info *be)
 	 */
 	requested_num_queues = xenbus_read_unsigned(dev->otherend,
 					"multi-queue-num-queues", 1);
-	if (requested_num_queues > xenvif_max_queues) {
+	if (requested_num_queues > xenvif_max_queues ||
+	    requested_num_queues == 0) {
 		/* buggy or malicious guest */
 		xenbus_dev_fatal(dev, -EINVAL,
-				 "guest requested %u queues, exceeding the maximum of %u.",
+				 "guest requested %u queues, but valid range is 1 - %u.",
 				 requested_num_queues, xenvif_max_queues);
 		return;
 	}
-- 
2.51.0

