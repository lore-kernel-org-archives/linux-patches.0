Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055197;
	b=3DhxMfwfqIfP5t9e6m5ZcqiIrpi9CWmupWsriNIsZA3FBiaSKYVhe1Jlg5b1bc/7i/Jv
	 zwZqLz/cCyW9eXOo0GyozmZZvHDm9ch0suZW9dtHrLCrpl+Wtc2KR2LG6n6iLj7SLOdi3
	 nEM6xdAmqu3QRYB6ZtOxSH3WNBzv/uLpa/xtAr0ivLURWvullgaxNAT9b93YYIS/pYE+i
	 ObrC/uZgFshMkL+JQ6VKWmWkN/oC9TmCqB7pUiBLCqycO+xgoimuSSF19eeIQ4fPwpzOF
	 nC4UTqmDhEaTeiXYSytyQ9lMnEItL7AATjymG9Cp7gOztuvJInGTMO3C1U6s0FXYgzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=32Tnwwc72HM+APLIN+0XoBUdRySSttJJJtmpNQRQxcg=;
	b=sarS9t1ipWJ2z+o3qiYA/HJJzEdAm6ydbvwKutGZBkOMaRq2DkTidM3lEIO6FsdBqTH/
	 hMyc5HzL5R/EGmAC3Tc3JCz4+d3/SE3RyM021duaNHOV+2HbQMIKnndWNQ4J79Air2oqg
	 tyYK3gmqLukp63GUwu4ZWTWXWKxhfiwb9smu1dqlDC+wSwhbCBjXOh351KtrzZL/r7qf7
	 PCnih9WsoYGngScmK4M7stHrsyvNOzkbNYRiKpg7kWXDSVUogolv357tN3hpTj+sFAFb0
	 Xjzh6WkMe+tHI6KJzRBEnfqezFoRKNqTlYaqWf46NsK5FK68OpqkAPwu7MdnDE7Jzfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGVcldo2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD62606A320;
	Thu, 19 Nov 2026 02:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGVcldo2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264E51F000C5;
	Thu, 19 Nov 2026 02:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055196;
	bh=32Tnwwc72HM+APLIN+0XoBUdRySSttJJJtmpNQRQxcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGVcldo2ViHi/TIlYIxFYicOLr9mxrO0EHIRB5e66/48DJOaG6/gN/gQvmanRGiN4
	 4RCFpsxYTo4yG3xSklnyYZeN75QXJLgCxEpRvhvpsruMLgq+dqbC9iTCgLauTm2HDq
	 RPEfJYjL6HZB2K4KER/SJabgBmuyuchkRA82FxjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1544/2214] pstore: dont leave an ERR_PTR in the ramoops zone pointer
Date: Wed, 18 Nov 2026 15:53:40 +0100
Message-ID: <20261118150113.904994024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e15b4631364a8..1e28b1fdcde16 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -590,6 +590,7 @@ static int ramoops_init_prz(const char *name,
 	if (IS_ERR(*prz)) {
 		int err = PTR_ERR(*prz);
 
+		*prz = NULL;
 		dev_err(dev, "failed to request %s mem region (0x%zx@0x%llx): %d\n",
 			name, sz, (unsigned long long)*paddr, err);
 		return err;
-- 
2.53.0



