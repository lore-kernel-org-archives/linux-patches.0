Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95D346E016;
	Tue, 21 Jul 2026 18:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657284; cv=none; b=jLyBvKFmCHroP0425GnI2CqGhOIGie/2RtFEnTxLxp2UApkO49foGp/TsHa0knr7U+249n/+mL40vnAgU8x1mw+nXRJYV52zH2v0aqBAGHV8Q7II1FiKoLBwa7SnPCZ17a1BTTN79TfX4S6MZ4XZ3oMQxsqHfhW6g+FRBdvkyI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657284; c=relaxed/simple;
	bh=01GWofTU9wNJiPwPhHAFEXK6KFfgxwAkU4l/qICCZYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=umA8v9GLM5emkYQxy1+hcRzIwq6nnT21ea2QMr0wFoz1/re030Q+cL1GIAMcmZyLL6/zP1IZ94hIec1MKRLM8F09LgutycvINQQ76AkiiY83VKsanJ0CV0FQ2b/hdhHKvPCmsc/HEnZjm5oZQMLCt34RZ5xC6VPRSEuRlwcOVGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvW83B62; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvW83B62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4873B1F00A3A;
	Tue, 21 Jul 2026 18:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657282;
	bh=sTELLIxReqe5dnTmY9jwdjt0xhSGPuTQsOn1Qq3ZI2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvW83B621/w1cUMnBGZu3QRFT9UgKxjOj+KmGXwO3EQXYwSfHUvBftCIZardOzkfG
	 TC+6RKhtK+lY8JiR3DlszjFTiztPlqJY7sMyIaGQijyF9qL0MFVfAceejATjCFGqi9
	 ZAPMuPmWmPsK1OboooGuzIgF09XU1LEsjvnRXYTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0707/1611] perf pmu: Fix pmu_id() heap underwrite on empty identifier file
Date: Tue, 21 Jul 2026 17:13:43 +0200
Message-ID: <20260721152531.282022245@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 836455e6dbd34eb3d12eeab5e2d2b9a7f1512459 ]

pmu_id() calls filename__read_str() then strips the trailing newline
via str[len - 1] = 0.  If the PMU identifier file is empty,
filename__read_str() succeeds with len = 0.  len - 1 underflows
size_t to SIZE_MAX, writing a null byte before the heap allocation.

Add a len == 0 check before the newline stripping.

Fixes: 51d548471510843e ("perf pmu: Add pmu_id()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 3d1f975e8db9fe..0e65025ef9c2ba 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -856,6 +856,12 @@ static char *pmu_id(const char *name)
 	if (filename__read_str(path, &str, &len) < 0)
 		return NULL;
 
+	/* empty identifier file — nothing useful */
+	if (len == 0) {
+		free(str);
+		return NULL;
+	}
+
 	str[len - 1] = 0; /* remove line feed */
 
 	return str;
-- 
2.53.0



