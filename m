Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E4733032C;
	Fri,  9 Jan 2026 12:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960107; cv=none; b=Dq5u8cZ0BqSiFjaWDrVUy9cASmpgd9+8JQ1uWrc+LRekk7cHpRrGB4SeC4955kOQEGtmwfdOQNXJ/jA/v9Vf6tzbyX2gJ/qhiV7d16V8YjsRo0CRCkaTfeOYyfnyhhzX+AAHfyNpVqfaXjV0+0I4P/GVZrW+F5nldRnna1C7BUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960107; c=relaxed/simple;
	bh=G8zuocPnfpz1JQRnoUwhr337jq4oxTeXepwP0HF2u+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzGOKAKXI1scM5lwKHh6DZFYQ/5YbZcO6dWLezWO1Z3ubFT1lwuAoKmKOBJUDiCqjRun0pUKjnQClou2JsOny0nd2STAzSEaERF101Dh/ibonlXD0HFB8A+rbbSja9/AhmrnPjHTVNc9V+ektSesmHGeDqxleif1pR4O+haQv8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p57inx2b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p57inx2b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681BFC4CEF1;
	Fri,  9 Jan 2026 12:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960106;
	bh=G8zuocPnfpz1JQRnoUwhr337jq4oxTeXepwP0HF2u+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p57inx2b84z73PG/DYnSAWBWJExEC5eUoH6+M4Kc2RzK2ItNuvt4SvrP1WzRFhRkU
	 vZzdb8LFvxEve8T1rHAdOMcQ2hrhjLieqGWxCaL6E8dPxb5M0JeLCuCTTk+pMvJSlj
	 ks8+ycVVj/EkGQkuv/+XHbPHgfrFg05WrIf2vJX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 254/737] perf tools: Fix split kallsyms DSO counting
Date: Fri,  9 Jan 2026 12:36:33 +0100
Message-ID: <20260109112143.546528814@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit ad0b9c4865b98dc37f4d606d26b1c19808796805 ]

It's counted twice as it's increased after calling maps__insert().  I
guess we want to increase it only after it's added properly.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 2e538c4a1847291cf ("perf tools: Improve kernel/modules symbol lookup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ea24f21aafc3e..18556b7a76563 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -905,11 +905,11 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
 			if (dso->kernel == DSO_SPACE__KERNEL_GUEST)
 				snprintf(dso_name, sizeof(dso_name),
 					"[guest.kernel].%d",
-					kernel_range++);
+					kernel_range);
 			else
 				snprintf(dso_name, sizeof(dso_name),
 					"[kernel].%d",
-					kernel_range++);
+					kernel_range);
 
 			ndso = dso__new(dso_name);
 			if (ndso == NULL)
-- 
2.51.0



