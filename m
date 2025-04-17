Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9600253B7B;
	Thu, 17 Apr 2025 18:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913694; cv=none; b=exWqIO5gSWElnoJLeCIPNfRt6uyl4/1v+5iUp99Jsn6u3O9h8NtvtZmwlRLPHgU/jICzvYE4Zz/sOIrPtcGaHXMKS+JBCHP/7x1f07VSsKO6seIHjmwuG75rKrdDnNL/rCL3TV62O9HLdGMq0xWvcaTaANjHIhC9VB/ptVIaeic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913694; c=relaxed/simple;
	bh=SVxW+YZG1YFTi4kW73CSSpXEqFmhvsicUnUguQC3KYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZf9XPy98JSWxH9VTL8dY3OxXdvN2O3HJZRAiQGnSshg3QKHQ6lW4FOunsAYiC/4eHYmTrekvSkmdoSJTw98gSquqYEm2YUL7qIX1V1BZ5iBIpxb/hJPxTOTiBPGW4HHWrAX8OEzaYnPynf4p0oGfJj9h//0EtJ/8qStQ2x5m1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHRCJCQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHRCJCQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C792BC4CEE4;
	Thu, 17 Apr 2025 18:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913694;
	bh=SVxW+YZG1YFTi4kW73CSSpXEqFmhvsicUnUguQC3KYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHRCJCQhQSSvs16iWNIv8FVB7GUyK7nItHLpLlegmp15/lobLumdD5/0jNbjgAfNb
	 LZXs+lXrbEek2xMpnKryuZmX3GhhozdkxctAA8MJ7NyfEr3dG43usl3Y5kGDVMGERK
	 7uDDGpCwz5bdREyUYfbEpSLZvujx2b34fT2gAVpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 393/449] firmware: cs_dsp: test_control_parse: null-terminate test strings
Date: Thu, 17 Apr 2025 19:51:21 +0200
Message-ID: <20250417175134.085318093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit 42ae6e2559e63c2d4096b698cd47aaeb974436df upstream.

The char pointers in 'struct cs_dsp_mock_coeff_def' are expected to
point to C strings. They need to be terminated by a null byte.
However the code does not allocate that trailing null byte and only
works if by chance the allocation is followed by such a null byte.

Refactor the repeated string allocation logic into a new helper which
makes sure the terminating null is always present.
It also makes the code more readable.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Fixes: 83baecd92e7c ("firmware: cs_dsp: Add KUnit testing of control parsing")
Cc: stable@vger.kernel.org
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Tested-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250211-cs_dsp-kunit-strings-v1-1-d9bc2035d154@linutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../cirrus/test/cs_dsp_test_control_parse.c   | 51 +++++++------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff --git a/drivers/firmware/cirrus/test/cs_dsp_test_control_parse.c b/drivers/firmware/cirrus/test/cs_dsp_test_control_parse.c
index cb90964740ea..942ba1af5e7c 100644
--- a/drivers/firmware/cirrus/test/cs_dsp_test_control_parse.c
+++ b/drivers/firmware/cirrus/test/cs_dsp_test_control_parse.c
@@ -73,6 +73,18 @@ static const struct cs_dsp_mock_coeff_def mock_coeff_template = {
 	.length_bytes = 4,
 };
 
