Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C5E81ADA;
	Tue,  3 Dec 2024 16:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242245; cv=none; b=ZwNlICPj77y1mQDGszlbTa1qSUuNcRD7HpPmuiGRi7g+31xUa/sdacKr55DWrJ/IZnFmzVW2GNcJ3hKd7VfTaENtbqe6OKc0dOals5dEn6d/C4wgqifHfM56l3A83AyDtrv45TRT+KupCQ3cWfEKx5p6JaSyGwUUNJofHe4++18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242245; c=relaxed/simple;
	bh=VEZEAUpfmbEC6+YHmAvJcDEx63bLyVPhyQ/gb/tK3eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJkUnuptZ+DVf7UogaUwyuM7yjUo3WKaq4NwBWa0bHWfW6ZK9cRNVn1bzwgMisR58KigZScgL8ysQOn4oXlEVpMcJUSlRVW7IZLFBR9R1yqDuKQusWPYm4j5tGpyrcqclmXBP/ueC2w+bpx8GzwvFjDilaIdCpsclnLFYWlZEl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHxhaCBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHxhaCBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7574FC4CECF;
	Tue,  3 Dec 2024 16:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242244;
	bh=VEZEAUpfmbEC6+YHmAvJcDEx63bLyVPhyQ/gb/tK3eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHxhaCBBS2pBJlUdNm85ogkT4RaeJQ2MZok9jpUhed07NX6RlE83d/YEPHUxTSgyc
	 6iWjF5UWcwI3Tm8oT7Q/sS6cX97+snbrbppdaykAZMGiewv5274OHRTZ/9i0zJxugl
	 KJDmGDkxLdu4yOCviCQPWXaLJYiHXvflGdcmKuBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zichen Xie <zichenxie0106@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 618/826] ALSA: core: Fix possible NULL dereference caused by kunit_kzalloc()
Date: Tue,  3 Dec 2024 15:45:45 +0100
Message-ID: <20241203144807.860982126@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zichen Xie <zichenxie0106@gmail.com>

[ Upstream commit 9ad467a2b2716d4ed12f003b041aa6c776a13ff5 ]

kunit_kzalloc() may return a NULL pointer, dereferencing it without
NULL check may lead to NULL dereference.
Add NULL checks for all the kunit_kzalloc() in sound_kunit.c

Fixes: 3e39acf56ede ("ALSA: core: Add sound core KUnit test")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
Link: https://patch.msgid.link/20241126192448.12645-1-zichenxie0106@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/sound_kunit.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/core/sound_kunit.c b/sound/core/sound_kunit.c
index bfed1a25fc8f7..84e337ecbddd0 100644
--- a/sound/core/sound_kunit.c
+++ b/sound/core/sound_kunit.c
@@ -172,6 +172,7 @@ static void test_format_fill_silence(struct kunit *test)
 	u32 i, j;
 
 	buffer = kunit_kzalloc(test, SILENCE_BUFFER_SIZE, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, buffer);
 
 	for (i = 0; i < ARRAY_SIZE(buf_samples); i++) {
 		for (j = 0; j < ARRAY_SIZE(valid_fmt); j++)
@@ -208,8 +209,12 @@ static void test_playback_avail(struct kunit *test)
 	struct snd_pcm_runtime *r = kunit_kzalloc(test, sizeof(*r), GFP_KERNEL);
 	u32 i;
 
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, r);
+
 	r->status = kunit_kzalloc(test, sizeof(*r->status), GFP_KERNEL);
 	r->control = kunit_kzalloc(test, sizeof(*r->control), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, r->status);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, r->control);
 
 	for (i = 0; i < ARRAY_SIZE(p_avail_data); i++) {
 		r->buffer_size = p_avail_data[i].buffer_size;
@@ -232,8 +237,12 @@ static void test_capture_avail(struct kunit *test)
 	struct snd_pcm_runtime *r = kunit_kzalloc(test, sizeof(*r), GFP_KERNEL);
 	u32 i;
 
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, r);
+
 	r->status = kunit_kzalloc(test, sizeof(*r->status), GFP_KERNEL);
 	r->control = kunit_kzalloc(test, sizeof(*r->control), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, r->status);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, r->control);
 
 	for (i = 0; i < ARRAY_SIZE(c_avail_data); i++) {
 		r->buffer_size = c_avail_data[i].buffer_size;
@@ -247,6 +256,7 @@ static void test_capture_avail(struct kunit *test)
 static void test_card_set_id(struct kunit *test)
 {
 	struct snd_card *card = kunit_kzalloc(test, sizeof(*card), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, card);
 
 	snd_card_set_id(card, VALID_NAME);
 	KUNIT_EXPECT_STREQ(test, card->id, VALID_NAME);
@@ -280,6 +290,7 @@ static void test_pcm_format_name(struct kunit *test)
 static void test_card_add_component(struct kunit *test)
 {
 	struct snd_card *card = kunit_kzalloc(test, sizeof(*card), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, card);
 
 	snd_component_add(card, TEST_FIRST_COMPONENT);
 	KUNIT_ASSERT_STREQ(test, card->components, TEST_FIRST_COMPONENT);
-- 
2.43.0



