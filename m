Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C84E380FC7;
	Sat, 12 Sep 2026 08:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201098; cv=none; b=Y2bIxs0frNnxlRMQ+3Vv9dp27rcPzoPtuWLThds6KqQ9uN7HuEch++dgEd0gQXiED+CMcTiurVPCz8pqgHGqp2yrlvDJEY2LBDlC+KYIzDefLkGjwIoOL25lAOu34Qb/MqjtBJPbkaPSgU46LaO5Evm/NKOs9Zl5vnyxHjPtiSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201098; c=relaxed/simple;
	bh=lBBgMe0y1Zzd7+irzmGv/UzSCckHcVASqfgqHJfRNGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5B8lNObEPFrqv3ZfLKYvMzVMJyEtVAds07NadKyJNVPHddjMbtK0xg40DfVG/Di5KUZxkhRRnn+IgWc7Ai+DJrseq7ubcc5c3LURe/Cq+VLFpDuFfmYiMJqMCrpmEhsMvH+KBXhRvDg23Ja90MLCF7rUOutEz1g/CELEZmz0Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftaaK6+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftaaK6+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452F71F000FF;
	Sat, 12 Sep 2026 08:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201097;
	bh=DiZO4FL3wnJFvLHUk3+at7ebd19WjFaeBESRfLUz8bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftaaK6+mVtdJyYqSwbGjCLmAmPYluSz3M9xdEqRzCfjBRAJ5YvdF3XlNAdmeLpjyU
	 CeB+CmKxpAFFybZKeRvAKZBstbdR0LgBj+CEx9N8RCxbrrdPAlM3ys3q90+o2G3Jsj
	 NDhpYmMtNYHavBr5cES07PuMd/6VVgtjaFDraRdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0927/1815] perf machine: Check snprintf truncation in machines__findnew()
Date: Sat, 12 Sep 2026 08:44:37 +0200
Message-ID: <20260912065710.703426889@linuxfoundation.org>
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
index baf855e596c26..05724277c2a97 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -333,7 +333,12 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



