Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB05A1F7547;
	Tue,  3 Dec 2024 15:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239083; cv=none; b=VjSdS+9iDbesDeyt5svoKtFvYFCeaNpgXkSseeO7ar8jMnyAAx++1A2+sGxbhuE0c2PdJaZRHdwvFQuy7BqhuRO9XIRzXid6kAgy3weY1NEs+6PV2Kr5YDtITPgknGV3G4Zxg8brTPiSfGpsVuqhc8MkIqu4E9BhW0NYHWAPeDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239083; c=relaxed/simple;
	bh=CWH8jan3El3IVHnEfFCx8Ar9X9qg5SSQMWGua8g58MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh1glmlO1jUk9hak0y3ID0F+assaJkSXLpw26bgg7oHDKuOosoSpsvCkeMCrb0d2lqF+dNww7OkSFgOtSZ0wQSilPeLZhq2T1UTyWu/9DI0GpZWGmdhZFMpUd8kRQh+Qmm0FdlR2Ljroyi2H3N5akth1vw+b+z6sRWKPBsvybKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LPMLqr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LPMLqr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA5CC4CECF;
	Tue,  3 Dec 2024 15:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239082;
	bh=CWH8jan3El3IVHnEfFCx8Ar9X9qg5SSQMWGua8g58MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LPMLqr898b85pRQiMrUpouNRlEYTiviv45B/Li+wCnfN7KxZijZcRM2LAczUcVPb
	 38z1K5sFUUYioA4l8ROsTyCung0DcwFDA9LlC1nYY0Fj5pDQnNUcHk2Bqlyi7UcGjS
	 ihgNevxUeAETZDcYRajma5cw7aeZBdwWDMk2Mu7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 496/817] perf dso: Fix symtab_type for kmod compression
Date: Tue,  3 Dec 2024 15:41:08 +0100
Message-ID: <20241203144015.235513302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veronika Molnarova <vmolnaro@redhat.com>

[ Upstream commit 05a62936e6b14c005db3b0c9c7d8b93d825dd9ca ]

During the rework of the dso structure in patch ee756ef7491eafd an
increment was forgotten for the symtab_type in case the data for
the kernel module are compressed. This affects the probing of the
kernel modules, which fails if the data are not already cached.

Increment the value of the symtab_type to its compressed variant so the
data could be recovered successfully.

Fixes: ee756ef7491eafd7 ("perf dso: Add reference count checking and accessor functions")
Signed-off-by: Veronika Molnarova <vmolnaro@redhat.com>
Acked-by: Michael Petlan <mpetlan@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Michael Petlan <mpetlan@redhat.com>
Link: https://lore.kernel.org/r/20241010144836.16424-1-vmolnaro@redhat.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 706be5e4a0761..b2e6e73d7a925 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1342,7 +1342,7 @@ static int maps__set_module_path(struct maps *maps, const char *path, struct kmo
 	 * we need to update the symtab_type if needed.
 	 */
 	if (m->comp && is_kmod_dso(dso)) {
-		dso__set_symtab_type(dso, dso__symtab_type(dso));
+		dso__set_symtab_type(dso, dso__symtab_type(dso)+1);
 		dso__set_comp(dso, m->comp);
 	}
 	map__put(map);
-- 
2.43.0



