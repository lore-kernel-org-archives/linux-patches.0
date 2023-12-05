Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0FE6FAF;
	Tue,  5 Dec 2023 03:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DgALJY2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF692C433C8;
	Tue,  5 Dec 2023 03:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746636;
	bh=BCE6cCf1Fzpmfap0k83PkY+nJPwmFfk+PnTfgGC7hdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DgALJY2yYjRNhJl1srUNke2mli/8xQGMl1+KDdNVWlWKIwgCwhSf253ZNFBeyzmii
	 HmYal8AboORBus+HUdaJSxnBZ9Wm+OKWWkg3Agwwx+4ayIIouoiBW85+CfTNuSXC8n
	 xms7EdW0zrgdGEb1BC6sprBBUT169xvMWmIwnoO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/134] neighbour: Fix __randomize_layout crash in struct neighbour
Date: Tue,  5 Dec 2023 12:16:11 +0900
Message-ID: <20231205031541.718578042@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 45b3fae4675dc1d4ee2d7aefa19d85ee4f891377 ]

Previously, one-element and zero-length arrays were treated as true
flexible arrays, even though they are actually "fake" flex arrays.
The __randomize_layout would leave them untouched at the end of the
struct, similarly to proper C99 flex-array members.

However, this approach changed with commit 1ee60356c2dc ("gcc-plugins:
randstruct: Only warn about true flexible arrays"). Now, only C99
flexible-array members will remain untouched at the end of the struct,
while one-element and zero-length arrays will be subject to randomization.

Fix a `__randomize_layout` crash in `struct neighbour` by transforming
zero-length array `primary_key` into a proper C99 flexible-array member.

Fixes: 1ee60356c2dc ("gcc-plugins: randstruct: Only warn about true flexible arrays")
Closes: https://lore.kernel.org/linux-hardening/20231124102458.GB1503258@e124191.cambridge.arm.com/
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Link: https://lore.kernel.org/r/ZWJoRsJGnCPdJ3+2@work
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 07022bb0d44d4..0d28172193fa6 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -162,7 +162,7 @@ struct neighbour {
 	struct rcu_head		rcu;
 	struct net_device	*dev;
 	netdevice_tracker	dev_tracker;
-	u8			primary_key[0];
+	u8			primary_key[];
 } __randomize_layout;
 
 struct neigh_ops {
-- 
2.42.0



