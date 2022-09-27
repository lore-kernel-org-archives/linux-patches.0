Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453DF80C
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 13:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD417C433C1;
	Tue, 27 Sep 2022 13:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664284557;
	bh=vAAEpjl7gdo2NZ1wWJKQpSd6KTl+oelIC5q3HFgBipw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YN3VOrp1+OULQhIhLpElyhPgoYjbxY+JsYn/DwC7xRRiaQ4i3YhT+r59ayKuKLEHi
	 dHMKv4eplFYHd5tzdRzs2+puUwzqwTU+8ySK8JB9/4933T87DJPRNh2N003h52QaFV
	 0bD9JEaMivZZSfwnUgqru8/AS8mN9ol4EeLZ4YGasXz7+hwapF4KZpZiYN00+9071j
	 Oungei7XjHc7GiZessEoymIRa/1bEI/Yps2cI9lixJHpEEO2nkL+vZSSzJyMb/eQ1+
	 hcYHlcYVytbFMhQ63di0mlWSUSyun3+9pFYlhaWyf6ZB9TkA1ghykZuDSn1WI8cKyt
	 HWUPPGnt9r1xQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH v10 02/27] kallsyms: avoid hardcoding buffer size
Date: Tue, 27 Sep 2022 15:14:33 +0200
Message-Id: <20220927131518.30000-3-ojeda@kernel.org>
In-Reply-To: <20220927131518.30000-1-ojeda@kernel.org>
References: <20220927131518.30000-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Boqun Feng <boqun.feng@gmail.com>

This introduces `KSYM_NAME_LEN_BUFFER` in place of the previously
hardcoded size of the input buffer.

It will also make it easier to update the size in a single place
in a later patch.

Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/kallsyms.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 8551513f9311..25e2fe5fbcd4 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -27,8 +27,14 @@
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 
+#define _stringify_1(x)	#x
+#define _stringify(x)	_stringify_1(x)
+
 #define KSYM_NAME_LEN		128
 
+/* A substantially bigger size than the current maximum. */
+#define KSYM_NAME_LEN_BUFFER	499
+
 struct sym_entry {
 	unsigned long long addr;
 	unsigned int len;
@@ -198,13 +204,13 @@ static void check_symbol_range(const char *sym, unsigned long long addr,
 
 static struct sym_entry *read_symbol(FILE *in)
 {
-	char name[500], type;
+	char name[KSYM_NAME_LEN_BUFFER+1], type;
 	unsigned long long addr;
 	unsigned int len;
 	struct sym_entry *sym;
 	int rc;
 
-	rc = fscanf(in, "%llx %c %499s\n", &addr, &type, name);
+	rc = fscanf(in, "%llx %c %" _stringify(KSYM_NAME_LEN_BUFFER) "s\n", &addr, &type, name);
 	if (rc != 3) {
 		if (rc != EOF && fgets(name, ARRAY_SIZE(name), in) == NULL)
 			fprintf(stderr, "Read error or end of file.\n");
-- 
2.37.3

