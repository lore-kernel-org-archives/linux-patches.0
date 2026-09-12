Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13D2242D65;
	Sat, 12 Sep 2026 16:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230532; cv=none; b=vEpvZA+/NH4WiNg+t0Pa2l5GyKcxjg4Pp7KqJkBq6r1z+5qbtDty1qe1Zn9+pa7d/JtcKiPsx+Q1zWS9+o6JTnWV6XPy4Y5jrjPc3ss4wKMtPjnHJIkTUVLjxXLtEyUYKE/YJb++H92PSrUWlZ8rDnU46Vl07S2hADRYqePCKR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230532; c=relaxed/simple;
	bh=+sRORNLWPQbm1+j+WYLeGmQOoGOaNgi3SJCulUueyYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzvcafFoyXapUQmtT6MUqz14H1OaCoecQu/qHJZ9lk9InRe4QMxF4Ck5EJ+Z9NDbaEexD9DcNUvEo0BXZdcpGWIoI57yGLuEPD6j9uHRXvcu1Rlg88utZZQ+AuDzyfms4VFaaYTfjyOoa5GAkG1FD31GghCuNd6oQ/JQSKTBy4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaOMcbOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaOMcbOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C3B1F000FF;
	Sat, 12 Sep 2026 16:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230531;
	bh=wKBXDJS0wndqg3os0U1hcFUMQu/432OfCKHBfFI9LCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BaOMcbOM6GPwkMu5cQ9Tf9R+SLirt6/8zPEn/aZdOyq5yIVAwaTyImXhVdBshHXqS
	 3oJM0LkchUMnR7nbCSkDgaWOq6MVQruT8eZs1mA4lz+JdI4wot0yBRi8R1d0J2pktA
	 u5H0ztBukEcyXIbivOr7WQaOCSTNZXwBOGezupB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0812/1191] perf machine: Check snprintf truncation in machines__findnew()
Date: Sat, 12 Sep 2026 08:59:00 +0200
Message-ID: <20260912065606.507572623@linuxfoundation.org>
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
index 2a9b6c68b767f..979163670508a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -362,7 +362,12 @@ struct machine *machines__findnew(struct machines *machines, pid_t pid)
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



