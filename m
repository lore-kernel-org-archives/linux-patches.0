Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70E242DA39;
	Tue, 21 Jul 2026 19:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660627; cv=none; b=I9kpUIfcvquy8PuZ2ZqsSzL+2ueuutHkcDYgo0Agtl4YbNvSV86cvn/Uki4+DndlafdHFKKG5recJZ1/HNfYpwjAp4YYxToKsJeXqUmo4z1vXUxL4ToCr9Cp2CVKijunfDWvujP02hxDyfIBr3e6grxZp6uMqeFxQXXlEYb1Qfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660627; c=relaxed/simple;
	bh=PaGfF15RrmU3iJpRGHEl7Ay5oM57uNsb0MGX+pof/jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=su89wwmxLkG2MEDNOmfch109eR9mkVLFpDaUZQxqtran2DiydFeGAcfomdO4LOKSoBQ7sQK9UkXQhX+hch0CHhXeDW87LUpujzZWYUd46zr1PxIIuLHtlaC9+60h++K6tMRDnaNQPt3ErMKVh7S37qjRKfX+aTNFnvKA1tzPaTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kthPr/e/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kthPr/e/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3E11F000E9;
	Tue, 21 Jul 2026 19:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660626;
	bh=1rKtF5dWm7UegBEkvWScDFl1I+hf84LRQ5pXDm6Lugc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kthPr/e/OJnAyFXCzuihOKE9cRDXv2SFYtFM3W/cZV/+T8GL6X/2c7hFPRoy8lJr9
	 Kvx6XHvAwB4wf+U2F0ldKpYlk4CSjn9eti6QOC5Ggj73dm0LpsxtrBQJeauhWbLrhd
	 bbl03KohWxAw6bwNLmF0AtuMMKk09AWMXgf8EYTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1014/2077] perf hwmon: Fix parse_hwmon_filename() strlcpy buffer overflow
Date: Tue, 21 Jul 2026 17:11:27 +0200
Message-ID: <20260721152616.735324808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit e1a2c9d70b312acc262f6be936dd5bbd9bbc6236 ]

parse_hwmon_filename() strips the "_alarm" suffix from event names
by copying into a 24-byte stack buffer:

    strlcpy(fn_type, fn_item, fn_item_len - 5);

The third argument is the source length minus the suffix, not the
destination buffer capacity.  A long event name ending in "_alarm"
can have fn_item_len - 5 > sizeof(fn_type), causing strlcpy() to
write past the 24-byte fn_type[] array.  The assert() only validates
that the longest *valid* hwmon item fits, but does not protect
against crafted input.

Clamp the strlcpy size to min(fn_item_len - 5, sizeof(fn_type)).

Fixes: 4810b761f812da3c ("perf hwmon_pmu: Add hwmon filename parser")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index fbfb872ceb1826..bdcbe887579a1f 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -202,7 +202,8 @@ bool parse_hwmon_filename(const char *filename,
 	fn_item_len = strlen(fn_item);
 	if (fn_item_len > 6 && !strcmp(&fn_item[fn_item_len - 6], "_alarm")) {
 		assert(strlen(LONGEST_HWMON_ITEM_STR) < sizeof(fn_type));
-		strlcpy(fn_type, fn_item, fn_item_len - 5);
+		/* fn_item_len - 5 strips "_alarm"; clamp to buffer size */
+		strlcpy(fn_type, fn_item, min_t(size_t, fn_item_len - 5, sizeof(fn_type)));
 		fn_item = fn_type;
 		*alarm = true;
 	}
-- 
2.53.0



