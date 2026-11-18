Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040552;
	b=0ZaotZw2/9jn26OQ0rAqB7luJHwY2jp0OoyI8n481+JH5Sglmpe0+AI/qWBVVfwZuIUd
	 mCaYndrctQgxMK6AUZWz5Kb/fB37InvNbPMUkhMX4OnBXwJ/aDUnvwGpqQVBJFyC/abco
	 L8nDmssWKTywyIkLp8U381GINDzr2stKBSEDMqFkFRvQjGMIDNY1Fb1qTNa6kfv6v8TLi
	 HHZ2zJBru5oWMvSMGaHNtQpFOgKL0zNE9+J0tDQ/CkYVQC7npajzfXg7smWGiHS1OjmKs
	 rAIwdUDHzjA6GlnEA/fedk/+bBfWBpGkreWGAHauivUPz3cqggRIZuMEesBWasR9evA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NSyQnXjUXRuv4+TO3aaFczQNXd2uGmUavWH1cij0lo4=;
	b=K3ZyRVmUon3buEyHyZ7QKy9s9Us3yS97avBGW1DJwQUnkQq1m9J4aYSNSZROO4OdxkDE
	 RbvbQ4CPgtAn6OyNwrtbhGISOp4Vq4x1fTq61xjwsdJctRKNe0esqgXN4+spB3CPdQoKh
	 Ua4ApzvlBfajHte3LDculIzQeZxcA1k+XBbZtwuE+N/n5Fl2DdBNIQZweNKh/2TXPAAag
	 bwMDcattbg8jX2rPrAqRlMAPPHjv49zWcMuIlHUCEz5be9RxN3S8l9SN8YHBFFZmWOwOh
	 9cB/TpA+WU0DlUhCkvtrtv0Lrph7TxAMtalo2LDkwdrMMkNaSg2+ZUoahEmbeE/uA2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FELV3+MZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC65606A33A;
	Wed, 18 Nov 2026 22:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FELV3+MZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B03C1F000C9;
	Wed, 18 Nov 2026 22:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040552;
	bh=NSyQnXjUXRuv4+TO3aaFczQNXd2uGmUavWH1cij0lo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FELV3+MZKt2nzlVGKWn4UStLRCBnDpAYcsYtXKmu1zZCUG3e+FZV7J4enLu+T1xdx
	 T1OgSUp8FgaxZq8DHf7SQ/UGflLWTEDSO+JB154pHA3cs2AFLDpFfivRsuGMP5vYjD
	 F8wC6YeOXDWaJLq2MyaP7kWzZ3kgkUXJYoeaasyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2491/3318] ARM: vexpress: fix device_node refcount leak in vexpress_flags_set()
Date: Wed, 18 Nov 2026 15:51:53 +0100
Message-ID: <20261118150436.119678336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



