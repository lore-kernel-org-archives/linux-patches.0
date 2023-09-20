Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64BD18AFA
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B0FC433C8;
	Wed, 20 Sep 2023 11:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210287;
	bh=vEn0YEfMj/eShRok9dUFyD0uq1mnKSjwHcn/uVEClew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL0JPVYo8+BickPkj/9Ac5KJUgmA04jhzuvurcRGxmAZxfLKNxcCkpoKGXMq8n8EN
	 xg2v55aVI5lha+OadBq+Vt5Jjq9yy42L9vhidMcVwDDgoW1Wbq+pkKm1XhtLIkNc51
	 uFiIXSWtpg9Qw3gOgkJSKgQ9vivJzlvstWnQpog8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 021/211] selftests/nolibc: prevent out of bounds access in expect_vfprintf
Date: Wed, 20 Sep 2023 13:27:45 +0200
Message-ID: <20230920112846.462961982@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 9c5e490093e83e165022e0311bd7df5aa06cc860 ]

If read() fails and returns -1 (or returns garbage for some other
reason) buf would be accessed out of bounds.
Only use the return value of read() after it has been validated.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 55628a25df0a3..8e7750e2eb97c 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -769,7 +769,6 @@ static int expect_vfprintf(int llen, size_t c, const char *expected, const char
 	lseek(fd, 0, SEEK_SET);
 
 	r = read(fd, buf, sizeof(buf) - 1);
-	buf[r] = '\0';
 
 	fclose(memfile);
 
@@ -779,6 +778,7 @@ static int expect_vfprintf(int llen, size_t c, const char *expected, const char
 		return 1;
 	}
 
+	buf[r] = '\0';
 	llen += printf(" \"%s\" = \"%s\"", expected, buf);
 	ret = strncmp(expected, buf, c);
 
-- 
2.40.1



