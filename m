Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A8414A27;
	Tue, 21 Jul 2026 19:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663267; cv=none; b=HRkn7uv7lTqNLuU6slSory7bRO55G2MHKI1Tck0wtBzaHK8Pmbtugzg2hed+UAg1D0XgNtejNNc6qR4LhSoZ1QbM30kud2/VlTQ99uBZ/FDGLxiw75FA1bfInde41Ient54Td3O7f1Fb/jgxu7Jt89/0nyYybnKEsDnM5Pi9u/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663267; c=relaxed/simple;
	bh=g2J3TkxlrSuc/fgd/lZvPh4JzBGYMcMdf3gJAbB8BZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ur0Bn0MoFeJvWKKgzdxesyfp+N2EwKyi2+cKQLR1PIDGco2aHkaytkDQa9vMC+4KYQvEZ/inKOW16a9Wnc//5pg3t7ZvEpUF37HyN2/bIcjAKR368K5MiffnNFACXk3Gl9+ohm8TcyrVPe4O4/UPqA7oXOro1tIbxFMNCrF91Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCslNRVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCslNRVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898EE1F00A3A;
	Tue, 21 Jul 2026 19:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663266;
	bh=kVZ97YBKxXQWg6k/wWouUcEJdzCh5PAy6zCqyff9jV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCslNRVSdaGb1kek+XnxkUnKQfl45qDypCFZ+3OL0FqjRUdjVKVkKEged+CzJ5Rah
	 A4X34h6dm0DvRgURa0A2bqzhAbo+xx+fkyrNmCThVSoNqxrtHPQC/GHLS7iHWP+fjS
	 W47hYG4wNURXe4P2/CYMr9GAm14/nDPO4h5zKMA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0758/1276] selftests/hid: Cover hid_bpf_get_data() size overflow
Date: Tue, 21 Jul 2026 17:20:01 +0200
Message-ID: <20260721152503.038328775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit eebbef7c468a5cb58c4772849ee5066441166cf0 ]

Add a HID-BPF regression check for hid_bpf_get_data() requests whose
size would overflow when added to the offset.

The new rdesc fixup callback asks for offset 2 and size ~0ULL, then
records whether the helper returns NULL. A vulnerable kernel returns a
non-NULL pointer because the runtime check wraps the addition. A fixed
kernel rejects the request. The callback records the helper result
without dereferencing any returned pointer.

The callback reports the helper result through BSS and returns 0
intentionally. hid_rdesc_fixup return values are consumed as report
descriptor fixup results, so a positive test-result value would be
interpreted as a replacement report descriptor size.

Also add KHDR_INCLUDES to the HID selftest build so hid_bpf.c sees the
current kernel UAPI HID definitions on systems whose installed headers do
not provide enum hid_report_type.

Fixes: 658ee5a64fcf ("HID: bpf: allocate data memory for device_event BPF programs")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/hid/Makefile    |  2 +-
 tools/testing/selftests/hid/hid_bpf.c   | 11 +++++++++++
 tools/testing/selftests/hid/progs/hid.c | 15 +++++++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index 662209f5fabcfc..e50c0624cca2f8 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -24,7 +24,7 @@ CXX ?= $(CROSS_COMPILE)g++
 
 HOSTPKG_CONFIG := pkg-config
 
-CFLAGS += -g -O0 -rdynamic -Wall -Werror -I$(OUTPUT)
+CFLAGS += -g -O0 -rdynamic -Wall -Werror -I$(OUTPUT) $(KHDR_INCLUDES)
 CFLAGS += -I$(OUTPUT)/tools/include
 
 LDLIBS += -lelf -lz -lrt -lpthread
diff --git a/tools/testing/selftests/hid/hid_bpf.c b/tools/testing/selftests/hid/hid_bpf.c
index 511264cdd71b83..73ae0948f0b682 100644
--- a/tools/testing/selftests/hid/hid_bpf.c
+++ b/tools/testing/selftests/hid/hid_bpf.c
@@ -921,6 +921,17 @@ TEST_F(hid_bpf, test_rdesc_fixup)
 	ASSERT_EQ(rpt_desc.value[4], 0x42);
 }
 
+TEST_F(hid_bpf, test_rdesc_fixup_get_data_overflow)
+{
+	const struct test_program progs[] = {
+		{ .name = "hid_rdesc_fixup_get_data_overflow" },
+	};
+
+	LOAD_PROGRAMS(progs);
+
+	ASSERT_EQ(self->skel->bss->get_data_overflow_check, 1);
+}
+
 static int libbpf_print_fn(enum libbpf_print_level level,
 			   const char *format, va_list args)
 {
diff --git a/tools/testing/selftests/hid/progs/hid.c b/tools/testing/selftests/hid/progs/hid.c
index 5ecc845ef79216..b21fbb13c926f8 100644
--- a/tools/testing/selftests/hid/progs/hid.c
+++ b/tools/testing/selftests/hid/progs/hid.c
@@ -13,6 +13,7 @@ struct attach_prog_args {
 
 __u64 callback_check = 52;
 __u64 callback2_check = 52;
+__u64 get_data_overflow_check;
 
 SEC("?struct_ops/hid_device_event")
 int BPF_PROG(hid_first_event, struct hid_bpf_ctx *hid_ctx, enum hid_report_type type)
@@ -240,6 +241,20 @@ struct hid_bpf_ops rdesc_fixup = {
 	.hid_rdesc_fixup = (void *)hid_rdesc_fixup,
 };
 
+SEC("?struct_ops.s/hid_rdesc_fixup")
+int BPF_PROG(hid_rdesc_fixup_get_data_overflow, struct hid_bpf_ctx *hid_ctx)
+{
+	if (!hid_bpf_get_data(hid_ctx, 2 /* offset */, ~0ULL /* size */))
+		get_data_overflow_check = 1;
+
+	return 0;
+}
+
+SEC(".struct_ops.link")
+struct hid_bpf_ops rdesc_fixup_get_data_overflow = {
+	.hid_rdesc_fixup = (void *)hid_rdesc_fixup_get_data_overflow,
+};
+
 SEC("?struct_ops/hid_device_event")
 int BPF_PROG(hid_test_insert1, struct hid_bpf_ctx *hid_ctx, enum hid_report_type type)
 {
-- 
2.53.0



