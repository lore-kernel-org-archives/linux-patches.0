Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA9A38D6A2;
	Sat, 12 Sep 2026 08:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201108; cv=none; b=ImFRcg0za37UDEmOythk055NQu34Fp3V2Bg2tSJ16Nuj0ejR56KWkSrB6PR/CJbkDpD/WdQZgdbBrZhymOk1qbCWgXTdEGdfdor3Vi6FITNbXARMXSktPdV7Uj/lm7ubBHFMU5/b6Yf1B+JnzOPgg2vm7ruzpZPttPedc1hGteY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201108; c=relaxed/simple;
	bh=hXsubn7Y+AAWrQKDa/sueavGooT2vtUwGbcRxRixOww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZe8dSS1/c0cLrxwE8seAItZaKA/U+R5ggDvCdBLorAJTJPQAyoBJeQnu2ghb5Iida3VtF7b6j8KWSZwvoX9hfP89WOLexCjyYbdpNaSfc9gPUk2g+PWcljc8qMUZ4dA5RtWPRa/sGdA5py/DR6k4IRpZfPcQNCSo2uR17Cvec8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3NxiG74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3NxiG74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAFF1F000FF;
	Sat, 12 Sep 2026 08:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201107;
	bh=fGkMmHuMpk8+KU/5xmU4+ejk0jTcwF5a2N8ER2y7l48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3NxiG747oP6wfdR+I9CWLgOJ6QIR+qXMOfHvCRAt6ulne1TYtFEN+WTZ3kuULoTw
	 We4cLNpV2yhslAuKIgHNVBk3cYmEk5QnUUXUBS6VtZy/YgXqBgTgruuymxvfTwYy+6
	 TXSSGNNMMAZ61/NKcRBc8x/En9tPlcmC+j5rIzCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0929/1815] perf machine: Reset errno before strtol in guest kernel map creation
Date: Sat, 12 Sep 2026 08:44:39 +0200
Message-ID: <20260912065710.755438936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 83d38637afe34..1700130adedb3 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1258,6 +1258,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				/* Filter out . and .. */
 				continue;
 			}
+			errno = 0;
 			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
 			if ((*endp != '\0') ||
 			    (endp == namelist[i]->d_name) ||
-- 
2.53.0



