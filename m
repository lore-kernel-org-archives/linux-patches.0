Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048561;
	b=3BfYk4/YXnhFRmmo5aNmVGYPUQdSqaoSeHa5WnVVXMjGItKhtMMAvYoa3dTPbX3Y6YR3
	 jHvCrwcJ2udNRKcLiRmERjzTsD2f3bEp9Uu/HSFtz3kHGA6LhE3P3RSkdjMmI6PXWwiDZ
	 MJpbvBwTRFeD642zbSNzmelprgcIZIGJdrMmM0EeuKaZkYclVrv1rh+UDcA9YVqwiuEMW
	 YfLQBGlhYyVZO07QEyVWSvCUMIGnbJXIRlBB3CSRZe4qZ/jZhXkNwMM9RNdd77to4PPRA
	 9QbY1+CzuvzM4JCAWuf3gQG3u7WBIUSCeva3fXoUVuhejaRC2Ue9xQBesBFj82nJnDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YgaV1yNXUO+11iA9jLwYj20Tc8E2akGZ2gowjjnPS0E=;
	b=5bC5mhrDwD9HxV4S2EYmsiZ2ZFZ3K+VmYwDAVhat1KCol9q4T/UjPijIz/4qpzF3eAuw
	 t2fTm/80AwSHuHWrUGmmGaKqoXgJcYWXyDsngy7h8eNUNYOS6e/xMxSyPAsv12ctFUqkl
	 wf97b5UcqX2pzPPKYFdiazQ8biM1GixzVjTJTOARMDDSjC4OsMk/jBsXY2DzFSv5Ht3O2
	 kh7mN8d+cEgKridGSniG84VVp+7s2FxN4JloWkJfQ4EwwfW3EV8RekNrv6PZlKNx6oNac
	 drdgZVs/LzS62y1lyVjSJjy1IIhl6XzH5gZffmKvMP8rQ/V2JFom3UD1D0OJOHVkPpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5i6G6Y+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFC3606A325;
	Thu, 19 Nov 2026 00:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U5i6G6Y+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964611F000C4;
	Thu, 19 Nov 2026 00:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048561;
	bh=YgaV1yNXUO+11iA9jLwYj20Tc8E2akGZ2gowjjnPS0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U5i6G6Y+fzJW7NzhOIOWAlppc82XIZhkKlWuRNQuX4Zlgz1jP3eegOYKaxWlB3NtF
	 y4kxJvi4zr8VjG+lDxYOUKdNwZp8MGeVqkjkItmmo4YsGYkMAvFrTVVbNbzW5dMT+Z
	 5gCnM+yFGANpuA+Fqekyl++6uBgTiImYZ4Ai0IYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1987/2857] pstore: dont leave an ERR_PTR in the ramoops zone pointer
Date: Wed, 18 Nov 2026 15:50:21 +0100
Message-ID: <20261118150312.920766858@linuxfoundation.org>
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



