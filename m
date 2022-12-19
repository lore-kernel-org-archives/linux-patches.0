Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634E76FB4
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 19:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D65C433D2;
	Mon, 19 Dec 2022 19:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671477973;
	bh=/TqIw1Go68J3IFv50DN87DHGS+eQnoFyvcI2YXQRe3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPN7fcwg9Vs71a9N6+1ZBXfrIp9lcjPZ9+oN5qoj5lBCUXHNTGgu3b9EdUwjhVUTD
	 wYS11M49hqlPElMKSZRWEt58Y7JmmONihYft52pam3cYPc/vOkuKok/oz/nHaIsOXY
	 VsgYk5uAIx8NTLIO8oeZ+NWHDxgzkfjLxLKviXBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 06/28] selftests/bpf: Add load_kallsyms_refresh function
Date: Mon, 19 Dec 2022 20:22:53 +0100
Message-Id: <20221219182944.449867261@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Olsa <jolsa@kernel.org>

commit 10705b2b7a8e4eb46ab5bf1b9ee354cb9a929428 upstream.

Adding load_kallsyms_refresh function to re-read symbols from
/proc/kallsyms file.

This will be needed to get proper functions addresses from
bpf_testmod.ko module, which is loaded/unloaded several times
during the tests run, so symbols might be already old when
we need to use them.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-6-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/trace_helpers.c |   20 +++++++++++++-------
 tools/testing/selftests/bpf/trace_helpers.h |    2 ++
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -23,7 +23,7 @@ static int ksym_cmp(const void *p1, cons
 	return ((struct ksym *)p1)->addr - ((struct ksym *)p2)->addr;
 }
 
-int load_kallsyms(void)
+int load_kallsyms_refresh(void)
 {
 	FILE *f;
 	char func[256], buf[256];
@@ -31,12 +31,7 @@ int load_kallsyms(void)
 	void *addr;
 	int i = 0;
 
-	/*
-	 * This is called/used from multiplace places,
-	 * load symbols just once.
-	 */
-	if (sym_cnt)
-		return 0;
+	sym_cnt = 0;
 
 	f = fopen("/proc/kallsyms", "r");
 	if (!f)
@@ -57,6 +52,17 @@ int load_kallsyms(void)
 	return 0;
 }
 
+int load_kallsyms(void)
+{
+	/*
+	 * This is called/used from multiplace places,
+	 * load symbols just once.
+	 */
+	if (sym_cnt)
+		return 0;
+	return load_kallsyms_refresh();
+}
+
 struct ksym *ksym_search(long key)
 {
 	int start = 0, end = sym_cnt;
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -10,6 +10,8 @@ struct ksym {
 };
 
 int load_kallsyms(void);
+int load_kallsyms_refresh(void);
+
 struct ksym *ksym_search(long key);
 long ksym_get_addr(const char *name);
 


