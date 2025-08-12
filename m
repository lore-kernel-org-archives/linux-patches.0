Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CF226529E;
	Tue, 12 Aug 2025 18:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023481; cv=none; b=UyS8noSJ/MpnlGYLs9at8po/0pvEckWF1TUomhRZwy4BQ4H+7NJwqSvNETr4edzsNwNbq944jH2GHnNSH028tkHgjoYIoG0SoO1MsEWAmf164mCqEJH1s0pnZVkY0PgAI0UWEO7q+2jo+58/oeYuW61zckh56kdT/IMy0R5KOuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023481; c=relaxed/simple;
	bh=XgMyzeZILvcAAGzinworXraXW+SPB4HTXNk9MCrV6Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nbaNKPH0nY/UK8r4EaoxvRvGfkBX2Z2MyYCVIenJ5tlRXeezDvQflDFtYcaqFQ4E52BZaGYcGBOPK9TTZiYuG1aLz1FS+GyIUFTzk5IAHwRUihVGF/WeoB4NHjsE3PCO15CVxzefxlKmrFVxW8ckoFOZkoM5tmvk5tOSmOaVvxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGPr6xKT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGPr6xKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DAEC4CEF0;
	Tue, 12 Aug 2025 18:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023480;
	bh=XgMyzeZILvcAAGzinworXraXW+SPB4HTXNk9MCrV6Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGPr6xKTsM+x+6/JCUvoDoR/FEdobwWMQS6t8LxDhKIFagNTZ40k0C0yTrw4ZcGcn
	 4UHEkO1ii5t9/mbkC7OcePL4vOeCzH5al+Bao1vozrxHeryKmDYdhbTQ+QnaRVnIim
	 XutWEAvvt1o76MGAf1IeGYCdkokEfKRE+VSKWdbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 091/627] tools/nolibc: avoid false-positive -Wmaybe-uninitialized through waitpid()
Date: Tue, 12 Aug 2025 19:26:26 +0200
Message-ID: <20250812173422.769940253@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 31db7b6a78b7651973c66b7cf479209b20c55290 ]

The compiler does not know that waitid() will only ever return 0 or -1.
If waitid() would return a positive value than waitpid() would return that
same value and *status would not be initialized.
However users calling waitpid() know that the only possible return values
of it are 0 or -1. They therefore might check for errors with
'ret == -1' or 'ret < 0' and use *status otherwise. The compiler will then
warn about the usage of a potentially uninitialized variable.

Example:

	$ cat test.c
	#include <stdio.h>
	#include <unistd.h>

	int main(void)
	{
		int ret, status;

		ret = waitpid(0, &status, 0);
		if (ret == -1)
			return 0;

		printf("status %x\n", status);

		return 0;
	}

	$ gcc --version
	gcc (GCC) 15.1.1 20250425

	$ gcc -Wall -Os -Werror -nostdlib -nostdinc -static -Iusr/include -Itools/include/nolibc/ -o /dev/null test.c
	test.c: In function ‘main’:
	test.c:12:9: error: ‘status’ may be used uninitialized [-Werror=maybe-uninitialized]
	   12 |         printf("status %x\n", status);
	      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	test.c:6:18: note: ‘status’ was declared here
	    6 |         int ret, status;
	      |                  ^~~~~~
	cc1: all warnings being treated as errors

Avoid the warning by normalizing waitid() errors to '-1' in waitpid().

Fixes: 0c89abf5ab3f ("tools/nolibc: implement waitpid() in terms of waitid()")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20250707-nolibc-waitpid-uninitialized-v1-1-dcd4e70bcd8f@linutronix.de
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/sys/wait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/include/nolibc/sys/wait.h b/tools/include/nolibc/sys/wait.h
index 4d44e3da0ba8..56ddb806da7f 100644
--- a/tools/include/nolibc/sys/wait.h
+++ b/tools/include/nolibc/sys/wait.h
@@ -78,7 +78,7 @@ pid_t waitpid(pid_t pid, int *status, int options)
 
 	ret = waitid(idtype, id, &info, options);
 	if (ret)
-		return ret;
+		return -1;
 
 	switch (info.si_code) {
 	case 0:
-- 
2.39.5



