Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1677535C6B8;
	Tue, 21 Jul 2026 21:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669482; cv=none; b=hybfjYza7gmnjSGozo/tFONpJQ/CroX+wuRBxhy66K/TS6v6V2E/C7857xrwQkR/lpfizPyxkNUFReE9Fr3lwR9QZxaR+xiaHmiJ8q6+3eTVhylip3dMnaHeVj8V/K+fCsYtpyJg3dr+wGo29vYatLN99JfjVF0T9TVa7lWws1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669482; c=relaxed/simple;
	bh=wzQClRcYf+ym0gjGNasZST29TWuZA32+l/7YXBXp2u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOlR7kHcMc8DCt4RRe2VnONK5SMxAEJZgX/oO73y/gTdUeZiykPn2jVrLbeDQUE5ZfLit/c25xUzPORCcJ7dZhUrlu2wSy2vFsd7Fqm2ObR/y2X+ZFbm8ssCwhlhTdo6/WT8BoKQlgOxUgATQ9A8r4jMyeTG6M+gb95ZdQIYU7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWjkL1Dn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWjkL1Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9DD1F00A3A;
	Tue, 21 Jul 2026 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669481;
	bh=/8lKBssrdgGzqq7DjoEIhJuuqtWDeX3Mg6ys6MnrTjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWjkL1DnLB80ViY5LdKVbw695LkxUXHnBZ0p/NAYex8dyqjDY4A6ONKQfYN1eBVAt
	 +shCKuxgzlU6RaVppOLvjjPVC2t0R/C5DIRHkheeMAj6rSXt27gM19Y3k3t9J1+vJO
	 Fq+rpIpBMHp6Ubruk71DLiMz/uaRMY2QYgKhOgyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0572/1067] perf machine: Use snprintf() for guestmount path construction
Date: Tue, 21 Jul 2026 17:19:33 +0200
Message-ID: <20260721152437.401219936@linuxfoundation.org>
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

[ Upstream commit fe63d3bca288c5bb983304efd5fc3a5ff3183403 ]

machines__findnew() and machines__create_guest_kernel_maps() use
sprintf() to build paths by prepending symbol_conf.guestmount.
Both write into PATH_MAX stack buffers, but guestmount comes from
user configuration and is not length-checked.  A guestmount path
at or near PATH_MAX causes a stack buffer overflow.

Switch to snprintf() with sizeof() to prevent overflow.  The
subsequent access()/fopen() calls will fail on a truncated path.

Fixes: a1645ce12adb6c9c ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 419147da8d672b..41137c7b4cdacc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -362,7 +362,7 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
 	if ((pid != HOST_KERNEL_ID) &&
 	    (pid != DEFAULT_GUEST_KERNEL_ID) &&
 	    (symbol_conf.guestmount)) {
-		sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
+		snprintf(path, sizeof(path), "%s/%d", symbol_conf.guestmount, pid);
 		if (access(path, R_OK)) {
 			static struct strlist *seen;
 
@@ -1365,9 +1365,9 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 					 namelist[i]->d_name);
 				continue;
 			}
-			sprintf(path, "%s/%s/proc/kallsyms",
-				symbol_conf.guestmount,
-				namelist[i]->d_name);
+			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
+				 symbol_conf.guestmount,
+				 namelist[i]->d_name);
 			ret = access(path, R_OK);
 			if (ret) {
 				pr_debug("Can't access file %s\n", path);
-- 
2.53.0



