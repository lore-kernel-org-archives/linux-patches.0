Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF0238F93B;
	Sat, 12 Sep 2026 19:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242904; cv=none; b=op3768bDE/fe4ngLNjT8aBMIByGtquhX5YMIcskVlXbNxKL04zKwQTXGWuvqQrc/cw1DWwebHVeWRKyDylia5huE8vmqyx3eZQ/o/ccGZvcQv7k2CON3A2JGqGlsJDfTlbmD5zjOE20Z2Z69Hl4aK3t2gHJD8tOP2iwbIsK9OZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242904; c=relaxed/simple;
	bh=HI7twBmxUxeuxT8cQzgt6D7Hci+Vg9j+V8zBixrwY/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3vpLMlYR1d21ZcwM9E2XYrmowcHKvzhroFcAFfE4cIWrlDhxWMhvuBBAFP3lpDCXVF8H9UXrdSkuu4NdHd9NlVHcacS6ruCGGORQquVZXeITtuyCujaIsUfoI0UTli1dp95Ezziqv+UThlIrWQnN2pLgp8cq2X/cN/Tm2F1o0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EUNmydkE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EUNmydkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450961F000FF;
	Sat, 12 Sep 2026 19:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242901;
	bh=7eRh5XPzjN15qleFmyHtRs48Jp0ayJoLtXgWJL1Ujgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EUNmydkEtR7B606V4q0OTipwGSANb+VhR/89eIH2h5fXdjrBFCVzlGSYL8Wihn6E+
	 XVOSakHud5M1YVv7R9JSIl25xNmc/zZjAxImYfZ1llevGTivhURbFLx1hwddbiuhtF
	 UD6v2ScDQLm8JKwNbVHEJFGjZ1GYnr5XrsdtVslY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 568/798] perf machine: Check snprintf truncation for guest kallsyms path
Date: Sat, 12 Sep 2026 09:03:16 +0200
Message-ID: <20260912065530.147417956@linuxfoundation.org>
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

[ Upstream commit d04ef71492fad7230d474efe33d05f4c0563d409 ]

machines__create_guest_kernel_maps() builds the guest kallsyms path
with snprintf() without checking the return value.  A truncated path
could pass the access() check if a prefix directory happens to contain
a file named "kallsyms", leading to the wrong file being used for
symbol resolution.

Check for truncation and skip the directory.

Fixes: a1645ce12adb ("perf: 'perf kvm' tool for monitoring guest performance from host")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index f0a3c454b7870..218df09bbcbd6 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1240,9 +1240,14 @@ int machines__create_guest_kernel_maps(struct machines *machines)
 				free(namelist[i]);
 				continue;
 			}
-			snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
-				 symbol_conf.guestmount,
-				 namelist[i]->d_name);
+			if (snprintf(path, sizeof(path), "%s/%s/proc/kallsyms",
+				     symbol_conf.guestmount,
+				     namelist[i]->d_name) >= (int)sizeof(path)) {
+				pr_debug("Guest kallsyms path too long for %s. Skipping.\n",
+					 namelist[i]->d_name);
+				free(namelist[i]);
+				continue;
+			}
 			if (access(path, R_OK)) {
 				pr_debug("Can't access file %s\n", path);
 				free(namelist[i]);
-- 
2.53.0



