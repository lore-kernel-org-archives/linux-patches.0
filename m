Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489431C688E;
	Tue, 27 Aug 2024 15:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771979; cv=none; b=q/XJD4PqLwyVWuBKHj/xpZKEIvxPUtvLdocSz7ST5CauTI48Sm19/rnhP3HKrbq0MEY296l+k7OGxrD7VduI6N7n7mSHfGQamfPJKz2gSj+FksFcXfoZHAjpe7u0eTvxzm33FAg0kYadrCxbx6fx0kSmRugMRqCMv4VLvQOVjqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771979; c=relaxed/simple;
	bh=xGf1leHrIE+8ksAHDstE1/19knAjbTUVuW+CyDlFkSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHH8zd3pjVJPEmLmnLbNRq/BQ46+NuYarsXjOyVoU5TVyd5Mmx4uiwM0/Qx0MLgYt7hfTqq3ULzbMgnfhp3Swi6vxaQ9RpoDOwhsQ1u82ELiHxacL8zivG/wu909wnmutk1agUf/VleP+gx01qNgTCX7ftfFQzPg4lJJAVceH84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KArru5A6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KArru5A6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB67C61067;
	Tue, 27 Aug 2024 15:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771979;
	bh=xGf1leHrIE+8ksAHDstE1/19knAjbTUVuW+CyDlFkSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KArru5A6KfdKQdMYYONx7tYJKKnRofWsca+Vdvhr6dkzemnEyygy2b6TyydbD01q8
	 HmXFo8XeNbjSkFaWUE/7D+RQyvBpvMGclKFYxDSj1Q5PyzvQDDorpjTVHmgbtB68uw
	 B9ETAMGQiTKS4YOEYkWugomtmQL7HZEuWImVmZAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/321] fou: remove warn in gue_gro_receive on unsupported protocol
Date: Tue, 27 Aug 2024 16:36:26 +0200
Message-ID: <20240827143841.211028601@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit dd89a81d850fa9a65f67b4527c0e420d15bf836c ]

Drop the WARN_ON_ONCE inn gue_gro_receive if the encapsulated type is
not known or does not have a GRO handler.

Such a packet is easily constructed. Syzbot generates them and sets
off this warning.

Remove the warning as it is expected and not actionable.

The warning was previously reduced from WARN_ON to WARN_ON_ONCE in
commit 270136613bf7 ("fou: Do WARN_ON_ONCE in gue_gro_receive for bad
proto callbacks").

Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240614122552.1649044-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fou.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 0c3c6d0cee290..358bff068eef8 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -431,7 +431,7 @@ static struct sk_buff *gue_gro_receive(struct sock *sk,
 
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
-	if (WARN_ON_ONCE(!ops || !ops->callbacks.gro_receive))
+	if (!ops || !ops->callbacks.gro_receive)
 		goto out;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
-- 
2.43.0



