Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C50415E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hoL0iwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA2BC433C8;
	Mon, 23 Oct 2023 11:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060469;
	bh=ANLp9EHGumIP9oIrUFxJjW7FxaJ7tKmmnrwnzPdJhOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hoL0iwMq+akAeV4lvjIS1TSkM+kigqjl7P7EbLK/VVa2Mgv71NxaqNRY6cpf7QTT
	 dGoxVVd4efHeWyEAsNq2fw6dWZ0+GxI1wnu9oGu8ZTUXFjhx/GStLUJmKLN38me/wX
	 mZtOipFDEpTNpzmk8LQivqx4A3DvDZh5TNMAbX6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 183/196] kallsyms: Reduce the memory occupied by kallsyms_seqs_of_names[]
Date: Mon, 23 Oct 2023 12:57:28 +0200
Message-ID: <20231023104833.563121736@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 19bd8981dc2ee35fdc81ab1b0104b607c917d470 ]

kallsyms_seqs_of_names[] records the symbol index sorted by address, the
maximum value in kallsyms_seqs_of_names[] is the number of symbols. And
2^24 = 16777216, which means that three bytes are enough to store the
index. This can help us save (1 * kallsyms_num_syms) bytes of memory.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: b022f0c7e404 ("tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kallsyms.c          | 18 ++++++++++++++----
 kernel/kallsyms_internal.h |  2 +-
 scripts/kallsyms.c         |  5 ++++-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index ad3cccb0970f8..32cba13eee6c4 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -197,6 +197,16 @@ static int compare_symbol_name(const char *name, char *namebuf)
 	return strcmp(name, namebuf);
 }
 
+static unsigned int get_symbol_seq(int index)
+{
+	unsigned int i, seq = 0;
+
+	for (i = 0; i < 3; i++)
+		seq = (seq << 8) | kallsyms_seqs_of_names[3 * index + i];
+
+	return seq;
+}
+
 static int kallsyms_lookup_names(const char *name,
 				 unsigned int *start,
 				 unsigned int *end)
@@ -211,7 +221,7 @@ static int kallsyms_lookup_names(const char *name,
 
 	while (low <= high) {
 		mid = low + (high - low) / 2;
-		seq = kallsyms_seqs_of_names[mid];
+		seq = get_symbol_seq(mid);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 		ret = compare_symbol_name(name, namebuf);
@@ -228,7 +238,7 @@ static int kallsyms_lookup_names(const char *name,
 
 	low = mid;
 	while (low) {
-		seq = kallsyms_seqs_of_names[low - 1];
+		seq = get_symbol_seq(low - 1);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 		if (compare_symbol_name(name, namebuf))
@@ -240,7 +250,7 @@ static int kallsyms_lookup_names(const char *name,
 	if (end) {
 		high = mid;
 		while (high < kallsyms_num_syms - 1) {
-			seq = kallsyms_seqs_of_names[high + 1];
+			seq = get_symbol_seq(high + 1);
 			off = get_symbol_offset(seq);
 			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
 			if (compare_symbol_name(name, namebuf))
@@ -265,7 +275,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 
 	ret = kallsyms_lookup_names(name, &i, NULL);
 	if (!ret)
-		return kallsyms_sym_address(kallsyms_seqs_of_names[i]);
+		return kallsyms_sym_address(get_symbol_seq(i));
 
 	return module_kallsyms_lookup_name(name);
 }
diff --git a/kernel/kallsyms_internal.h b/kernel/kallsyms_internal.h
index a04b7a5cb1e3e..27fabdcc40f57 100644
--- a/kernel/kallsyms_internal.h
+++ b/kernel/kallsyms_internal.h
@@ -26,6 +26,6 @@ extern const char kallsyms_token_table[] __weak;
 extern const u16 kallsyms_token_index[] __weak;
 
 extern const unsigned int kallsyms_markers[] __weak;
-extern const unsigned int kallsyms_seqs_of_names[] __weak;
+extern const u8 kallsyms_seqs_of_names[] __weak;
 
 #endif // LINUX_KALLSYMS_INTERNAL_H_
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 80aab2aa72246..ff8cce1757849 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -602,7 +602,10 @@ static void write_src(void)
 	sort_symbols_by_name();
 	output_label("kallsyms_seqs_of_names");
 	for (i = 0; i < table_cnt; i++)
-		printf("\t.long\t%u\n", table[i]->seq);
+		printf("\t.byte 0x%02x, 0x%02x, 0x%02x\n",
+			(unsigned char)(table[i]->seq >> 16),
+			(unsigned char)(table[i]->seq >> 8),
+			(unsigned char)(table[i]->seq >> 0));
 	printf("\n");
 
 	output_label("kallsyms_token_table");
-- 
2.42.0



