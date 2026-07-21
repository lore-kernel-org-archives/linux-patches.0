Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C483C1081;
	Tue, 21 Jul 2026 22:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671839; cv=none; b=Kq/ITrjWTZIgotBuDlsofR92ztferhoAtRc7JumBFM5RHHJPoMx1e3cixKlQF5ScBI2nkT5nImnBpZbEkTpXzZFgaJ98M/q0vfkSmm89NcT+Lu0QkAHls8+UxCHQ+4NzC4Ob9ZVc01hDwZSYiMTuMfQlZazuYXb0iAXbAVaBsJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671839; c=relaxed/simple;
	bh=zCeH5kA019f+HTJZfxGvjSrwW2tqrhgH7H8GfDorxzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAefuAXny1sMzbQaQcfsoDjRfViA5cQ40fluoZWCdYZ+jQOwUynI57mrljWSmO1ovy10sxzaRHj8dpd8Z+hoyw2eu0hyR+GZGyM1BlVzJyE9Yn926UmJptV3ykq2G5yACpXcAFpEVYiWVPjOz2ZkHXfMHuQ8gtolc2Hen7z9+TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4FSS8Xl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4FSS8Xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92191F000E9;
	Tue, 21 Jul 2026 22:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671838;
	bh=mSbcaqUUs8MoQc6CtdxCDKpEkfwHJRJsJeGqJYeWsIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x4FSS8XlIJuDNAL05i84vDEd2vo+mR/9/3rqETS51yxajI4a2KTLpqmLB9y1gHGEw
	 Djl5rJ8uSXRtbHL5WgFWBPiLixCZm4lSyvPdiSFclYazHtuamQWS3jb0UBNrp+8wt9
	 V8Wj+2cU4OezrcJbT+XM5038da3jac4w8yqaFxv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 396/843] perf c2c: Fix use-after-free in he__get_c2c_hists() error path
Date: Tue, 21 Jul 2026 17:20:31 +0200
Message-ID: <20260721152414.947232839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e6f900c3accb0f..cfa5a53abf2082 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -203,6 +203,7 @@ he__get_c2c_hists(struct hist_entry *he,
 
 	ret = c2c_hists__init(hists, sort, nr_header_lines);
 	if (ret) {
+		c2c_he->hists = NULL;
 		free(hists);
 		return NULL;
 	}
-- 
2.53.0



