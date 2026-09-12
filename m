Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A630242D65;
	Sat, 12 Sep 2026 16:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230542; cv=none; b=IhE6+5TyZbASPp5xvmZ+ODY308VPhQJrSEvKRXN+OFI62thcrFouBif3b456yjTaH+Ma6b10LdwvzEOpWZtIP7HYV2HRXTztQFdnrZCVXA1IKSvDNGGBSN/JFlYv9GV6gOQ5rPKZQcXGwzszYsofmnAugv9Azqll110FG0Xc+A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230542; c=relaxed/simple;
	bh=hSTRvtkJMDKBeWeAX4OPKOxfJ/lV2tU0OZTqrM9MWhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hexyJDHVeeQzAn8JNJNwsgAlMWVhqSDL3arTYXwtm6AF44VQv/4/2yh0MHmrHJ3GvFCrZl6tlhWoXqwKGolAetPD6wNJCWtjkUulRFkHkb4MQGx46WuX3JZ+0kMOUsCCF6GQ1fDXd1KHWGWBfT3Owrq3eQwpdIZ4+8qmbApDJNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7UClrQ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7UClrQ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544471F000FF;
	Sat, 12 Sep 2026 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230541;
	bh=VqqwagPv8wOZ1cmXGhRYd0ZO6Dv/O+t22TqOY8fErVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7UClrQ7VuIRNZ1tYVOz/X6zHhs1nf8sZLhQAsEpDlgLqhrG0bbq6/vb2c8W2WXR7
	 nPhJ/afCoMLQDydRCr+NrzrVatdaZsnjW4yzxxDjlhAsR97m3B8L8ID4wQSO7lee6d
	 Rv7PNO7IZ9w8EzoTv57TqocoKgfDSFCvxdWNmu9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0814/1191] perf machine: Reset errno before strtol in guest kernel map creation
Date: Sat, 12 Sep 2026 08:59:02 +0200
Message-ID: <20260912065606.550588060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index c0785514753e8..e285ad1397490 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1363,6 +1363,7 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				/* Filter out . and .. */
 				continue;
 			}
+			errno = 0;
 			pid = (pid_t)strtol(namelist[i]->d_name, &endp, 10);
 			if ((*endp != '\0') ||
 			    (endp == namelist[i]->d_name) ||
-- 
2.53.0



