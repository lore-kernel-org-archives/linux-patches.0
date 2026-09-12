Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651491C5799;
	Sat, 12 Sep 2026 18:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239397; cv=none; b=DBJT764ym2u/CgWSsZGqwcTGikEzxkAtrYn49rnhnpW8DcsT5T81ySQSEai7x+Hxuq0Oex/gK6JyVLSVGUEP8KQITT4THKvK7N8or5q7OhxOmRlWNHOAp+UIDTqcf9dCiqYFlL66UVYHEttIlPOWBUQ10zSBap3awoyOHny5y/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239397; c=relaxed/simple;
	bh=iig7lm+xDVGz+g4wcYLXWk1w5Rx5CVNw1ZKMhGA3SGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giHZ0+dfj4LV5u5GSEtvA3D+vexMKSTkDZK8qGgpaE33404qnynmgJiyWbBwBiEwFG08/8rKU3Yrm50mHh/nnAIW8byBxgD8STn0tAHQBOaO/Fomr5m12/nZ1sGqcfvc5/6DstqJ0//2l/UE8PzgF9/Z4QUExkw07JmMRywOz+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clwzPLcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clwzPLcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD551F000FF;
	Sat, 12 Sep 2026 18:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239396;
	bh=7dqv38ZB6LzqxhiMD1uYv+rZjnMGr4jL0xZaZZR8tcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clwzPLcO4/bGgUxfV/3hwr2ljxVYcb951KiAFKl6X1u6z+Zw7YsvmVYbxdoT1altj
	 kBYLQ8Fjke0qJD5t87YLLR4Y3b8VkZFQXZ6mxaSfThDcrUdEx1hIQl38FjxR8nQ7OY
	 v+BjtSioNKjYg4/YT6IJhtPPffFuunTAlUKQjtJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 656/935] perf machine: Check snprintf truncation in machines__findnew()
Date: Sat, 12 Sep 2026 09:01:26 +0200
Message-ID: <20260912065541.887658184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

[ Upstream commit cc6abe0012bf8c04af8275266f8ed7c55ba4a5fb ]

The guestmount path is built with snprintf() into a PATH_MAX buffer
without checking the return value.  If symbol_conf.guestmount is long
enough to cause truncation, the truncated path could match a different
directory, causing the wrong guest to be associated with the pid.

Check for truncation and bail out early.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 6c10a902cafa5..3fa2975a64ae1 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -348,7 +348,12 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 	if ((pid != HOST_KERNEL_ID) &&
 	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
 	    (symbol_conf.guestmount)) {
-		snprintf(path, sizeof(path), "%s/%d", symbol_conf.guestmount, pid);
+		if (snprintf(path, sizeof(path), "%s/%d",
+			     symbol_conf.guestmount, pid) >= (int)sizeof(path)) {
+			pr_err("Guest path too long for pid %d\n", pid);
+			machine = NULL;
+			goto out;
+		}
 		if (access(path, R_OK)) {
 			static struct strlist *seen;
 
-- 
2.53.0



