Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2C138236A;
	Tue, 10 Mar 2026 11:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140784; cv=none; b=XEW7gKu0CtlL5lYOrwaPy0IPFtxD+Utvwqr/grc0q1e8yvHqqweQ7OAvGNA0GaoEIKpg7lBqTiotTdWs7EVgzj2/gbeo3yXeMBwqpcVyEx+EbfO9cexw0Kond8xhnKgFmBHokJfnNobO6kIRHLHBMRWjVWKgwptXOKChJvQ9bLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140784; c=relaxed/simple;
	bh=6KOiPjRFFCRZdxhhDzaqou5WehbZgj5o0Jxp5hlDCno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrSFINZlQpOof1c8DzU1hx31MqWeD8/Hjb47fcKgKciwiHczlm8kDjdl3hdR4fkVvBU1lgorWOvGTlboU7+zgd8JWFs6lTup/NfBXfItoLadqZsDmnSD6SArIIDIiZS3ApR1KIje7x6JH60GaOScGK9sulHZchQtpl+6AkG+5jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zfae0ye5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zfae0ye5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78C0C19423;
	Tue, 10 Mar 2026 11:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140784;
	bh=6KOiPjRFFCRZdxhhDzaqou5WehbZgj5o0Jxp5hlDCno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfae0ye5RDRBN2bGTjAMajbXTwmELbzQgt4k1ZI+xNqVexs3g+8bdu9MMqoOJWSNW
	 DdLoozohapIyqvuxUKMFg1SIgTCM3P8r8568XSVVIdYIC9MdZ8OuTZxpWB9kJrpnjY
	 eQmumfVfCdMGlLpDX7FF8ecMvUM2LbCmprurXYo6MIyLmZl3SZT1O7G7PPaKw2BFGz
	 UgQhO5yu9y/blwRiKqS0BYe3anaXrxCV3/q3N1Zqp5tH/yhAWRU0I54XCgpDHJ8x2W
	 CfflMh51V63fni/is0D+yBnPbPgJ6LuUUE3WHFEzNuCbrscFfd1vyX18uvwlwBkJNf
	 xiRwKPTyQ19vA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel J Blueman <daniel@quora.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 019/311] gpio: shared: fix memory leaks
Date: Tue, 10 Mar 2026 07:01:06 -0400
Message-ID: <8fd8fdca730aed5c31fa8467839eee94407aed7b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Daniel J Blueman <daniel@quora.org>

[ Upstream commit 32e0a7ad9c841f46549ccac0f1cca347a40d8685 ]

On a Snapdragon X1 Elite laptop (Lenovo Yoga Slim 7x), kmemleak reports
three sets of:

unreferenced object 0xffff00080187f400 (size 1024):
  comm "swapper/0", pid 1, jiffies 4294667327
  hex dump (first 32 bytes):
    58 bd 70 01 08 00 ff ff 58 bd 70 01 08 00 ff ff  X.p.....X.p.....
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace (crc 1665d1f8):
    kmemleak_alloc+0xf4/0x12c
    __kmalloc_cache_noprof+0x370/0x49c
    gpio_shared_make_ref+0x70/0x16c
    gpio_shared_of_traverse+0x4e8/0x5f4
    gpio_shared_of_traverse+0x200/0x5f4
    gpio_shared_of_traverse+0x200/0x5f4
    gpio_shared_of_traverse+0x200/0x5f4
    gpio_shared_of_traverse+0x200/0x5f4
    gpio_shared_init+0x34/0x1c4
    do_one_initcall+0x50/0x280
    kernel_init_freeable+0x290/0x33c
    kernel_init+0x28/0x14c
    ret_from_fork+0x10/0x20

unreferenced object 0xffff00080170c140 (size 8):
  comm "swapper/0", pid 1, jiffies 4294667327
  hex dump (first 8 bytes):
    72 65 73 65 74 00 00 00                          reset...
  backtrace (crc fc24536):
    kmemleak_alloc+0xf4/0x12c
    __kmalloc_node_track_caller_noprof+0x3c4/0x584
    kstrdup+0x4c/0xcc
    gpio_shared_make_ref+0x8c/0x16c
    gpio_shared_of_traverse+0x4e8/0x5f4
    gpio_shared_of_traverse+0x200/0x5f4
    gpio_shared_of_traverse+0x200/0x5f4
    gpio_shared_of_traverse+0x200/0x5f4
    gpio_shared_of_traverse+0x200/0x5f4
    gpio_shared_init+0x34/0x1c4
    do_one_initcall+0x50/0x280
    kernel_init_freeable+0x290/0x33c
    kernel_init+0x28/0x14c
    ret_from_fork+0x10/0x20

Fix this by decrementing the reference count of each list entry rather than
only the first.

Fix verified on the same laptop.

Fixes: a060b8c511abb gpiolib: implement low-level, shared GPIO support
Signed-off-by: Daniel J Blueman <daniel@quora.org>
Link: https://patch.msgid.link/20260220093452.101655-1-daniel@quora.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-shared.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpiolib-shared.c b/drivers/gpio/gpiolib-shared.c
index 9e65442034393..e16f467b72e7a 100644
--- a/drivers/gpio/gpiolib-shared.c
+++ b/drivers/gpio/gpiolib-shared.c
@@ -753,14 +753,14 @@ static bool gpio_shared_entry_is_really_shared(struct gpio_shared_entry *entry)
 static void gpio_shared_free_exclusive(void)
 {
 	struct gpio_shared_entry *entry, *epos;
+	struct gpio_shared_ref *ref, *rpos;
 
 	list_for_each_entry_safe(entry, epos, &gpio_shared_list, list) {
 		if (gpio_shared_entry_is_really_shared(entry))
 			continue;
 
-		gpio_shared_drop_ref(list_first_entry(&entry->refs,
-						      struct gpio_shared_ref,
-						      list));
+		list_for_each_entry_safe(ref, rpos, &entry->refs, list)
+			gpio_shared_drop_ref(ref);
 		gpio_shared_drop_entry(entry);
 	}
 }
-- 
2.51.0

