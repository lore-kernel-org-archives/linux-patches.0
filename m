Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0CC47126C;
	Tue, 21 Jul 2026 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657211; cv=none; b=f40KjfHfpxhjgCg1FbD+VD3S0Hlt5GEApQL0qN+sGRPpZgPQM+QgpxcY4CFWrEMySwBFCBxbucX/klOPkxytgztQCpXz0TX9rDYzmIZimEP/1GrHyz1OybAbbwma/DemPaokczcEyCek0KcuxcPon0JEjcvbaFUlqUw3t5QX5Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657211; c=relaxed/simple;
	bh=w96iq2j2wFC+fEwtzMJgjtnAFOBkOl+hHyAoroVmlBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=imGxnTKsG6AEFLdGWyqrbm4fHKiWFVJomC9yrb0M+mR9cnYvyol2xfirtX5ZJRpZFPPK4dPe+J9fjRdtxLKvsrncWiDnG/T1wg8hZB3WCix+zuA0BdoMq+8qQWEMIhecr3LvRXRmCeMMTFg1qcSyqir9Jw176zWvvj3n2xPBXsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ej8iVEWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ej8iVEWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BEF1F000E9;
	Tue, 21 Jul 2026 18:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657210;
	bh=Ro6himWcqKrgb6Dq0mwseceztC45BmtxzV9wUW+w0RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ej8iVEWq4nHLsxhtuMWKtG1qwvU3+h5nUBBNtsCpoiINXEPEBiCdAHr4rafxatzQ/
	 h+76ZxCiG6Re+RAbG2gxqgLDEUiVCTpWQ6cxtovZ0SfEuvR36+Un5JBRjZidCBPVdr
	 RsWzhMs7O0Qh+Hzs6rMCP3KIhbGcy3AyMm0erBVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0652/1611] perf c2c: Fix use-after-free in he__get_c2c_hists() error path
Date: Tue, 21 Jul 2026 17:12:48 +0200
Message-ID: <20260721152530.053969727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7efba102996439..0849092ef5fc1c 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -218,6 +218,7 @@ he__get_c2c_hists(struct hist_entry *he,
 
 	ret = c2c_hists__init(hists, sort, nr_header_lines, env);
 	if (ret) {
+		c2c_he->hists = NULL;
 		free(hists);
 		return NULL;
 	}
-- 
2.53.0



