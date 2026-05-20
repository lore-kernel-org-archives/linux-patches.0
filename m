Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AFC35201E;
	Wed, 20 May 2026 16:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295958; cv=none; b=asLXsjIectc4LndnPq3+7EXl0esL2nb4gGLSusRSkiEmNMsgRKy2D/n9Jq/+et4pU/6WpM48Hpz+AlWO0i77OASRXJsPXR94unq6yembefXli9CEmnqm5qFhX83ei81j5Ho21155iCpiK92wlkeeP6qO49DZbsDj3Hz2lULybVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295958; c=relaxed/simple;
	bh=PhVtTglCIZPO/K9HBTm2KEhxKnIbpIPSlba54RLf60o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dPfIDrBTbJXZad+aLWZIm6xOOKSH8WSUPMPfPAqGw+woNYiT9cDLGkOrjOBQ16T0lz3sduK2Uwiyp+YNihbOE+FLSnRSGbOXdfk/UWnpQKwesFh4XJP4Uv6/UgF/lZPZziIdCkQP421BIDdusgybpLB5q2iP4nP1M9cgisz4ZoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HO6yUV7Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HO6yUV7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E791F000E9;
	Wed, 20 May 2026 16:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295957;
	bh=p5Yh621QYiJ7DVen4eNUMSRx4HpEoXf2W3ovPC2RfJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HO6yUV7ZrdNzuCudiYTTxsSg+xebT+AMol+5WAXpHtOznH94g3Eh/yxaqFk7w4RVC
	 6NkryF4F2sjdslmHD1s1DCY1EmLXBnoscmOusstX9DXXd/zzgS7OVzl6t/LHo7T35T
	 gVcZPJxQ3BS/wdGvrelD84kZ+QkBsOjQACwydW/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihan Ding <dingyihan@uniontech.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0618/1146] bpf: allow UTF-8 literals in bpf_bprintf_prepare()
Date: Wed, 20 May 2026 18:14:28 +0200
Message-ID: <20260520162202.169475886@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Ding <dingyihan@uniontech.com>

[ Upstream commit b960430ea8862ef37ce53c8bf74a8dc79d3f2404 ]

bpf_bprintf_prepare() only needs ASCII parsing for conversion
specifiers. Plain text can safely carry bytes >= 0x80, so allow
UTF-8 literals outside '%' sequences while keeping ASCII control
bytes rejected and format specifiers ASCII-only.

This keeps existing parsing rules for format directives unchanged,
while allowing helpers such as bpf_trace_printk() to emit UTF-8
literal text.

Update test_snprintf_negative() in the same commit so selftests keep
matching the new plain-text vs format-specifier split during bisection.

Fixes: 48cac3f4a96d ("bpf: Implement formatted output helpers with bstr_printf")
Signed-off-by: Yihan Ding <dingyihan@uniontech.com>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/20260416120142.1420646-2-dingyihan@uniontech.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c                            | 17 ++++++++++++++++-
 .../testing/selftests/bpf/prog_tests/snprintf.c |  3 ++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 6eb6c82ed2ee1..d51f1b612f1d9 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -845,7 +845,13 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
 		data->buf = buffers->buf;
 
 	for (i = 0; i < fmt_size; i++) {
-		if ((!isprint(fmt[i]) && !isspace(fmt[i])) || !isascii(fmt[i])) {
+		unsigned char c = fmt[i];
+
+		/*
+		 * Permit bytes >= 0x80 in plain text so UTF-8 literals can pass
+		 * through unchanged, while still rejecting ASCII control bytes.
+		 */
+		if (isascii(c) && !isprint(c) && !isspace(c)) {
 			err = -EINVAL;
 			goto out;
 		}
@@ -867,6 +873,15 @@ int bpf_bprintf_prepare(const char *fmt, u32 fmt_size, const u64 *raw_args,
 		 * always access fmt[i + 1], in the worst case it will be a 0
 		 */
 		i++;
+		c = fmt[i];
+		/*
+		 * The format parser below only understands ASCII conversion
+		 * specifiers and modifiers, so reject non-ASCII after '%'.
+		 */
+		if (!isascii(c)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		/* skip optional "[0 +-][num]" width formatting field */
 		while (fmt[i] == '0' || fmt[i] == '+'  || fmt[i] == '-' ||
diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf.c b/tools/testing/selftests/bpf/prog_tests/snprintf.c
index 594441acb7071..4e4a82d54f799 100644
--- a/tools/testing/selftests/bpf/prog_tests/snprintf.c
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf.c
@@ -114,7 +114,8 @@ static void test_snprintf_negative(void)
 	ASSERT_ERR(load_single_snprintf("%--------"), "invalid specifier 5");
 	ASSERT_ERR(load_single_snprintf("%lc"), "invalid specifier 6");
 	ASSERT_ERR(load_single_snprintf("%llc"), "invalid specifier 7");
-	ASSERT_ERR(load_single_snprintf("\x80"), "non ascii character");
+	ASSERT_OK(load_single_snprintf("\x80"), "non ascii plain text");
+	ASSERT_ERR(load_single_snprintf("%\x80"), "non ascii in specifier");
 	ASSERT_ERR(load_single_snprintf("\x1"), "non printable character");
 	ASSERT_ERR(load_single_snprintf("%p%"), "invalid specifier 8");
 	ASSERT_ERR(load_single_snprintf("%s%"), "invalid specifier 9");
-- 
2.53.0



