Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D95474275;
	Fri,  7 Aug 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115063; cv=none; b=O0xIUqWlbAmApmGpWN0zgEGq3pDJbpD7yd61S/1c7vecIwJg53/Z1gNKFB1OLhqjjBEPf1F9eOfCljQ5v3TBjCAATiWotVcNNM0YQg/o8HhoyseE3yLp8lPRPopBdwvW6ySsIWOOOhcYlzODgDFrqPYc3j5mQo78KFxl28kwVxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115063; c=relaxed/simple;
	bh=bmMTedOrvigIn7r4b6G3IRg8V9X6sxg84ed0QdkJfzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9KMu0VBbTL353low05nS0gMb3NvJCZDRNvH1MXlWYAyu5Iq8p1Jk2oliDTmhIkG3dM7GF8SxplHX02dehpDAnK4UFyfqqWJLFlTu3l6hZpJ5S2waQTm+320pSMwjPbSdXQgV6F4YzTQtRR4bWfLA9et3eVPaNqF1nDyexE8RJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMd6kbv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMd6kbv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547CB1F00A3D;
	Fri,  7 Aug 2026 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115050;
	bh=/zxC3KO3tcmQ4Sfs7IcD1Jbsu4IkgBUSJt9lJ2JQgUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMd6kbv8zuViJEYC8NTL8as2ilkAy5Q5QmnkBBb66xhduD7u6JfjsVVfcrysVk33e
	 a/TmfaYEh6O0PugMxHDxIXrTblX/KRsVsyNDWloVXkeJhV57k+Wuq1xWCh4fjiPfBu
	 KKKjSnxIh3ZkbyqBnn9IZSHdQXhzWKoo/gLlE5RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 138/396] fprobe: Fix module reference count leak on error in register_fprobe()
Date: Fri,  7 Aug 2026 16:34:58 +0200
Message-ID: <20260807143427.286414393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 8cf2f40ceb85047ad8a84dffae3bebc9fed18216 ]

In register_fprobe(), get_ips_from_filter() resolves target function
addresses and increments module reference counts via try_module_get() for
symbols in kernel modules. If get_ips_from_filter() fails on the second
pass and returns an error, register_fprobe() returned directly without
releasing module references acquired up to that point.

Fix this by ensuring the cleanup loop executing module_put() runs even when
get_ips_from_filter() returns a negative error.

Link: https://lore.kernel.org/all/178528125360.101985.4144133640239273153.stgit@devnote2/

Fixes: d24fa977eec5 ("tracing: fprobe: Fix to lock module while registering fprobe")
Assisted-by: Antigravity:gemini-3.6-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/fprobe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/fprobe.c b/kernel/trace/fprobe.c
index 01f98f8a86e60..1c9ae332afad1 100644
--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -868,10 +868,8 @@ int register_fprobe(struct fprobe *fp, const char *filter, const char *notfilter
 		return -ENOMEM;
 
 	ret = get_ips_from_filter(filter, notfilter, addrs, mods, num);
-	if (ret < 0)
-		return ret;
-
-	ret = register_fprobe_ips(fp, addrs, ret);
+	if (ret >= 0)
+		ret = register_fprobe_ips(fp, addrs, ret);
 
 	for (int i = 0; i < num; i++) {
 		if (mods[i])
-- 
2.53.0



