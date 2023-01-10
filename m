Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A3A6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C0BC433D2;
	Tue, 10 Jan 2023 18:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374808;
	bh=5aFHYIVxMfb6Kc0qnVsY3n++IxGDVygAskwKw6gclMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNBj3HXmTrftZAblEOEorOmvc+UFi+e1cjR+tGQI3h2T+zyAgrnZec9F1BE0c5M5y
	 P5Ovt97bgo+IhTTTHErJaRcBJLQbwtVUPulXGW7kNPUZs9i2gtZP0JoAAPPhXA8/s+
	 RK97XyAvI0PjFHF6w4tOebn9c8OynR4tkr/PDMWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben-linux@fluff.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 141/159] riscv: uaccess: fix type of 0 variable on error in get_user()
Date: Tue, 10 Jan 2023 19:04:49 +0100
Message-Id: <20230110180022.918428594@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
@@ -165,7 +165,7 @@ do {								\
 	might_fault();						\
 	access_ok(__p, sizeof(*__p)) ?		\
 		__get_user((x), __p) :				\
-		((x) = 0, -EFAULT);				\
+		((x) = (__force __typeof__(x))0, -EFAULT);	\
 })
 
 #define __put_user_asm(insn, x, ptr, err)			\


