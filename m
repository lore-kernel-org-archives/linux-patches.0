Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFC747125E;
	Tue, 21 Jul 2026 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657318; cv=none; b=iUferxRqAeAHlyHXLa3m02P0OEeqaZeDJcBC9w6KZ8soTxtl4h39l3AetDMrzG6CS5iwUbl1xA772xdsdMNYD3sAOHgFUXiiM1w7v2LP+j6/DKdzJ3d5qxHB6P89PKmcVdlGiaEl6S7yoTMvrCDQreDwVOz3phk0fQ6E0Iys+AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657318; c=relaxed/simple;
	bh=t5h48aJVAA8WQDHOmPujahDPeTQQGqMtG5DzGf/YM0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvtSJj25tggmnjIA54ONsK+lQeJuSdsCUZzQqzOS0Mzghee5rNtEDhxSa210SPmyOIsHtHAQ56wNfCM7o1GTlIVcyCSLJ9zGqPjhu+GJxlJg1p6fzh0pZ3oP6rCO4ZFRZ6i6xxvX6NUGn+6n53ReRwNpVwMu1VMhrUFa7RP5qg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ7lAiDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ7lAiDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B591F1F00A3A;
	Tue, 21 Jul 2026 18:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657317;
	bh=orlAieiDJqWpO+idE9sEMQRstEwNVTTc+A+3Mmg0QPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZ7lAiDhdPB59mLH2xj15T5Evi0gT5E/EDjebWyEnlN5mDXT6XbjAmidMpnKKTtsq
	 Pb9MyRBzAp59F208PdlQFyi/xEvqSYwyM3QefebBM0aKqHoNzNuG1BWxazewOKwkUQ
	 zNHOS2u5lh1dKXCecMyv8u1Gl8Iq1fOVHOf6XIX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0719/1611] perf tools: Use snprintf() in dso__read_running_kernel_build_id()
Date: Tue, 21 Jul 2026 17:13:55 +0200
Message-ID: <20260721152531.553187465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 2ea64782a428bed74f595961e651ceb8c4c5bf22 ]

dso__read_running_kernel_build_id() uses sprintf() to format a sysfs
path from machine->root_dir into a PATH_MAX buffer.  If root_dir is
close to PATH_MAX in length, appending "/sys/kernel/notes" (18 bytes)
overflows the stack buffer.

Switch to snprintf() with sizeof(path) to prevent the overflow.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: cdd059d731eeb466 ("perf tools: Move dso_* related functions into dso object")
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index dc202d49437217..3077f2ab3f125a 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -1703,7 +1703,7 @@ void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
 
 	if (machine__is_default_guest(machine))
 		return;
-	sprintf(path, "%s/sys/kernel/notes", machine->root_dir);
+	snprintf(path, sizeof(path), "%s/sys/kernel/notes", machine->root_dir);
 	sysfs__read_build_id(path, &bid);
 	dso__set_build_id(dso, &bid);
 }
-- 
2.53.0



