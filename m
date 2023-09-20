Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA172AB26
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52BBC433D9;
	Wed, 20 Sep 2023 11:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210252;
	bh=YxRkl49tVAJaZ/gx+qRy2ggAaixFGB38AwGWXMq7XfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0JaW3htr4Iec/jlTNjGCL2ZO+a/pODeR9kRln1M5GdxYshXEnlBPtYaSwQ89qogd
	 73/zAMAuIREqCQuMa6O/GUrYDbmr3CfeFUP+ytoMgFDFjCvEiCtAuhSrmBGr523qjz
	 dfqgd+4tnGIqVmMCLV74w8EjOW1MOZ30XiHeu5bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Zhangjin Wu <falcon@tinylab.org>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 020/211] selftests/nolibc: fix up kernel parameters support
Date: Wed, 20 Sep 2023 13:27:44 +0200
Message-ID: <20230920112846.434056704@linuxfoundation.org>
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

From: Zhangjin Wu <falcon@tinylab.org>

[ Upstream commit c388c9920da2679f62bec48d00ca9e80e9d0a364 ]

kernel parameters allow pass two types of strings, one type is like
'noapic', another type is like 'panic=5', the first type is passed as
arguments of the init program, the second type is passed as environment
variables of the init program.

when users pass kernel parameters like this:

    noapic NOLIBC_TEST=syscall

our nolibc-test program will use the test setting from argv[1] and
ignore the one from NOLIBC_TEST environment variable, and at last, it
will print the following line and ignore the whole test setting.

    Ignoring unknown test name 'noapic'

reversing the parsing order does solve the above issue:

    test = getenv("NOLIBC_TEST");
    if (test)
        test = argv[1];

but it still doesn't work with such kernel parameters (without
NOLIBC_TEST environment variable):

    noapic FOO=bar

To support all of the potential kernel parameters, let's verify the test
setting from both of argv[1] and NOLIBC_TEST environment variable.

Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Zhangjin Wu <falcon@tinylab.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 33 ++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 486334981e601..55628a25df0a3 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -939,6 +939,35 @@ static const struct test test_names[] = {
 	{ 0 }
 };
 
+int is_setting_valid(char *test)
+{
+	int idx, len, test_len, valid = 0;
+	char delimiter;
+
+	if (!test)
+		return valid;
+
+	test_len = strlen(test);
+
+	for (idx = 0; test_names[idx].name; idx++) {
+		len = strlen(test_names[idx].name);
+		if (test_len < len)
+			continue;
+
+		if (strncmp(test, test_names[idx].name, len) != 0)
+			continue;
+
+		delimiter = test[len];
+		if (delimiter != ':' && delimiter != ',' && delimiter != '\0')
+			continue;
+
+		valid = 1;
+		break;
+	}
+
+	return valid;
+}
+
 int main(int argc, char **argv, char **envp)
 {
 	int min = 0;
@@ -964,10 +993,10 @@ int main(int argc, char **argv, char **envp)
 	 *    syscall:5-15[:.*],stdlib:8-10
 	 */
 	test = argv[1];
-	if (!test)
+	if (!is_setting_valid(test))
 		test = getenv("NOLIBC_TEST");
 
-	if (test) {
+	if (is_setting_valid(test)) {
 		char *comma, *colon, *dash, *value;
 
 		do {
-- 
2.40.1



