Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B1F3770B;
	Tue, 21 Jul 2026 20:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666410; cv=none; b=OtRQDKOPmVGBpumWo68IUTslvChg6jqIFyrwOhT6toin2NunUvNw5dXoLyAbKz4UD8kiLolEVrVfcWO4ESMOlhS/ka00Zw/mLPuW41gS5+OF1TtmvIkH9fe1rVpZmrj4UyCZU4P8NF/mxtMW73XW1CrWtJsiBtJ6tc8JWQw57NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666410; c=relaxed/simple;
	bh=5A6UILUQGJZ5eomJFkip5ki0H9XSjzHYoaSBiaEz3Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO/y4M719h8gtPcCcLhu3yFIF5sgM+aCQjAwJJBEcxgVGfwxEpUKSFFAzmJb5mo4gSCA4AmR8iFmI4ZZ/xK7fndvJBcaR8SGcHN9c/oGJdtvlveo00oV2eem7WyMTvYT5hLS685u8R8Fc3Mg35lDuEAqVUrz/lKE9aXcaV+WPUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Irt4h/Ja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Irt4h/Ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F6B1F000E9;
	Tue, 21 Jul 2026 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666408;
	bh=mcMMoxDhm+zMF7sIA9HrzpYdtMXbGeUZa1ImteBtPW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Irt4h/JaXtfWHIEdEx9hF9sdMgz7L1WQgWw70qhfeyFxZTkCvURBBdKe/s1KhWQaj
	 3u9xp1+83X1p2FftJRZqZVuDAOyG2mpiaJSrSlvrsxetP/KC0B3+RML85B4m7pAThk
	 HQBg38qJ65gLMXRDKImoV552r61ofRq4j9BuD5Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0645/1266] perf c2c: Fix use-after-free in he__get_c2c_hists() error path
Date: Tue, 21 Jul 2026 17:18:02 +0200
Message-ID: <20260721152456.295178882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5e5e6196d737c5be03d20647428316b36621608d ]

he__get_c2c_hists() assigns c2c_he->hists before calling
c2c_hists__init().  If init fails, the error path calls free(hists)
but leaves c2c_he->hists pointing to freed memory.  On teardown,
c2c_he_free() finds the non-NULL pointer and calls
hists__delete_entries() on it, causing a use-after-free.

Set c2c_he->hists to NULL before freeing so teardown skips the
already-freed allocation.

Fixes: b2252ae67b687d2b ("perf c2c report: Decode c2c_stats for hist entries")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 207b9c863aeea5..96ca35c4f3062c 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -215,6 +215,7 @@ he__get_c2c_hists(struct hist_entry *he,
 
 	ret = c2c_hists__init(hists, sort, nr_header_lines);
 	if (ret) {
+		c2c_he->hists = NULL;
 		free(hists);
 		return NULL;
 	}
-- 
2.53.0



