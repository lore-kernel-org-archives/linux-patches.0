Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CF131CA72;
	Mon, 18 Aug 2025 13:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522503; cv=none; b=jij3ENgj4Nca975l+Gd7osAiMquhFjjSgIgtELGrozm7sVJEhZ4SgNqgT6YukVs3TpNx4A9GRbYFOE15VquA6QOUSNTfNFpHs8gTF/VFE4B0ryZCo9cXZkxADNl2quj6hixMt5flzUtqmjWUl9oZX/uU28cre2tGgzDRU9guO3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522503; c=relaxed/simple;
	bh=WiM394SQ8w2j8Snz0eh5MFco2ujPIz67YZBdjjEizE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdrLj7TpOCzRE3JX03qMFsQNvc2aFs9NhkphHvx4IfELdFNIE2jW6840tDB7HMoyRCOy+veyMFoF9+IcHurXueSfS960lYdhF+FfQSaL4ty4yeYTFiwbqKUZD7mmGZPzk87ERANklYhvRNX9cb2snKcBoAUL/PX62ZcktDHlrl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sAi/8ZjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sAi/8ZjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC6DC4CEEB;
	Mon, 18 Aug 2025 13:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522503;
	bh=WiM394SQ8w2j8Snz0eh5MFco2ujPIz67YZBdjjEizE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAi/8ZjBlPPAIj0vI46SUSqdM3B4/IUJS+CJzJLqgR3NusPHbkhnn/bcN09Lp3xLv
	 aR/IIa2b5+xDINM4GwMmNk0gNIKdEYD7qQuCxWj+dj/rUaOw3RoUA5OXMcYUInEyAI
	 WuOuevbGczEoOoiKVoXsTw72HLOyviJCrTMDckos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/444] apparmor: use the condition in AA_BUG_FMT even with debug disabled
Date: Mon, 18 Aug 2025 14:46:02 +0200
Message-ID: <20250818124501.530514046@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit 67e370aa7f968f6a4f3573ed61a77b36d1b26475 ]

This follows the established practice and fixes a build failure for me:
security/apparmor/file.c: In function ‘__file_sock_perm’:
security/apparmor/file.c:544:24: error: unused variable ‘sock’ [-Werror=unused-variable]
  544 |         struct socket *sock = (struct socket *) file->private_data;
      |                        ^~~~

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/lib.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/apparmor/include/lib.h b/security/apparmor/include/lib.h
index d7a894b1031f..1ec00113a056 100644
--- a/security/apparmor/include/lib.h
+++ b/security/apparmor/include/lib.h
@@ -48,7 +48,11 @@ extern struct aa_dfa *stacksplitdfa;
 #define AA_BUG_FMT(X, fmt, args...)					\
 	WARN((X), "AppArmor WARN %s: (" #X "): " fmt, __func__, ##args)
 #else
-#define AA_BUG_FMT(X, fmt, args...) no_printk(fmt, ##args)
+#define AA_BUG_FMT(X, fmt, args...)					\
+	do {								\
+		BUILD_BUG_ON_INVALID(X);				\
+		no_printk(fmt, ##args);					\
+	} while (0)
 #endif
 
 #define AA_ERROR(fmt, args...)						\
-- 
2.39.5



