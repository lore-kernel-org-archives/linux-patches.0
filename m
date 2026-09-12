Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BEB343889;
	Sat, 12 Sep 2026 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209331; cv=none; b=kMSZ1tgacvBo6nOk1PnbKckY9spI97QPJigaMxgiTvfIkfAbmQ8XJZrsR7HXef3jJmUD7ja5n6ake2gi6P5VdTdJQFZWkAU7JEikTfpo6rkpDAsh+DRtX1lEaum7LxV842IkdnHEddv8PQsUcOjgzxZwS7DK320PmpNcfaA/eh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209331; c=relaxed/simple;
	bh=jDxoLEInKzJEuzYmaJZszJfU/r6JdZ6BRa8OaQ3R0aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUKWqCtU1yfONMl7ga+lbG5SlVYOio7T2QN8kH3qO0KbWUx9L4Sfo2lo90UvilzVC/3CReUME3OPQ35MuRrcoWpamDRH4Q1yMATxT71cyw5YhUwqtwjYI8EBrgLZg6GQLq4GweklYC2XNRhYL016znlufhGVATlMUjp1SrOc43c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRoEWMwR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRoEWMwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BEA1F0089A;
	Sat, 12 Sep 2026 10:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209330;
	bh=FvpZUzBdhhe153XCrd37kUMRACAyKnEOmng83suNaSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rRoEWMwRc9aT1iiv2Flp9VWdJSIzzVQzyoDSrUELAk5WtUFHQgrBJv5zRThAM6XTs
	 1SGeSiVg6dm7hBHBo3rbGkPb9I5w3HFGRU531cZlSRKLigYjFKIUih2oTzj1W1/tbF
	 czNmXoYjtWRHwlBQ1JSyvx0bFzpr4f+6dKh2FPGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0782/1518] perf machine: Check snprintf truncation in machines__findnew()
Date: Sat, 12 Sep 2026 08:49:11 +0200
Message-ID: <20260912065641.127599640@linuxfoundation.org>
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
index 25591f9969e15..8455cd94756e1 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -327,7 +327,12 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