+static char *cs_dsp_ctl_alloc_test_string(struct kunit *test, char c, size_t len)
+{
+	char *str;
+
+	str = kunit_kmalloc(test, len + 1, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, str);
+	memset(str, c, len);
+	str[len] = '\0';
+
+	return str;
+}
+
 /* Algorithm info block without controls should load */
 static void cs_dsp_ctl_parse_no_coeffs(struct kunit *test)
 {
@@ -160,12 +172,8 @@ static void cs_dsp_ctl_parse_max_v1_name(struct kunit *test)
 	struct cs_dsp_mock_coeff_def def = mock_coeff_template;
 	struct cs_dsp_coeff_ctl *ctl;
 	struct firmware *wmfw;
-	char *name;
 
-	name = kunit_kzalloc(test, 256, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, name);
-	memset(name, 'A', 255);
-	def.fullname = name;
+	def.fullname = cs_dsp_ctl_alloc_test_string(test, 'A', 255);
 
 	cs_dsp_mock_wmfw_start_alg_info_block(local->wmfw_builder,
 					      cs_dsp_ctl_parse_test_algs[0].id,
@@ -252,14 +260,9 @@ static void cs_dsp_ctl_parse_max_short_name(struct kunit *test)
 	struct cs_dsp_test_local *local = priv->local;
 	struct cs_dsp_mock_coeff_def def = mock_coeff_template;
 	struct cs_dsp_coeff_ctl *ctl;
-	char *name;
 	struct firmware *wmfw;
 
-	name = kunit_kmalloc(test, 255, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, name);
-	memset(name, 'A', 255);
-
-	def.shortname = name;
+	def.shortname = cs_dsp_ctl_alloc_test_string(test, 'A', 255);
 
 	cs_dsp_mock_wmfw_start_alg_info_block(local->wmfw_builder,
 					      cs_dsp_ctl_parse_test_algs[0].id,
@@ -273,7 +276,7 @@ static void cs_dsp_ctl_parse_max_short_name(struct kunit *test)
 	ctl = list_first_entry_or_null(&priv->dsp->ctl_list, struct cs_dsp_coeff_ctl, list);
 	KUNIT_ASSERT_NOT_NULL(test, ctl);
 	KUNIT_EXPECT_EQ(test, ctl->subname_len, 255);
-	KUNIT_EXPECT_MEMEQ(test, ctl->subname, name, ctl->subname_len);
+	KUNIT_EXPECT_MEMEQ(test, ctl->subname, def.shortname, ctl->subname_len);
 	KUNIT_EXPECT_EQ(test, ctl->flags, def.flags);
 	KUNIT_EXPECT_EQ(test, ctl->type, def.type);
 	KUNIT_EXPECT_EQ(test, ctl->len, def.length_bytes);
@@ -323,12 +326,8 @@ static void cs_dsp_ctl_parse_with_max_fullname(struct kunit *test)
 	struct cs_dsp_mock_coeff_def def = mock_coeff_template;
 	struct cs_dsp_coeff_ctl *ctl;
 	struct firmware *wmfw;
-	char *fullname;
 
-	fullname = kunit_kmalloc(test, 255, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, fullname);
-	memset(fullname, 'A', 255);
-	def.fullname = fullname;
+	def.fullname = cs_dsp_ctl_alloc_test_string(test, 'A', 255);
 
 	cs_dsp_mock_wmfw_start_alg_info_block(local->wmfw_builder,
 					      cs_dsp_ctl_parse_test_algs[0].id,
@@ -392,12 +391,8 @@ static void cs_dsp_ctl_parse_with_max_description(struct kunit *test)
 	struct cs_dsp_mock_coeff_def def = mock_coeff_template;
 	struct cs_dsp_coeff_ctl *ctl;
 	struct firmware *wmfw;
-	char *description;
 
-	description = kunit_kmalloc(test, 65535, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, description);
-	memset(description, 'A', 65535);
-	def.description = description;
+	def.description = cs_dsp_ctl_alloc_test_string(test, 'A', 65535);
 
 	cs_dsp_mock_wmfw_start_alg_info_block(local->wmfw_builder,
 					      cs_dsp_ctl_parse_test_algs[0].id,
@@ -429,17 +424,9 @@ static void cs_dsp_ctl_parse_with_max_fullname_and_description(struct kunit *tes
 	struct cs_dsp_mock_coeff_def def = mock_coeff_template;
 	struct cs_dsp_coeff_ctl *ctl;
 	struct firmware *wmfw;
-	char *fullname, *description;
 
-	fullname = kunit_kmalloc(test, 255, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, fullname);
-	memset(fullname, 'A', 255);
-	def.fullname = fullname;
-
-	description = kunit_kmalloc(test, 65535, GFP_KERNEL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, description);
-	memset(description, 'A', 65535);
-	def.description = description;
+	def.fullname = cs_dsp_ctl_alloc_test_string(test, 'A', 255);
+	def.description = cs_dsp_ctl_alloc_test_string(test, 'A', 65535);
 
 	cs_dsp_mock_wmfw_start_alg_info_block(local->wmfw_builder,
 					      cs_dsp_ctl_parse_test_algs[0].id,
-- 
2.49.0



