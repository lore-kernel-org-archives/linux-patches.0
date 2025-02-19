Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC93A1E503C;
	Wed, 19 Feb 2025 08:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955279; cv=none; b=O7FYHXXKgcQ5K7GMY4FevThB3ROj4n3wu1pgC1xUj2lO5aSwdKqD/ySzrGBseoTNEZeZjxsBk2Feb/rFnVx1BU+Ge7pZS3e2wMjvYQxDXERLGqezvOGE3UX0Vuy7iIibvJMYgNeADt/3QsxU2lsfEftfodSedpULyKWQ+3lS5dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955279; c=relaxed/simple;
	bh=flctWTV94UMmuHpWcxM7O3UwakazB0FwkRgOmb37dO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHRsjhQ8y1M3nbAeQbMKgn+h8wWGAGkPF/RewHCx6bHZFSHidIxKscdlpW2JaQwWxbOx+dPJzgggrMWBJ4hJNeRM2JI6vQfWdYwsUWMFaY5VKf+pbxwGp+aq6KxhFo6kKbIIy1k1IaIuq8KBPVLHIe/DWadlNfN5oBPpc7gHy1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JL3KsdSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JL3KsdSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7056EC4CED1;
	Wed, 19 Feb 2025 08:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955278;
	bh=flctWTV94UMmuHpWcxM7O3UwakazB0FwkRgOmb37dO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JL3KsdSR3qGpngdu1PLrSBxLCNbQKSS3hwQ2tL/JGPP1SJtdHtqyWfWOJbFBcJdVy
	 xaPjZK6a4duSL3v+gTke6Xy4F/X/8LpbyiGmOjjSSHEl3fj6wMJHdUxdXa5pzeuXLM
	 38AvTU0lL2YMONd8ApIypywyuCV9cn0ZNUstT2kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/230] ipv4: use RCU protection in inet_select_addr()
Date: Wed, 19 Feb 2025 09:28:24 +0100
Message-ID: <20250219082609.016705177@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 719817cd293e4fa389e1f69c396f3f816ed5aa41 ]

inet_select_addr() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: c4544c724322 ("[NETNS]: Process inet_select_addr inside a namespace.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250205155120.1676781-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 7cf5f7d0d0de2..a55e95046984d 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1351,10 +1351,11 @@ __be32 inet_select_addr(const struct net_device *dev, __be32 dst, int scope)
 	__be32 addr = 0;
 	unsigned char localnet_scope = RT_SCOPE_HOST;
 	struct in_device *in_dev;
-	struct net *net = dev_net(dev);
+	struct net *net;
 	int master_idx;
 
 	rcu_read_lock();
+	net = dev_net_rcu(dev);
 	in_dev = __in_dev_get_rcu(dev);
 	if (!in_dev)
 		goto no_in_dev;
-- 
2.39.5



