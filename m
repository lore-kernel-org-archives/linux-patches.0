Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D01C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A7AC433D2;
	Wed, 28 Dec 2022 16:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246060;
	bh=pypPerhJUgi/qZ7FyWevrIR26NY3KeAIW4GacpD/Flg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7ePIeM0IdRdJ2CiWINnNv+tqneTrLNUjJ9H31p+b5htc28JeFsrmy7mGcZ3CYWRk
	 yqfbqj/kY/JlPbJcyKRCEb+sCUUU5YNk1TzeTlGLp7kZFfUgSNClPLLdwRulQ3bgXK
	 20IWvjnLLg0heiBaMSvSY2QYMNGj+Hfe//dpDLWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pravin B Shelar <pshelar@ovn.org>,
	dev@openvswitch.org,
	Kees Cook <keescook@chromium.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0974/1146] openvswitch: Use kmalloc_size_roundup() to match ksize() usage
Date: Wed, 28 Dec 2022 15:41:53 +0100
Message-Id: <20221228144356.805852749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit ab3f7828c9793a5dfa99a54dc19ae3491c38bfa3 ]

Round up allocations with kmalloc_size_roundup() so that openvswitch's
use of ksize() is always accurate and no special handling of the memory
is needed by KASAN, UBSAN_BOUNDS, nor FORTIFY_SOURCE.

Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: dev@openvswitch.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221018090628.never.537-kees@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 4a07ab094a84..ead5418c126e 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2309,7 +2309,7 @@ static struct sw_flow_actions *nla_alloc_flow_actions(int size)
 
 	WARN_ON_ONCE(size > MAX_ACTIONS_BUFSIZE);
 
-	sfa = kmalloc(sizeof(*sfa) + size, GFP_KERNEL);
+	sfa = kmalloc(kmalloc_size_roundup(sizeof(*sfa) + size), GFP_KERNEL);
 	if (!sfa)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.35.1



