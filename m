Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768A0442FDF;
	Thu, 30 Jul 2026 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421252; cv=none; b=J/O1at9vfSLxBg/W+DeCk4l8mAj+wKnhDlKCoXE8PsmPyYjjz3SYyCSfj43pIepD6YA1ZAHrBUEpbxg++dRKTahTozZtGMvE8NGfJ4TWGNXSuCQ9cB0wJT/XO4P+AHXcEi8092cqHg+qP6dYneQt1TIrjbHZxno6S9MlaITL8G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421252; c=relaxed/simple;
	bh=EwTPqdJlVkLAftE2Do4QkTd944Hyp+g87cNXVcK763Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uW7kOildqYrj5PR5kl7PkoMBsjgYoXtYlRu6CiRFsbjBDVqvQuviDtg6Ai6ozoactQAyiai7Im7KDngofpRVwScmalqw6xWxUymD2rrnrzC4sQy0rMfHxbazKuTu/PrRkE3Gb199SdUpwzU9Z7bg6psczcfkUY9OhDTTBIJmTrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxMpTEHU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxMpTEHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A832B1F00A3A;
	Thu, 30 Jul 2026 14:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421251;
	bh=hsK5tQ0yg9HrGvNqIfY/cqhvJ5ovTCntTRU5eajXVtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OxMpTEHUMmws0wGONGSp8pb+4zRm8IYI4Kgq060WFwAovD6QHpjII0S2hvOGuFEnJ
	 rY3qSNM3NF37hsAP8XKJdFmOb9Oz0FSyoc4yFp/ieq1es7MrvmMtSJxqdnVaQ214Pg
	 PIO2CKqSGrmCUa8ep5nEJR2o3VNXC7p3vgCNDQJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malaya Kumar Rout <malayarout91@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 042/744] selftests/alsa: Fix memory leak in find_controls error path
Date: Thu, 30 Jul 2026 16:05:15 +0200
Message-ID: <20260730141445.176170201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malaya Kumar Rout <malayarout91@gmail.com>

[ Upstream commit cb89f0c1aed02eb233c4271f76f830b37e222ff6 ]

In find_controls(), card_data is allocated with malloc() but when
snd_ctl_open_lconf() fails, the code jumps to next_card without
freeing the allocated memory. This results in a memory leak for
each card where snd_ctl_open_lconf() fails.

Add free(card_data) before goto next_card to ensure proper cleanup
of the allocated memory in the error path.

Fixes: 5aaf9efffc57 ("kselftest: alsa: Add simplistic test for ALSA mixer controls kselftest")
Signed-off-by: Malaya Kumar Rout <malayarout91@gmail.com>
Link: https://patch.msgid.link/20260704105736.94874-1-malayarout91@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/mixer-test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/alsa/mixer-test.c b/tools/testing/selftests/alsa/mixer-test.c
index d4f845c3280456..c5ae2a026ce919 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -84,6 +84,7 @@ static void find_controls(void)
 		if (err < 0) {
 			ksft_print_msg("Failed to get hctl for card %d: %s\n",
 				       card, snd_strerror(err));
+			free(card_data);
 			goto next_card;
 		}
 
-- 
2.53.0



