Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207634;
	b=Dfe7W8YJx0X7v2dyR/EMXOyEN1tnh4wr69giQNyF6fgl/nmSvrkrWLGErqNUHcC6ZjAl
	 xutxc/mbYEfV+lQWsnok6gq0jHHmFITuyMcsyZz2ISArV0liavYQ+FHniwVRxxI6NA0C4
	 IykxAigq+yNMkUKQfY04S0cHqf3z8uZrqbWAli/40jkyd4/lTbEMkTox8sKQHJoG8u0un
	 HbWVWHY9E/aWtABwHmF6rFimWH4RbPiWBDsU3dJb9uFdV7SIpelzu85u4iw2P+F1w9uwy
	 FrqcPQqbkpGY6AP60Oo4YKhWiwO4r8y12VUFr3Zxi1iQ1J2BxLD4462xrnzJqQyw0JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cT4slk6TKq0C+kJiuwj4XGeKsmcdL0u4xEp0tB2mtu4=;
	b=i3mB/mrpK8QJAxl9d2jqSuJywCEUq/a7jnm2eRQBlDsCScrwYGoBvqHV5uxa9Xo99aAc
	 bpIH4WiuIMmm08a+2dwGGe+ZStAlmbbjBgONT8imxUpFmKXoGnXe74WQ358Vfe/L9YNB9
	 7nlEVouaI/KIibjsR0x8JfFwWf49WqIUYcf+RqwyjE9nZ107mw0NXayD6gK3ft/An04ID
	 RSE0bp7yRk47m5DWw/p7SbG5U00ZP1vXHmrL8RBYZTMuMTEUpdDzn5jxDU1YJMmU2ImTU
	 0uLrXgiuG36wPEYvcemVO67LrmWZDZtZlCRxkk2sG3KymtngXPv+YngTn7ULooPcNWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPKzLzTG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8988606A323;
	Wed, 28 Oct 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPKzLzTG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB531F031E1;
	Wed, 28 Oct 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207633;
	bh=cT4slk6TKq0C+kJiuwj4XGeKsmcdL0u4xEp0tB2mtu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPKzLzTGY9BNNdDkhFAj/j5Ue3fN1Q+GHDrVTUiGuaKOEFTmVLUeEQ9/Dx2qDQV/A
	 lzI1qOm6QBfqikjRtmincgEmIrho4i2+Msp/w/Kemc+IZxY5ZNtdfh1YI5W1SGS4Qd
	 KzNRmutS2j+91AlyHPN8xojC9e5TrDOSRzSszNTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/247] nios2: fix __wsum type degradation in csum_fold()
Date: Wed, 28 Oct 2026 17:57:25 +0100
Message-ID: <20261028165948.367407119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b963f2345fa20417401c51a69dedb6a58eea33a9 ]

csum_fold() shifts a bitwise __wsum type, which sparse reports as
"restricted __wsum degrades to integer". Sparse only checks the body of
a static inline once something instantiates it, so this went unnoticed
until a recent block layer change added the first csum_fold() caller to
a file built on this architecture.

Force cast to a __u32 for the shift, as the other architectures do.

Fixes: eea9507a69d6 ("nios2: Library functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609222053.5gjiJjtb-lkp@intel.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
index 69004e07a1ba3..b6b415ae17a08 100644
--- a/arch/nios2/include/asm/checksum.h
+++ b/arch/nios2/include/asm/checksum.h
@@ -27,7 +27,7 @@ static inline __sum16 csum_fold(__wsum sum)
 		"add	%0, %0, r8\n"
 		"nor	%0, %0, %0\n"
 		: "=r" (sum)
-		: "r" (sum << 16), "0" (sum)
+		: "r" ((__force u32)sum << 16), "0" (sum)
 		: "r8");
 	return (__force __sum16) sum;
 }
-- 
2.53.0



