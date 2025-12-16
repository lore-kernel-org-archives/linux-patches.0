Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7664B358D27;
	Tue, 16 Dec 2025 12:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888469; cv=none; b=j5oXSTST6eplZY9sdEFYn1jMYm1+gJaVpmZh1BpN67Ch7sNtj8aoWWoJQ1KTs4ZGoGYi3+TpHiPpws3JAWXQ+nNMIEMx344yLkKHV6qU/smmXzFqSrevfTWF+3dmRSAWZCpy7TjoJRdgTqO19s7i28leZ64SO5a5oqPHN9Nsdqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888469; c=relaxed/simple;
	bh=py0xIVuC7qmBNk+yqb1mdV2qMur3R8pJSsbDBg3bDPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7H/lxFotDCWC9j3l28HkzycI7lRTRrJkg0dWM3qLnzrCx3lnCSlgVvfCn5YSusYUMFLpBH/ZPF+tCX99bPNt2q4d7/8D24vFAREO3NRkPm6MFZ2cGenDp6z+JrVyhLOgQpu3uG+hfcsvvorMo+Jt9x8u4GhmTP9oVclrPP/9kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIPsmfIJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIPsmfIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F166C4CEF1;
	Tue, 16 Dec 2025 12:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888469;
	bh=py0xIVuC7qmBNk+yqb1mdV2qMur3R8pJSsbDBg3bDPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIPsmfIJXLDKMPPxqYlxjHQJnVYt7buODD30PNrQyrwKlfBu4wL9Mw7nKP3JaM11/
	 Nlja7EAZjqDFk+dOPABJo/614GtjMTMJPzIul9i5RoQVQDRKNLze+HFFhdwSW6mZCx
	 Bwxc7KNMKNm7KL0eBUd6tmaOF4G16Z4ui2C1hQq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 526/614] perf tools: Mark split kallsyms DSOs as loaded
Date: Tue, 16 Dec 2025 12:14:53 +0100
Message-ID: <20251216111420.434051819@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 7da4d60db33cccd8f4c445ab20bba71531435ee5 ]

The maps__split_kallsyms() will split symbols to module DSOs if it comes
from a module.  It also handled some unusual kernel symbols after modules
by creating new kernel maps like "[kernel].0".

But they are pseudo DSOs to have those unexpected symbols.  They should
not be considered as unloaded kernel DSOs.  Otherwise the dso__load()
for them will end up calling dso__load_kallsyms() and then
maps__split_kallsyms() again and again.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 2e538c4a1847291cf ("perf tools: Improve kernel/modules symbol lookup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 948d3e8ad782b..aed65b1abe669 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -976,6 +976,7 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
 				return -1;
 
 			dso__set_kernel(ndso, dso__kernel(dso));
+			dso__set_loaded(ndso);
 
 			curr_map = map__new2(pos->start, ndso);
 			if (curr_map == NULL) {
-- 
2.51.0



