Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A266FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC1DC433EF;
	Mon, 16 Jan 2023 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888292;
	bh=3AEoe+VxjYmHaVXHeeVs2NTopcjVHvZIB8cIxVfDPt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+2NVH7i3C+AM/dgHg2J6yofGog+1BcRQqhLvdvB1a/+tq0gznX7pLGMbb4Pqx3y0
	 S/oHez+NgQL0ShyaJOuMvIXgDrE0hUcQBM5vUwk9UsUZqyzfOXKItNEoTsw2+V/HOU
	 NaNJe3fRxLFTEWIfsmIWiLW4aR2/+n3+S3GF8boo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben-linux@fluff.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 4.19 456/521] riscv: uaccess: fix type of 0 variable on error in get_user()
Date: Mon, 16 Jan 2023 16:51:58 +0100
Message-Id: <20230116154907.520547166@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
@@ -260,7 +260,7 @@ do {								\
 	might_fault();						\
 	access_ok(VERIFY_READ, __p, sizeof(*__p)) ?		\
 		__get_user((x), __p) :				\
-		((x) = 0, -EFAULT);				\
+		((x) = (__force __typeof__(x))0, -EFAULT);	\
 })
 
 #define __put_user_asm(insn, x, ptr, err)			\


