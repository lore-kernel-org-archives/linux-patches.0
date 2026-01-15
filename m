Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C972F619D;
	Thu, 15 Jan 2026 17:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497682; cv=none; b=aPEvI7xQR96eczy84SMggnCRCuXAKIDhpw0s7tYwqIO2KhqrC1Mtto3eaX6Ft/qC4w1SRhVHfh6ys047m0Ce3wR+pVGDfUITph7dKstDWQ4tAhgiinJPg8hMVtyWZlJrDphfIY0PZGgC52vaf0laaAKklUqanA3amnNIzF6v5Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497682; c=relaxed/simple;
	bh=SuMV9wA5jnEgkQr30/N2y5tQv15JVQKbLoGLnnQ1uGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbdm98A1kT73zRtEP9AQ/+yz0dMppc1j6OMdbtUpAQ9YL3EErrTtpTgxugz1qVCvAoLzxleotgGNe5XQpdu3Rkwvpo34N3SSNyhip9S0Oc+/4I6+QIWIK5eZ4iaHuUHc5lKkSPgDKFdiqM89Fvt6nlLOWNsyBW9PnRWM6iQnd88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0ZK3GcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0ZK3GcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABF7C116D0;
	Thu, 15 Jan 2026 17:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497681;
	bh=SuMV9wA5jnEgkQr30/N2y5tQv15JVQKbLoGLnnQ1uGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0ZK3GcLiYP4Q79/PTR2MFX/BQ1u4gaVWCiMVWFLzUjOTwtMpljoyK9Ho0LnnCzzw
	 vhJsamESZg6IPtZ1hgO1G/FgZngzn54q5EwwFTLvtBQQLYlcyCS839vz1QcSd9QG8y
	 h62fXwv+OtZfn/3SlyVplBqxwSEFKRCxoPmd9woc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/554] perf tools: Fix split kallsyms DSO counting
Date: Thu, 15 Jan 2026 17:43:51 +0100
Message-ID: <20260115164252.240457200@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 80c54196e0e4f..b48d237124e12 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -893,11 +893,11 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
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



