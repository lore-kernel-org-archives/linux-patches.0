Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BE1274B46;
	Sat, 12 Sep 2026 14:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224434; cv=none; b=aOP5KmqyBpl+pmJKiA/DmzTxFJmCL2bKa4LKtumNK952PhS9WYUqCs2o2atQY3vslCXgoy2vBsxh9lie4BkAN1z1MFOs7YBy6gYhJUwfWRzwz4Bj90jy3yeZK7K6i0+t6tqUT31W34W90M4nWfL2kKw2IcvK1veOBsvzPhJI3hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224434; c=relaxed/simple;
	bh=Nt0yhAbqrjTPbsVpi//iASVWzjeH8I6RgjQjwZfZZ+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHZwNSwQHYwnRyftytFi0oT4R6kMFF2SK2HubDImQ7WtTrQFLYf/8sR0Q5DkBr6C/VHO61hrWzbWg94jV+GybmVR6VibibGOc+/ZbJdoHFJvbEszVpWjjXNzUv49xf/AOfWeVm9NWZlH3Qd5JwoWfaE7Ygn+1164NpjxpVsj6ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2Z6fH+g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2Z6fH+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79E91F000FF;
	Sat, 12 Sep 2026 14:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224432;
	bh=j6b5TgHo07ywm5qlCgRYKDD9kOX2/Le5d3d2mk1/n3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2Z6fH+guXZw8GCkxPXEAzIZzFJMS5ITzonjd4ApdPnJ4sKdSG/0AQfxWFVVECJ0q
	 UULW3JyifbNLM/eIgoIyd2/nMMqtJ4kUHi6Vd/ui5HMauB1fRJGyDFwzFJ2NNF+5VU
	 seUAWtBMbLAu9DbKM7nw4anJDImtWuGGWPPWoXWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0990/1424] perf machine: Check snprintf truncation in machines__findnew()
Date: Sat, 12 Sep 2026 08:57:02 +0200
Message-ID: <20260912065629.486451043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6b9184e6efc81..3245c035d96d9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -369,7 +369,12 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



