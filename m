Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048930;
	b=wDwArcfdKU34OFWKs2SYCAlixPFaW41tTx4zHqBEoy21y6/cQ9wGo9hpIF6Ml9CvbsQx
	 JkiYf7FMSs/C0MjyAUivItB4zQPy0TYVwjIKppO21ApCehJR/Jk+k5KXJ39575ugemKEm
	 BfuD72U91/cfBK8E3CiZbq4FPgGB9/TiPCo10R8lot6V54PZL0SG60mbo0E3/5kQq2esx
	 4owqNjiFERTM816UOi6FBmCAgjpNEx9DjGb99A6mRxoMTEObDuNRLdZHwxgcIcIMl6kSs
	 DHpvUIExgHyztXybK+q+sJ/lrgbEquNymjeFi0QszRJ267FF2x6ugCPIfK133GbtOfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+1ZSxdv8yH5q4gd842DqMMbD0nVzsWbTWO8hKmHEXgM=;
	b=XB8QyOXsGv6B+mY2KcDq9aFrBIbC7ZoJT+EwtvyX4AoE13Q75zmzTIH4Xn5ZB7X5RYQw
	 UddGounShM6PurJJOhBasxpiM2mtd/BiOjKk3ux96i13Nb0ELHnSOowptuIpXb52oaMec
	 SnLtKxm5FVksIruT/Dm/fZdxaeWgcN1MWqgrgv03veCqF5J6jWiqoahXjP7KObYAZc07b
	 yOCu614Yp9Pb3EKzSw7b032MSdyHw1MuebTwSPckmjG7wFprg9YWa+uOqPJYbvJW+NkuG
	 gNg6ajxaBkfh4QXBhuVgwnc2M1heWiV7YQv8VS98TLiyh0hjnH4BPE6/hjJ6F+vSYDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGZ48i7D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A9E606A320;
	Thu, 19 Nov 2026 00:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lGZ48i7D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADDE1F000C4;
	Thu, 19 Nov 2026 00:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048930;
	bh=+1ZSxdv8yH5q4gd842DqMMbD0nVzsWbTWO8hKmHEXgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGZ48i7Dxu3Vstur5l9kaHPy16b8hhGFaHWPOjGPkNKLvQUnEycvex/eXs7gpItc/
	 JrrzUUyobLmDl3PKkMw55lz3IgxsmNtmC74HQpJWDK0WjphXzrqCXyDM2cUsjC+kT0
	 cZbKS6nd78kuXqddQYZkTkZqtbO6wHsBFor1Rc8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2161/2857] ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()
Date: Wed, 18 Nov 2026 15:53:15 +0100
Message-ID: <20261118150319.205465831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 62b9ae8ae4a7f0b93efa1efa230782b37057b1e7 ]

vexpress_flags_set() obtains a reference to the "arm,vexpress-sysreg"
device node via of_find_compatible_node() and passes it to of_iomap(),
but never calls of_node_put() on it. of_iomap() only reads the node's
reg property to create the mapping and does not take ownership, so the
node reference is leaked. The function runs from the __init SMP prepare
path and caches the mapping in a static, so this is a one-shot leak of a
single refcount during boot, with no functional impact.

The lookup was added to drivers/mfd/vexpress-sysreg.c by the commit
below and later moved here by commit 9b06fc39084e ("ARM: vexpress: Move
vexpress_flags_set() into arch code").

Annotate node with the __free(device_node) cleanup attribute so the
reference is released when it goes out of scope.

Found by static analysis tool CodeQL.

Fixes: 974cc7b93441 ("mfd: vexpress: Define the device as MFD cells")
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260925173252.933705-2-geoffreyhe2@gmail.com
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-versatile/v2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-versatile/v2m.c b/arch/arm/mach-versatile/v2m.c
index 79afdf2a90b6f..c86b38386cf7c 100644
--- a/arch/arm/mach-versatile/v2m.c
+++ b/arch/arm/mach-versatile/v2m.c
@@ -13,8 +13,8 @@ void vexpress_flags_set(u32 data)
 	static void __iomem *base;
 
 	if (!base) {
-		struct device_node *node = of_find_compatible_node(NULL, NULL,
-				"arm,vexpress-sysreg");
+		struct device_node *node __free(device_node) =
+			of_find_compatible_node(NULL, NULL, "arm,vexpress-sysreg");
 
 		base = of_iomap(node, 0);
 	}
-- 
2.53.0



