Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018047;
	b=q4OXj1jwsHW3+ekDv/zaazEO8nfsr8WOw+QhDmqLmsd9U+3tixPKCGQgc1GfNm2BEOqN
	 lU41QbhCnv9RovXO6iVxxPHxoPaPpcJfbSZ5UkyX/KydawRI4jWfF5VqWsLkkD+I1g6M0
	 5yZCVXsfOE8gN8Dyf0aptBehZOHzX3Tqoeda9DSCZ3ezTRNzQmqp268lgZRSN7giNWWM/
	 djmSRL66UovI7lG3nl68xdhmmxK9s6WMkP84hs74WIxGNgut1IXZesyjhAkcugE36flgi
	 BbWKu0kMUqnCR9UdY7NHb9/ee+wD4BCivs6K0ETiGI9DpwKuIcFTc5TlBVkrtWe+WpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lS9SzcCVoecdjqW2+p9zFcYKPWmyQo2xb576yKW4gtY=;
	b=mwRQA28g/GWgLBC7kxKjG9sM0Wu+gY680sTSgi/Qti/1vQyYo/VVuzBA0nAwuCYtv5Ra
	 vJRmNSqq9CKEH2xQXCcdB6ld7yob8icthTlpv7fMSPiHvYpb8WNB0vIVczCA/0GbYTYVd
	 jvZA4MzPzL3+PAIl3V/d4RCVWdDEfPc+LaOMaopLIobNB7khzIJo4rpCj+93YyK+g3NlH
	 ntJlXq8F7b+uq93KdV4XTiFqpJWHKtyFVHqjqtCBuqZ7TaEj4wAMsrrsCrXVHpLVCtD2I
	 pOQq7sHqdThW3cMxvEkxadKQnmfNqtPYP8Ww6iE7NiuvUfbNnJYZiGAH7enveYVUkPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BYREawvA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D19606A320;
	Wed, 18 Nov 2026 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BYREawvA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277311F000C4;
	Wed, 18 Nov 2026 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018047;
	bh=lS9SzcCVoecdjqW2+p9zFcYKPWmyQo2xb576yKW4gtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYREawvAOlFwAp8vXIniROoHfyjhgs1DkA7Zk++vgvAiWV4T+VEMqKKwj3Og2y7cb
	 tq8/NrJDnClMKhw/Sz/RFmtRm2dWNwOZE1AG7dA9MQa58jUcZkXtMkusobg6yjioo4
	 vS3nTnrzjrIPaNM+bpEzPfP4HoErBAFU4hSGToiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1102/2651] ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()
Date: Wed, 18 Nov 2026 15:39:02 +0100
Message-ID: <20261118150327.670207653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



