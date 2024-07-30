Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ED418C91F;
	Tue, 30 Jul 2024 16:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356318; cv=none; b=lbJZMuxDdpetEr+IUxWoY5nZ6RPG1Aio24HIPfYkj5tDmRu+cYXUgz1YrpufFJhT5uCrL+5EbkaS8X4yt+RIBNbbCzQAB6LM+2TGzNv9jlp3X+fjlPQB/jD6OGJWR3vVw6SAHdLReWVLcwEJaHtmfD49Wrh4lDvAhjb7oUZ4WCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356318; c=relaxed/simple;
	bh=KvHOg1JD8Y38Pr/0/itkO2UaHKjuZjIemKhp8YyfFl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFj+Q8ziGQpfKLGOxNzkga+PFD1AuI5C3DVS9HvybZmHrSDrtCqO4/yZ/YcZ06/eFoTE7yQyd2M2XY29+Arc+altwsYp5VxVMdqSgAJrPRz3G4qMyaCgNdyX45PSo3SAOKwtEqMST6JVVkWlTepAhY5SdH2FlLBs/da+hKlAvPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czkq3G1v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czkq3G1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0260FC32782;
	Tue, 30 Jul 2024 16:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356318;
	bh=KvHOg1JD8Y38Pr/0/itkO2UaHKjuZjIemKhp8YyfFl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czkq3G1vFS5k9m4bwrYSpNZRGgvmrdtLRV+PcP5NMAqinBbfM1hF5AyX+NmQuLa+y
	 +mLi864pF6PWQVa8KEQmyeiwc3eUEAOuerXxK30VhulmhFQETkLVss2vL3cn0x6g5x
	 Iwh2E6bt2T+vq/AOleop0PIU0HYHyaLIKhKHj79E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/440] perf report: Fix condition in sort__sym_cmp()
Date: Tue, 30 Jul 2024 17:46:33 +0200
Message-ID: <20240730151622.123874585@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit cb39d05e67dc24985ff9f5150e71040fa4d60ab8 ]

It's expected that both hist entries are in the same hists when
comparing two.  But the current code in the function checks one without
dso sort key and other with the key.  This would make the condition true
in any case.

I guess the intention of the original commit was to add '!' for the
right side too.  But as it should be the same, let's just remove it.

Fixes: 69849fc5d2119 ("perf hists: Move sort__has_dso into struct perf_hpp_list")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240621170528.608772-2-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 6882b17144994..1821c81892df5 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -275,7 +275,7 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	 * comparing symbol address alone is not enough since it's a
 	 * relative address within a dso.
 	 */
-	if (!hists__has(left->hists, dso) || hists__has(right->hists, dso)) {
+	if (!hists__has(left->hists, dso)) {
 		ret = sort__dso_cmp(left, right);
 		if (ret != 0)
 			return ret;
-- 
2.43.0



