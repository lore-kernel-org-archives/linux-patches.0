Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE8B263C7F;
	Wed, 25 Feb 2026 01:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983585; cv=none; b=V7HVLYILqXcIsRrGdoHRdJKcmsf3yclEsJhmyjs/tcs1cjZaGeMbE2+KTuUswLLYP9E+Xat4Phs8+Pip/Bb7jThAyrM4l6EqOSHhOM+JpobG43ShYli75mlrRV4DUSFfuxG28rs20/GXxC0UMHQIz7Alk+Adhe53qNYjsCzMmN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983585; c=relaxed/simple;
	bh=cN94lL4DER2lgTN7WJ5GxpSfubevXhKl61TOzQgFkCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmCVnNVo96hu3yrnWesXBIfpuV6qPdRcyheBnXMaqJc0masdsYuKL4jum7c+FBwe9Z9NSFKETZv/r/lxiJ0vnVg4J4AVCTbw4ueo2gmN7ua0XTLSQQLx+lpuc7WCh8WbPzZMdqpJKO4EIkI9sA9G2FxTM/9Fklir7k+jNjU4CD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptUEO259; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptUEO259"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778A6C116D0;
	Wed, 25 Feb 2026 01:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983585;
	bh=cN94lL4DER2lgTN7WJ5GxpSfubevXhKl61TOzQgFkCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptUEO259PX0Ng4Ye86EtXQ5LFhByb6hbN3fOUiX+sEBZ1WqF0Ksmj1dUmU3Zvtln/
	 X7p59RDZbnolSaO7BOfSxPin+hrZvYn59UAwj1kEfqSOZftDd7xQQ2ZS1Ofh2DNx/Q
	 OkU/WbxZIWcavf7h1gSyeu9vkU7xrnFvulu1Ajr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 667/781] net: remove WARN_ON_ONCE when accessing forward path array
Date: Tue, 24 Feb 2026 17:22:56 -0800
Message-ID: <20260225012416.145155979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 008e7a7c293b30bc43e4368dac6ea3808b75a572 ]

Although unlikely, recent support for IPIP tunnels increases chances of
reaching this WARN_ON_ONCE if userspace manages to build a sufficiently
long forward path.

Remove it.

Fixes: ddb94eafab8b ("net: resolve forwarding path from virtual netdevice and HW destination address")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ccef685023c29..f5e4040e08399 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -738,7 +738,7 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
 	int k = stack->num_paths++;
 
-	if (WARN_ON_ONCE(k >= NET_DEVICE_PATH_STACK_MAX))
+	if (k >= NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
 	return &stack->path[k];
-- 
2.51.0



