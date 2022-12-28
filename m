Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889591C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E62C433EF;
	Wed, 28 Dec 2022 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246411;
	bh=X9QyHZW0/Q7y1ozPfSbuoElW40mP7FohwywJd74HR88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtrzdd+A+KHpMWzIZ63mRRcurIhTk//ThdPntyPaeAYebsfawJWaS12mk+Uk5PVef
	 ObVrVZop0pXeiLBU1TCLa3q0j/6qjp4WFf/NFt0gCsoBbN1yQb72iRO3iMZLNhrZJz
	 lmYjtgDVV2l57+y7JxksAKK4x18hPyE+n/9v7ZPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1036/1146] selftests/bpf: Fix conflicts with built-in functions in bpf_iter_ksym
Date: Wed, 28 Dec 2022 15:42:55 +0100
Message-Id: <20221228144358.494529805@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit ab0350c743d5c93fd88742f02b3dff12168ab435 ]

Both tolower and toupper are built in c functions, we should not
redefine them as this can result in a build error.

Fixes the following errors:
progs/bpf_iter_ksym.c:10:20: error: conflicting types for built-in function 'tolower'; expected 'int(int)' [-Werror=builtin-declaration-mismatch]
   10 | static inline char tolower(char c)
      |                    ^~~~~~~
progs/bpf_iter_ksym.c:5:1: note: 'tolower' is declared in header '<ctype.h>'
    4 | #include <bpf/bpf_helpers.h>
  +++ |+#include <ctype.h>
    5 |
progs/bpf_iter_ksym.c:17:20: error: conflicting types for built-in function 'toupper'; expected 'int(int)' [-Werror=builtin-declaration-mismatch]
   17 | static inline char toupper(char c)
      |                    ^~~~~~~
progs/bpf_iter_ksym.c:17:20: note: 'toupper' is declared in header '<ctype.h>'

See background on this sort of issue:
https://stackoverflow.com/a/20582607
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=12213

(C99, 7.1.3p1) "All identifiers with external linkage in any of the
following subclauses (including the future library directions) are
always reserved for use as identifiers with external linkage."

This is documented behavior in GCC:
https://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html#index-std-2

Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20221203010847.2191265-1-james.hilliard1@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_ksym.c b/tools/testing/selftests/bpf/progs/bpf_iter_ksym.c
index 285c008cbf9c..9ba14c37bbcc 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_ksym.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_ksym.c
@@ -7,14 +7,14 @@ char _license[] SEC("license") = "GPL";
 
 unsigned long last_sym_value = 0;
 
-static inline char tolower(char c)
+static inline char to_lower(char c)
 {
 	if (c >= 'A' && c <= 'Z')
 		c += ('a' - 'A');
 	return c;
 }
 
-static inline char toupper(char c)
+static inline char to_upper(char c)
 {
 	if (c >= 'a' && c <= 'z')
 		c -= ('a' - 'A');
@@ -54,7 +54,7 @@ int dump_ksym(struct bpf_iter__ksym *ctx)
 	type = iter->type;
 
 	if (iter->module_name[0]) {
-		type = iter->exported ? toupper(type) : tolower(type);
+		type = iter->exported ? to_upper(type) : to_lower(type);
 		BPF_SEQ_PRINTF(seq, "0x%llx %c %s [ %s ] ",
 			       value, type, iter->name, iter->module_name);
 	} else {
-- 
2.35.1



