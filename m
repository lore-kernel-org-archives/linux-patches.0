Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC26171AE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:45:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F66C433D2;
	Mon,  8 May 2023 11:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546312;
	bh=Ua0F7NnbceNowqK9K/36YVNzl5OQzWnmG7S+7ugzIcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KN7CV44z8rm/12cCtqEB3RI2XTV694zh9LcdBBOeOVqVd4fLJI710aQmoGSozLDr
	 ER4iUShrR0r19GdApHOl6fxr2QXCKT9Oc/U/ic1VVAogs5hx6FGdKQvatAMEt2+FMd
	 GkE8mR/Xbr6+MYhZfZTCQ4+x4nU23rnrbrUzSUI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/371] powerpc/rtas: use memmove for potentially overlapping buffer copy
Date: Mon,  8 May 2023 11:48:06 +0200
Message-Id: <20230508094823.324526414@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 271208ee5e335cb1ad280d22784940daf7ddf820 ]

Using memcpy() isn't safe when buf is identical to rtas_err_buf, which
can happen during boot before slab is up. Full context which may not
be obvious from the diff:

	if (altbuf) {
		buf = altbuf;
	} else {
		buf = rtas_err_buf;
		if (slab_is_available())
			buf = kmalloc(RTAS_ERROR_LOG_MAX, GFP_ATOMIC);
	}
	if (buf)
		memcpy(buf, rtas_err_buf, RTAS_ERROR_LOG_MAX);

This was found by inspection and I'm not aware of it causing problems
in practice. It appears to have been introduced by commit
033ef338b6e0 ("powerpc: Merge rtas.c into arch/powerpc/kernel"); the
old ppc64 version of this code did not have this problem.

Use memmove() instead.

Fixes: 033ef338b6e0 ("powerpc: Merge rtas.c into arch/powerpc/kernel")
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230220-rtas-queue-for-6-4-v1-2-010e4416f13f@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/rtas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 2dae702e7a5a7..a4cd2484dbca2 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -415,7 +415,7 @@ static char *__fetch_rtas_last_error(char *altbuf)
 				buf = kmalloc(RTAS_ERROR_LOG_MAX, GFP_ATOMIC);
 		}
 		if (buf)
-			memcpy(buf, rtas_err_buf, RTAS_ERROR_LOG_MAX);
+			memmove(buf, rtas_err_buf, RTAS_ERROR_LOG_MAX);
 	}
 
 	return buf;
-- 
2.39.2



