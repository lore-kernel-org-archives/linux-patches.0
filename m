Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4635B2D23A6;
	Sat, 12 Sep 2026 13:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219358; cv=none; b=boPymM+UuNExjjMe3vOEShVH1rwu96ikUqY3M7wjKgU/7s5FsPZCCg5qa9W9EdJY0UYzG5Ogrhyn9vN6KxIM4iV1/1BlGPMDDirP/3FbmoKyZKbM9I1hr+H/iVmHOeax/OzJRlVqvxaQnKspeNniuwNKnD0tWyy4rIWtKl5/vhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219358; c=relaxed/simple;
	bh=aU7bi/6bOkW6G6NrwZErIw5qph9oQVOXnZqIC7Yeim4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rmuNtM+O8cpd7XtB4y+GkseC/rymo7JLE+X3S44niayRYmtS8IbVceB4AmIr7HzktIAHSoVzMXKNDkZiIIUS+iIBtMNHRwT580FiwM6yeUi98VfAeynfvlR8k2MLOZOIm9PX/c7don4Ix3j9Q3ta4TZHMAppPsCA+CV5dFZou+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YrUJ8rUQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YrUJ8rUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57AC1F000FF;
	Sat, 12 Sep 2026 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219356;
	bh=P2LosmjtyJJ8Xeycp9fK9yx2wo+Izfh95VUo5tHAR8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YrUJ8rUQziApfHQ7jh39USbZ88qafO3k7Ouxb/OGgtRl8Q0UaDyYSZD/IxQ39Uj5d
	 e1hN4BHZuH7u9ak2uQ0OZkvAzDhcR6r/zpuulcRWjXvBlUTLrlDFOvvkdGc//0YS/3
	 plKDyb3yXYiis8qGXO48JgG77vJNNOcigYPOJ8hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1297/1376] net: core: check skb_frags_readable before uncloning in skb_copy_ubufs
Date: Sat, 12 Sep 2026 09:02:03 +0200
Message-ID: <20260912065636.441608470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mina Almasry <almasrymina@google.com>

[ Upstream commit 00e11ee9831b3439264e0ae6762a0470126515af ]

skb_copy_ubufs drops clones and modifies the SKB via pskb_expand_head()
before checking for !skb_frags_readable(skb). This alters the SKB
geometry prior to throwing an -EFAULT on an invalid SKB. Check
readability first.

Fixes: 65249feb6b3d ("net: add support for skbs with unreadable frags")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20260823183602.1051453-1-almasrymina@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ca861bd6db148..b754125dcaadf 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1967,12 +1967,12 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t gfp_mask)
 	int i, order, psize, new_frags;
 	u32 d_off;
 
-	if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
-		return -EINVAL;
-
 	if (!skb_frags_readable(skb))
 		return -EFAULT;
 
+	if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
+		return -EINVAL;
+
 	if (!num_frags)
 		goto release;
 
-- 
2.53.0



