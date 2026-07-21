Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0501D376A0B;
	Tue, 21 Jul 2026 21:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669325; cv=none; b=Rs34Qu/cIZE+0SZOwouh4MWrUYxPReJe88ckjkK857NySHTpw5mSla93gQ/tLkGcAMwtK8S7cxt8uUxc/n5zvUBkslks69Qj7O2+3oNaBu2z9ZB3Dn3g2JJSgf13ng7mCKUO1PwZ66Q/5i9w1tw7K+f/Opl4HO2Se9Q78LtygRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669325; c=relaxed/simple;
	bh=UESV4Cc6LhrhDk9t+uYGqy3n7kGPy93B+64ABRDk5xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oltgGE8oCPgqsFVsrTMxPy3ZbCQfhUQLFuLV7nXdcu5Gjpjo69YTAhpNd9Oy5BwGZJiaUVM2CgJ1BS1gKIOkOu5SgX/FdUrRkYqIJzI8BQofdgzPl5iGjtvEXdeK5AebrFRqJpaqL8nod0KXJJqcELuvVVUBAiYEMFSPFoKXu5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/jkrnN/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/jkrnN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ECD1F00A3A;
	Tue, 21 Jul 2026 21:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669318;
	bh=dZBErJyM6dAJZRNA0CB8PEVqpyNXNvWqzeAcssmDEVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/jkrnN/P95OM9Fmndoo79Ui0DA2RHyyqDrvBAgoCpNtriNdbDzETIVW9hgCO/yNa
	 atqxqJs3cUFU/8IRCnlLmMm6BRUm29p9K+LvS5LDCu9fFfHz1gfyG8hzhIEycfGWKv
	 AN8ahQzdK8UesP/St3ew2fTKzcEvLlF41CCDsBRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0508/1067] perf c2c: Fix use-after-free in he__get_c2c_hists() error path
Date: Tue, 21 Jul 2026 17:18:29 +0200
Message-ID: <20260721152435.979307534@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a9190458d2d500..bfba131693bed5 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -216,6 +216,7 @@ he__get_c2c_hists(struct hist_entry *he,
 
 	ret = c2c_hists__init(hists, sort, nr_header_lines);
 	if (ret) {
+		c2c_he->hists = NULL;
 		free(hists);
 		return NULL;
 	}
-- 
2.53.0



