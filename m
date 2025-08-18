Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABDF321F50;
	Mon, 18 Aug 2025 14:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526010; cv=none; b=NHaYHLfVxclDQvhGwR9Rbemh43K1T9U0IbM+as1gpGVCmBidUM/7zQVQtAl502Gs1pvaSjxu9d87mspg1iKm3D+YMUJ6I7zARONclxucQKEGVtoK0phaYfkv4bDUB/zvzcDzeWr1RMmL7B9QbfvE7TBbCuD15a0Yu8Eng2DnDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526010; c=relaxed/simple;
	bh=its41i0EzvSb47UHP0c8iYPJEvcAxgH7H4YfLu4xUPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P8qnisIiBAobotnLF7BBBgjhxVp8Cyk9wJ/guIgC1ma9UO03QYbl2SyGfDDFeZRz/649Q83qBhjsI4PV1863UMErB0mRKN8QqWoq/gt3KufBgDbYPfS81vHzYfJx+cFvNfMSQ0EdTn6NzYawhU6uRflHMow6xvgSJpDNm9ZiJyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvqVA1g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvqVA1g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135ABC4CEEB;
	Mon, 18 Aug 2025 14:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526010;
	bh=its41i0EzvSb47UHP0c8iYPJEvcAxgH7H4YfLu4xUPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvqVA1g9sepZRc/DpuLxZK7g5Ik/oc0A5lTooVLMUR8tWiFHV0wu/6yjcFgaoU94L
	 G5zmbbJklIVhklcbVGKyaIQYZ5LJwamdNABeKK7hxUy7IMOzPXoQwR9ZPoxiN2QrEz
	 cPeFIWcpXaq24/8WdRTEQ9NETIvDlTLI0TvhEmOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 432/570] apparmor: use the condition in AA_BUG_FMT even with debug disabled
Date: Mon, 18 Aug 2025 14:46:59 +0200
Message-ID: <20250818124522.474003150@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f11a0db7f51d..e83f45e936a7 100644
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



