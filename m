Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D70D79CF
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:38:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3DDC433F0;
	Thu, 12 Jan 2023 14:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673534325;
	bh=zyixeITa0MAXp7uZnaFI7xF7lLPKtNyRF61slFzk6zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXevAPL48NkHSSiOroVv18/iEnHN5GLlTtAC17CygNnBmHPaEsh3/J+FSrhK61G8b
	 pO3zsNvS2N9T8vFX7MRiHlYsrHM5osLhXBNLMNSadAT5tVKZtCO49KFB13CrqJAu/C
	 kR+gq1TTQQG2z0qR8C8+TlwIU/ievm1qxaF1s59I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben-linux@fluff.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 763/783] riscv: uaccess: fix type of 0 variable on error in get_user()
Date: Thu, 12 Jan 2023 14:57:59 +0100
Message-Id: <20230112135559.733800900@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Dooks <ben-linux@fluff.org>

commit b9b916aee6715cd7f3318af6dc360c4729417b94 upstream.

If the get_user(x, ptr) has x as a pointer, then the setting
of (x) = 0 is going to produce the following sparse warning,
so fix this by forcing the type of 'x' when access_ok() fails.

fs/aio.c:2073:21: warning: Using plain integer as NULL pointer

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
Link: https://lore.kernel.org/r/20221229170545.718264-1-ben-linux@fluff.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -216,7 +216,7 @@ do {								\
 	might_fault();						\
 	access_ok(__p, sizeof(*__p)) ?		\
 		__get_user((x), __p) :				\
-		((x) = 0, -EFAULT);				\
+		((x) = (__force __typeof__(x))0, -EFAULT);	\
 })
 
 #define __put_user_asm(insn, x, ptr, err)			\


