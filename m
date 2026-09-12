Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6390C19D8BC;
	Sat, 12 Sep 2026 10:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209439; cv=none; b=qiSOVQrXm+TxQohR02DbVWv7cWQ12sZV4ybTiricUwdmcwZJr8O502j3mJZTVqWxeCVpQF8tg1W6WyhUbRh4EqPIqM3xLpty0pkDeyGCcQcQ/VYKyHyD/Txnvw9JXbXa/h6XhkmpUZiZ5SWF3sYM8EoJuDKHSGeWIUEj1TpJB7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209439; c=relaxed/simple;
	bh=kr/HpEklYr030ggN1RFrzAH2zexjxvHW9fRfJaousd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B87a6uBLceUz37yt4pr+rm3YszS6GfuJvAAq1imrBp3tTp0zpYbDoePXJQxzbq06QjCMFWAV6QHHhe8oLraMf8PDxpsalhJzK7To0mMlIzK+fqlN8bEjWyktGstkvyVQwGsCEer81E4Igds2EtJ3NE5SaftyLDKWU887mMuuTxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LdSQt2Dc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LdSQt2Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1AC1F000FF;
	Sat, 12 Sep 2026 10:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209438;
	bh=1JxvbaJqR7u1xtzmQ7XSSYw2PWormdyWgP1Wyi0rkDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdSQt2Dc+aQmmY8THY+r7QGEMB7l7EvCEBUTQYd7siqFh7J1V79HCRmEefqinpsTi
	 lrzNsBzB/ZetEWn4NoxEUOrDtvF4JIJUeCILFspn9B1s6+4oJvyV2L6dKqMk+4mmZJ
	 H7rfFilDqdTlG9xp7JLKzE0UT2Nz3HenoIRjldxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0784/1518] perf machine: Reset errno before strtol in guest kernel map creation
Date: Sat, 12 Sep 2026 08:49:13 +0200
Message-ID: <20260912065641.173309971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 29ec46e43f6ca7d6a6651db724d4ffd820f46e8b ]

machines__create_guest_kernel_maps() checks errno == ERANGE after
strtol() to detect overflow, but does not clear errno first.  A stale
ERANGE from an earlier library call (e.g. scandir internals) causes
valid numeric directory names to be incorrectly skipped.

Set errno = 0 before strtol() so only the current conversion can
trigger the ERANGE check.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b35c73618ea02..7489bc84a3d39 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1237,6 +1237,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				/* Filter out . and .. */
 				continue;
 			}
+			errno = 0;
 			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
 			if ((*endp != '\0') ||
 			    (endp == namelist[i]->d_name) ||
-- 
2.53.0



