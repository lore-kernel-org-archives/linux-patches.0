Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B671DB142;
	Wed, 15 Jan 2025 10:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938626; cv=none; b=RpwsA2+Uzw6QXbB6rorDjWp3RnrAXy6An1EfQamwY9P2TQ82U5f7W/MiZ3P9fzzm1C5+q2cePLFIzxDe8U0m6MXSHHpF5rJlKhLeR/hvHZildeJOF0EWVu5N8EO85I607ad1f5FaveFgN7SmLjnahkiH05WpKgQEu2EstbD8C2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938626; c=relaxed/simple;
	bh=3bgHBCUI/ZAXugNTkD/Lj9RXbtG12LK9eR1HWmjwZgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgGV5DVBMjxFQAYD2YOwk2t9l1gAVtHXc+cEvrlfoNRVI2UQsrIivd7ma1qiibY2kLxFRYC6xrp4Lamfh6/PSit3y1mkAQqIXRObWf6YPlicLymMAempxH22xh2rDvKTheSXrnF6yt6JEfKeNiaZppFvEKlpvyVbDEdWLOY3Ez8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rcy4AP05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rcy4AP05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36775C4CEDF;
	Wed, 15 Jan 2025 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938626;
	bh=3bgHBCUI/ZAXugNTkD/Lj9RXbtG12LK9eR1HWmjwZgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rcy4AP05v/cCuR8IJcrTqFMZ7X0zZdZMMgrtQnR+Un3BwQR8jx2uetBhRoQmIza00
	 34QoHtme/E9uI3SuBDbh7cwlO0tzCufYaeVcCxA2CUg6F17USUOqRofO85Offo9Wu/
	 x/ZujI9LGQ9k0b5mb1iyCGlLyt0xzIIwZOavTQO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/129] selftests/alsa: Fix circular dependency involving global-timer
Date: Wed, 15 Jan 2025 11:36:32 +0100
Message-ID: <20250115103555.057695762@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 55853cb829dc707427c3519f6b8686682a204368 ]

The pattern rule `$(OUTPUT)/%: %.c` inadvertently included a circular
dependency on the global-timer target due to its inclusion in
$(TEST_GEN_PROGS_EXTENDED). This resulted in a circular dependency
warning during the build process.

To resolve this, the dependency on $(TEST_GEN_PROGS_EXTENDED) has been
replaced with an explicit dependency on $(OUTPUT)/libatest.so. This change
ensures that libatest.so is built before any other targets that require it,
without creating a circular dependency.

This fix addresses the following warning:

make[4]: Entering directory 'tools/testing/selftests/alsa'
make[4]: Circular default_modconfig/kselftest/alsa/global-timer <- default_modconfig/kselftest/alsa/global-timer dependency dropped.
make[4]: Nothing to be done for 'all'.
make[4]: Leaving directory 'tools/testing/selftests/alsa'

Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Link: https://patch.msgid.link/20241218025931.914164-1-lizhijian@fujitsu.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alsa/Makefile b/tools/testing/selftests/alsa/Makefile
index 5af9ba8a4645..140c7f821727 100644
--- a/tools/testing/selftests/alsa/Makefile
+++ b/tools/testing/selftests/alsa/Makefile
@@ -23,5 +23,5 @@ include ../lib.mk
 $(OUTPUT)/libatest.so: conf.c alsa-local.h
 	$(CC) $(CFLAGS) -shared -fPIC $< $(LDLIBS) -o $@
 
-$(OUTPUT)/%: %.c $(TEST_GEN_PROGS_EXTENDED) alsa-local.h
+$(OUTPUT)/%: %.c $(OUTPUT)/libatest.so alsa-local.h
 	$(CC) $(CFLAGS) $< $(LDLIBS) -latest -o $@
-- 
2.39.5



