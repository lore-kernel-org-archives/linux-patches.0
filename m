Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AA2390212;
	Sat, 12 Sep 2026 19:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242897; cv=none; b=d5czXb+ZIV4WSCk+xd5kw1rAgS/HgNuqiOGUwoEtTzwzixfpl1FRX0OKAi627f+XLB5IZ2oAPhWxZ1gSR6Hz7dgzHX/HUitHyMT6NLmzY//rlm1VzYlH02B9sAT3o3w/1VSUM9vLLldtDswNYw14NXfBNVjN9TI1Qtnf6yKtt6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242897; c=relaxed/simple;
	bh=5tIfNxjzvqsrIN3AcsMYnArYpvSepcM5+s7cBu6SUFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKG1i7msF8AwnKgXWvgOGMJ2Ax9esSwsLnLuw7jiNRICdNMlshTiBXpCT0C1+WAzEUXKEcMlOJJLMp4Luf0dja2XA4iUvNb9sdBBcNVuUAvV+v30cZ35XQ92EDenLYUcGVW4pJKEmm7cQer+qr77hqQTgNIVCW3JRuPCtzYYz10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ye3tIum6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ye3tIum6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B95F1F000FF;
	Sat, 12 Sep 2026 19:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242896;
	bh=6XuMrFXlWBIkuSuMwHzvdueuaCDe60I5S2y5FksdIyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ye3tIum6uUF1NNeRSDm5ETwpMX5VMimxnTTa2bu4XezkRF7z2GooiF837TKArTeX6
	 zRt3Pj/g6ewmDWx7tjbu9qTDC1dueXs/P2aFwqUvPQMI3kkmTF6LFlb9v7ANuJmgOO
	 a7HRJGCZZ+U1XuidN4kbj7tCynBTz2Wc40r/iSus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 566/798] perf machine: Reset errno before strtol in guest kernel map creation
Date: Sat, 12 Sep 2026 09:03:14 +0200
Message-ID: <20260912065530.102585122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 197d68d533b1b..7cea0827a27bc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1229,6 +1229,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				/* Filter out . and .. */
 				continue;
 			}
+			errno = 0;
 			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
 			if ((*endp != '\0') ||
 			    (endp == namelist[i]->d_name) ||
-- 
2.53.0



