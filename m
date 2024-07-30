Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7C91A76A4;
	Tue, 30 Jul 2024 17:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359998; cv=none; b=gGriHZ4zbO/CAoDXQWleghU6DFHtHUvhdGzj2Uw+XxXn7Pb+OGUjuFy+/iHjmUfoVgs3/nc019OPQqJqdCnEakQHOP3EOxBPugshQlZ89wlDyqWJTUzDJDTUQJzVkQ/jX1w4HmV3bmHRgGCUibrJl5I4BpkyGNAAuJYbN25gl94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359998; c=relaxed/simple;
	bh=M0Q7UbI5qqZYgj5Dxp/9xQLWdLkEvO1vlgcDrplndU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dMZpu/0pJxUrwicPGWRqdvMj6zibfRQt+WdLoXoRes5ZBg0mrPTDxJl3mhdtS2FOS5kGYpmhtlpPT5Jt6RjJeSrlLbsK5FYGv1ljmhQ4awu7WmZB0aj34BXM33rq94v7NvO4vNUlE+jSWDpZQq/pOGWda+yKhkKvze/NOEbbv/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PC19OykN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PC19OykN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A07C4AF0C;
	Tue, 30 Jul 2024 17:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359998;
	bh=M0Q7UbI5qqZYgj5Dxp/9xQLWdLkEvO1vlgcDrplndU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC19OykNp19cbVbRq0i2GdZUwtVr699kvCzaxj+mNL5UiKxcaSZq/79g8J/I7+qj6
	 MXMrKoOusWhuHbFSjGpMLCWdfRvDO3dB+JvHa4cwwCTiMrTKacadAXzAdi05Z9/lrN
	 KFSyx1NITnZC2aMDkE8l/+TuUSLin2U5QTQuQhAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.10 566/809] selftests/nolibc: fix printf format mismatch in expect_str_buf_eq()
Date: Tue, 30 Jul 2024 17:47:22 +0200
Message-ID: <20240730151747.128167726@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 92098b1c10cb29bcc6fa0908a766dc9e16b1e889 upstream.

Fix the following compiler warning on 32bit:

  i386-linux-gcc -Os -fno-ident -fno-asynchronous-unwind-tables -std=c89 -W -Wall -Wextra -fno-stack-protector -m32 -mstack-protector-guard=global -fstack-protector-all  -o nolibc-test \
    -nostdlib -nostdinc -static -Isysroot/i386/include nolibc-test.c nolibc-test-linkage.c -lgcc
  nolibc-test.c: In function 'expect_str_buf_eq':
  nolibc-test.c:610:30: error: format '%lu' expects argument of type 'long unsigned int', but argument 2 has type 'size_t' {aka 'unsigned int'} [-Werror=format=]
    610 |         llen += printf(" = %lu <%s> ", expr, buf);
        |                            ~~^         ~~~~
        |                              |         |
        |                              |         size_t {aka unsigned int}
        |                              long unsigned int
        |                            %u

Fixes: 1063649cf531 ("selftests/nolibc: Add tests for strlcat() and strlcpy()")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 94bb6e11c16f..994477ee87be 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -607,7 +607,7 @@ int expect_strne(const char *expr, int llen, const char *cmp)
 static __attribute__((unused))
 int expect_str_buf_eq(size_t expr, const char *buf, size_t val, int llen, const char *cmp)
 {
-	llen += printf(" = %lu <%s> ", expr, buf);
+	llen += printf(" = %lu <%s> ", (unsigned long)expr, buf);
 	if (strcmp(buf, cmp) != 0) {
 		result(llen, FAIL);
 		return 1;
-- 
2.45.2



