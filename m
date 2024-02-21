Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377244D5B7;
	Wed, 21 Feb 2024 13:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523170; cv=none; b=VLKQ237XEfUy3lsyi9Fvxk7MX8u/Tml7iym3BUePty6Va0RC6DLVXpyPF/06rLnYyIb3hmoZ8VHrqnl7BjCI4waUzE0qgSK89RWZYV6rHTcjrFbo8qI72qNl/quCmUCSXS9cRPSQpCE0I6j9nIayGZw9WzLeFIdDmjzFFRDB3+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523170; c=relaxed/simple;
	bh=HFq9luowGub6VNB9S2FpxbQR/M/9N6Ey/XWvuqwyhcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYqrrvqCeBTUuzVjrqcop5NqWsXhWqU73q6kLwFA4E2c9wf/Ods4+HuO7kuH/B5XjwVlbZv0/IlN5PDUFSSuwdY26BoQpgfiEWq79AV8//lklhs42j+ST0+hpgps2bcv52IQ03OZyz0zvcMWV8qlYpa5KI/vsvb0BaOhZZ1Uim0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCckHDDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCckHDDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EFBC433C7;
	Wed, 21 Feb 2024 13:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523169;
	bh=HFq9luowGub6VNB9S2FpxbQR/M/9N6Ey/XWvuqwyhcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCckHDDHmSvjVsNeTZhTThdVoF4OxLbUFq/eQlXP2t69KiT4xSXvpMsxyhUiGZ0pQ
	 hbBcu3XWTaVcLe2mvOblJY0HIsWJgCPxsr7QGr+ffIU+IymaqFqdbFGx/HvlgsRtxe
	 rzg4uv8g6XJzW24lgV8zSK0yNEY1twUzSTWJb9gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 329/476] drivers: lkdtm: fix clang -Wformat warning
Date: Wed, 21 Feb 2024 14:06:20 +0100
Message-ID: <20240221130020.181805789@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit b4909252da9be56fe1e0a23c2c1908c5630525fa ]

When building with Clang we encounter the following warning
(ARCH=hexagon + CONFIG_FRAME_WARN=0):
| ../drivers/misc/lkdtm/bugs.c:107:3: error: format specifies type
| 'unsigned long' but the argument has type 'int' [-Werror,-Wformat]
|                 REC_STACK_SIZE, recur_count);
|                 ^~~~~~~~~~~~~~

Cast REC_STACK_SIZE to `unsigned long` to match format specifier `%lu`
as well as maintain symmetry with `#define REC_STACK_SIZE
(_AC(CONFIG_FRAME_WARN, UL) / 2)`.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Reported-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Justin Stitt <justinstitt@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Kees Cook <keescook@chromium.org>
Fixes: 24cccab42c419 ("lkdtm/bugs: Adjust recursion test to avoid elision")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20220721215706.4153027-1-justinstitt@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/bugs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index fac4a811b97b..3ab8dbae96af 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -29,7 +29,7 @@ struct lkdtm_list {
 #if defined(CONFIG_FRAME_WARN) && (CONFIG_FRAME_WARN > 0)
 #define REC_STACK_SIZE (_AC(CONFIG_FRAME_WARN, UL) / 2)
 #else
-#define REC_STACK_SIZE (THREAD_SIZE / 8)
+#define REC_STACK_SIZE (THREAD_SIZE / 8UL)
 #endif
 #define REC_NUM_DEFAULT ((THREAD_SIZE / REC_STACK_SIZE) * 2)
 
-- 
2.43.0



