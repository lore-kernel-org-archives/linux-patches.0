Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4216440860A;
	Tue, 21 Jul 2026 19:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660757; cv=none; b=bvzN5tBf+Ht4uZjD8liTFWYssMeIcrSrzjl0kGHnzeGnI2I+Hd7MfsbF8f3NxEIVBpvXEIzfwXprXlL3sp6bHwOJf5h3e1LMeKH5T5FCy+oDCtzXWTUbEcSNXqP87GcqTHfYBNYUjddtThOBoFsv2cX+4gpjER+JrI8ZWHcxmGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660757; c=relaxed/simple;
	bh=kkwC7YTaRQy80UQgP/JRF+bUKwSNGleq+MxgnIejQXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+XK99LTIAZ/tM6SxWrszo96JN0gnPPX1UCFQk/jfb3MoVUCP6Fdt9Ia9WpCFhezm3irh3ln7Yz/q/VWaF1yAf80h+mRKwGH1n0p1qhIRMaSN9aBjCTFywbVb33DJ4S3jpIVbHQgC7m0ZVT3FrVG9IT6j85Uf87OVcgQbws23nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKpYvnRi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKpYvnRi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A857A1F000E9;
	Tue, 21 Jul 2026 19:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660756;
	bh=8S/ntVqn8PAcaY3l4IvDn84YSf3/mThgY+4uj2lPQmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKpYvnRidhlNpl8AEYBiKJ8Lq73/liqOgRfSvaa8Xlju78hdzd9StWlq7aBXl2Pxv
	 FFdlWpnEU0/rt2NDKjPqkl+Zu68GuSqhYTKbYgrA5KC/FjcJrBBDS/R81HopLCC6nS
	 8nilXTdhSST4N2pTPNosMPvaIXaTnafgh1WDTzyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1098/2077] perf c2c: Free format list entries when c2c_hists__init() fails
Date: Tue, 21 Jul 2026 17:12:51 +0200
Message-ID: <20260721152618.718332089@linuxfoundation.org>
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

[ Upstream commit 61a21d11afd8dd83b2260ae00541bed62a843219 ]

When c2c_hists__init() fails partway through hpp_list__parse(),
dynamically allocated format structures that were already added to
hists->list are leaked because he__get_c2c_hists() frees the hists
container without first unregistering the format entries.

Call perf_hpp__reset_output_field() before freeing the hists container
on the error path, matching what c2c_he_free() already does on the
normal destruction path.

Fixes: 17a7c5946d79a12c ("perf c2c report: Decode c2c_stats for hist entries")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 17161278ce94cd..219de790c3766a 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -222,6 +222,7 @@ he__get_c2c_hists(struct hist_entry *he,
 
 	ret = c2c_hists__init(hists, sort, nr_header_lines, env);
 	if (ret) {
+		perf_hpp__reset_output_field(&hists->list);
 		c2c_he->hists = NULL;
 		free(hists);
 		return NULL;
-- 
2.53.0



