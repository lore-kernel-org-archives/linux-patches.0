Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714BD1E86E;
	Mon, 18 Aug 2025 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524308; cv=none; b=BQWLU2WlOmVref3NkEUnwvthORcFOgcrhfvcllDYppoaiUmlwNJ9CRmhUurMArZS6wL2mrOJ00+u8E5yVa5dSUWOXd4B6N9ghuEaDSKLAO+so5tBgQSvl9N0yUV5A741z+zsk5QgqLOob/oJUYUSKtEmS7VzPKk94gURTbKpxUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524308; c=relaxed/simple;
	bh=NpCvuVFq3AY4tJNlJu6EwrcQv588WfUUXL4QlVBCDGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LllgoAGUUg5ZJY2RcpBbtiWx14Y9qfiKm9EsQooGYwl/M2QyH6DQMZ6AGwIvAjqMXvjwQIITgmiqbiGWFVi6/BZBNgJUCdCfg5W6RrffhRUN1j+n/446CUWXCZqo8KUayLExD0TY9v+aULWbLyP6Vum2NQ5tmUvQzQYzSqOIO9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSkaloQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSkaloQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B74C113D0;
	Mon, 18 Aug 2025 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524308;
	bh=NpCvuVFq3AY4tJNlJu6EwrcQv588WfUUXL4QlVBCDGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSkaloQa6CZb/KLznZF2GAbq35dQUnKQfjBmLNV1dkDR+rn9mWL0qYyqgH5Fwr0vs
	 ZjrLbXhgL5nVbxx/DQd2/rbu9gTn/oICYC2NxZzcnGZQJA/NYaNpmmL79DjgABqbjv
	 f4mbAArn6enJXjQbR/dtcQH9NunvEI3x3Z36v6P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 399/515] apparmor: use the condition in AA_BUG_FMT even with debug disabled
Date: Mon, 18 Aug 2025 14:46:25 +0200
Message-ID: <20250818124513.770520755@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



