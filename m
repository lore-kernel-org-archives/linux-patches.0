Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E56FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0111C433EF;
	Mon,  3 Apr 2023 14:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532944;
	bh=k0ByH3qmjq6zXS/PPbgezrwhNwGhskdx11AomNJ25bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpkC4gLX5OimJJyn2mw0xpZo5aiAgH9qOB8HB9/YBorP4rJLli3P+KwVji3erNyCh
	 utHkmgxY2KaEp0aMSYUAarZ8WymDJ0ERWZUtxv9TiamK406bEIb0rcF/U99npOUHDz
	 hXCdqjuaOaGLJDqlRhICHSq1urjCrCXem2s/QKuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/181] selftests/bpf: Add few corner cases to test padding handling of btf_dump
Date: Mon,  3 Apr 2023 16:10:11 +0200
Message-Id: <20230403140420.854663222@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit b148c8b9b926e257a59c8eb2cd6fa3adfd443254 ]

Add few hand-crafted cases and few randomized cases found using script
from [0] that tests btf_dump's padding logic.

  [0] https://lore.kernel.org/bpf/85f83c333f5355c8ac026f835b18d15060725fcb.camel@ericsson.com/

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221212211505.558851-7-andrii@kernel.org
Stable-dep-of: 4fb877aaa179 ("libbpf: Fix btf_dump's packed struct determination")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/btf_dump_test_case_packing.c    |  61 +++++++++-
 .../bpf/progs/btf_dump_test_case_padding.c    | 104 ++++++++++++++++++
 2 files changed, 164 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
index e304b6204bd9d..5c6c62f7ed328 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
@@ -58,7 +58,64 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-/*------ END-EXPECTED-OUTPUT ------ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct nested_packed_but_aligned_struct {
+ *	int x1;
+ *	int x2;
+ *};
+ *
+ *struct outer_implicitly_packed_struct {
+ *	char y1;
+ *	struct nested_packed_but_aligned_struct y2;
+ *} __attribute__((packed));
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct nested_packed_but_aligned_struct {
+	int x1;
+	int x2;
+} __attribute__((packed));
+
+struct outer_implicitly_packed_struct {
+	char y1;
+	struct nested_packed_but_aligned_struct y2;
+};
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct usb_ss_ep_comp_descriptor {
+ *	char: 8;
+ *	char bDescriptorType;
+ *	char bMaxBurst;
+ *	short wBytesPerInterval;
+ *};
+ *
+ *struct usb_host_endpoint {
+ *	long: 64;
+ *	char: 8;
+ *	struct usb_ss_ep_comp_descriptor ss_ep_comp;
+ *	long: 0;
+ *} __attribute__((packed));
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct usb_ss_ep_comp_descriptor {
+	char: 8;
+	char bDescriptorType;
+	char bMaxBurst;
+	int: 0;
+	short wBytesPerInterval;
+} __attribute__((packed));
+
+struct usb_host_endpoint {
+	long: 64;
+	char: 8;
+	struct usb_ss_ep_comp_descriptor ss_ep_comp;
+	long: 0;
+};
+
 
 int f(struct {
 	struct packed_trailing_space _1;
@@ -69,6 +126,8 @@ int f(struct {
 	union union_is_never_packed _6;
 	union union_does_not_need_packing _7;
 	union jump_code_union _8;
+	struct outer_implicitly_packed_struct _9;
+	struct usb_host_endpoint _10;
 } *_)
 {
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index 6f963d34c45ba..79276fbe454a8 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -128,6 +128,98 @@ struct padding_weird_2 {
 	char: 8;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct exact_1byte {
+	char x;
+};
+
+struct padded_1byte {
+	char: 8;
+};
+
+struct exact_2bytes {
+	short x;
+};
+
+struct padded_2bytes {
+	short: 16;
+};
+
+struct exact_4bytes {
+	int x;
+};
+
+struct padded_4bytes {
+	int: 32;
+};
+
+struct exact_8bytes {
+	long x;
+};
+
+struct padded_8bytes {
+	long: 64;
+};
+
+struct ff_periodic_effect {
+	int: 32;
+	short magnitude;
+	long: 0;
+	short phase;
+	long: 0;
+	int: 32;
+	int custom_len;
+	short *custom_data;
+};
+
+struct ib_wc {
+	long: 64;
+	long: 64;
+	int: 32;
+	int byte_len;
+	void *qp;
+	union {} ex;
+	long: 64;
+	int slid;
+	int wc_flags;
+	long: 64;
+	char smac[6];
+	long: 0;
+	char network_hdr_type;
+};
+
+struct acpi_object_method {
+	long: 64;
+	char: 8;
+	char type;
+	short reference_count;
+	char flags;
+	short: 0;
+	char: 8;
+	char sync_level;
+	long: 64;
+	void *node;
+	void *aml_start;
+	union {} dispatch;
+	long: 64;
+	int aml_length;
+};
+
+struct nested_unpacked {
+	int x;
+};
+
+struct nested_packed {
+	struct nested_unpacked a;
+	char c;
+} __attribute__((packed));
+
+struct outer_mixed_but_unpacked {
+	struct nested_packed b1;
+	short a1;
+	struct nested_packed b2;
+};
+
 /* ------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct {
@@ -139,6 +231,18 @@ int f(struct {
 	struct padding_wo_named_members _6;
 	struct padding_weird_1 _7;
 	struct padding_weird_2 _8;
+	struct exact_1byte _100;
+	struct padded_1byte _101;
+	struct exact_2bytes _102;
+	struct padded_2bytes _103;
+	struct exact_4bytes _104;
+	struct padded_4bytes _105;
+	struct exact_8bytes _106;
+	struct padded_8bytes _107;
+	struct ff_periodic_effect _200;
+	struct ib_wc _201;
+	struct acpi_object_method _202;
+	struct outer_mixed_but_unpacked _203;
 } *_)
 {
 	return 0;
-- 
2.39.2



