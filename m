Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040054;
	b=LwQKOOO4fJOXp8nbNR3uXnnuG+BU0l/FxBDfA5ApaBJTDNKydomncaBNcIrINxHR9Xj+
	 l11IAeI8To4CM7sd0i+GPvG2dOtnvY49z8oyOKh/JJiHvwhzbm5Jsn9W56Km/f/eDksM3
	 TH2A41eIdffcox/tpY8hw8+mDrob61d367dZv2zFpkD/j0g1bMd4FB3rkDutCL3b495rT
	 ccudCKSJaCS9PaIhSxZD4keZNTY/XgF0ETxERT9AswCrnp2bCgPzk9B+eNehNlU0UKu14
	 jog2L5bIYxLLrLIu4Eabjr/+yfez4DOO9AlvpXLnQfpzTLNKpSZOuvWtYisU/OF1X5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fYIOxXYYvCAELs4IKPp3zEp3zAbE0ugklJJgyOwuFsc=;
	b=aHFJ/0TEvY4jIRCFpXklFWgN6lin0gq9+aW63W3oLeuFoF6//35m3Pok+09dQblYONCl
	 0irDz9C0LE9Bovb7PPjk6OFBzOXaS8xbVqdzyqCovJHqovNVPPtRdiI2NAno0s5yL464e
	 WUnmWBEe0mqRZg5z0rIqZP4KHpNGtwo1tfS7FYtMYJ6lK6q6XWfMzpuwJkat6+f2e/gfg
	 /Oa4MtlDHpT4OboA0y1A5oBobeutBbegBHQ9NgNWOv1w20DD5k6ruNR7wZt/ArCbkk3cR
	 apjuqZAABST04keX4yfsEAAgLC0cMib+D3iDWGvFMtkuNpwF31kp/CH1lcqkM5BReaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znROUKZ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB5C606A31C;
	Wed, 18 Nov 2026 22:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znROUKZ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875BE1F000C4;
	Wed, 18 Nov 2026 22:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040054;
	bh=fYIOxXYYvCAELs4IKPp3zEp3zAbE0ugklJJgyOwuFsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znROUKZ2QCdfz1jgTbMQzHnfa1f+0BJM+wTRYdzlMLAVxichbeqQkHLrX0W02ItXB
	 pq2i/lnBL2TbunNG+Rif3snVUH9POct0/YSrsYDtbkIZyB2tnSz9WbWIZsX8qifpdF
	 +dqSs7tf+svad6ncbt2IrFSTA7r4mWeFbn7fzKHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2280/3318] pstore: dont leave an ERR_PTR in the ramoops zone pointer
Date: Wed, 18 Nov 2026 15:48:22 +0100
Message-ID: <20261118150430.172886245@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 70fec428c845216da98041b1ae9f16a8f54b3d68 ]

ramoops_init_prz() stores the result of persistent_ram_new() in *prz and
returns the error without clearing it when initialization fails.
ramoops_probe() then cleans up through ramoops_free_przs(), which hands
*prz to persistent_ram_free(); that treats the ERR_PTR as a valid zone
and dereferences it, crashing the kernel.

Clear *prz before returning so that cleanup sees a NULL zone.

Fixes: b5d38e9bf1b0c ("pstore/ram: Add console messages handling")
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260921202317.70595-2-parri.andrea@gmail.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 88b34fdbf7592..736d6348a713b 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -601,6 +601,7 @@ static int ramoops_init_prz(const char *name,
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
+		*prz = NULL;
 		dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 			name, sz, (unsigned long long)*paddr, err);
 		return err;
-- 
2.53.0



