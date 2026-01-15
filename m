Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242A72C21F4;
	Thu, 15 Jan 2026 17:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499124; cv=none; b=Cxm3049hDpD+qTApkgAr3k6AYO+j/ewFAJk8OtDXjWLfXYE6ICaUSPZ6Eu0q3onLxodKJyVqR+ARCWN805KnqUoQPx0EyqXvw7Bo4i1i7Gs0z33Se/Wi6+BHIuWWIEbGuynuxB+frGzqO0b43zP/fEoYj0RNil+sAs3EpZrnXJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499124; c=relaxed/simple;
	bh=1JS631BzlddkNwQcyl3ytB0om5Z5qRKNwH7t+bX/M4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkR5hPSi2WCdfktcLbECXKy8uipk8NBKsH4IjG5Tj8OH+RakI3izKSkZU/dIXL8i23MlayZDQz1Apmkkq33AXEHydUTNlNxuSVY0SbnAOASjq0QNMODo9idEqfbGofdWumsHjgoAupn5gOf9osnqRSC9qqpTtDhN00sxWLntxI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WW/vgnYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WW/vgnYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974B0C116D0;
	Thu, 15 Jan 2026 17:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499124;
	bh=1JS631BzlddkNwQcyl3ytB0om5Z5qRKNwH7t+bX/M4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WW/vgnYHECnfiImcr6dvXlfdRRBZVDxT2CqyFgfHxTiZXy2c9Bt2P1n/L0RUMRGKk
	 wBs+A/3uD6U16QYLVy0MJUP0tWpQXQx6TtCxvfcSwB0EnanKsrW/M6KeMOAVLVhPBE
	 YVTv1uoShSOMVeJ6WNxiEL9w1l/maedHXhbU/hao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/451] perf tools: Fix split kallsyms DSO counting
Date: Thu, 15 Jan 2026 17:45:17 +0100
Message-ID: <20260115164235.119725526@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 33954835c8231..40e2362096d8c 100644
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



