Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAA328E00
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6037DC433C7;
	Wed, 20 Sep 2023 11:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210841;
	bh=iQRFsRwKGwhEZzvsQaInc/4XYUR9jj/XHwakKiNJ/L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiEpFvaH5lmk7owvUx1/xhFQamscizrUBmfV4Ll/vNOSapQhn8/tTDhaC8mfrehs6
	 MGaJfruYX9TgCvKFjoyOnL3109b0Z/m9hN09i/8e7LMzKQnazYUSmRrBGNj2xc7eP3
	 Ep1EDWQorAAFQzy04F5YcUz95wLsTHWIQ+394w3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Zhangjin Wu <falcon@tinylab.org>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/139] selftests/nolibc: fix up kernel parameters support
Date: Wed, 20 Sep 2023 13:29:07 +0200
Message-ID: <20230920112836.097539996@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 78bced95ac630..f8e8e8d2a5e18 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -630,6 +630,35 @@ static struct test test_names[] = {
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
@@ -655,10 +684,10 @@ int main(int argc, char **argv, char **envp)
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



