Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF80318B479;
	Tue, 30 Jul 2024 16:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356181; cv=none; b=JHsRHjdvVp2QrF6egZki+NMoD7y01+dysv21NsUCU/8+sjVJMvTM2Eyjesid2SHIJp4+aMJVxLLjBhuIcQBP0k4ISmGBv5hLv+fl6BfFd876psbYlZJmzQvkvovw/UAmbrHhmJM6kaAM9DCCayAqVdei2lp0vpYMUjD5/KClst8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356181; c=relaxed/simple;
	bh=iGSDcQE2mMR8oUdRN/LF9RKuUKinWqIDeXBFYy1Ua+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQqGrOTwFYiYHzZWbMxUzAt86NYIEDdpGBawtm7HUcL670JQYFM5EFjVHq4TiSUTv8e215WIYX46ZeGqxXwpf1MILwwGTeO0PRP9DEUD4cNuzBcd5w9glj/T9+q+9Wz0XL5quq2MhKrdW2sBp7znyXvS683OcoHCS578qM3nLms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yIm7mMnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yIm7mMnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0B9C32782;
	Tue, 30 Jul 2024 16:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356181;
	bh=iGSDcQE2mMR8oUdRN/LF9RKuUKinWqIDeXBFYy1Ua+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIm7mMnLoZ1jb0yloEpt0/OZ+icMVtKtEoY44hcJi1NC8azZu6p/xRmD47ZcEVg2f
	 4UYGRn7Dr0mWcU8qaXZpUspW//TRqBaX000HQeMyjxEFGyp306Mf8zg445sOobMSPD
	 tuoBeIP44Yns4D1xfzvWvdIPiymi0MQ5uWhCXq8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/440] perf intel-pt: Fix aux_watermark calculation for 64-bit size
Date: Tue, 30 Jul 2024 17:46:39 +0200
Message-ID: <20240730151622.355504974@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 36b4cd990a8fd3f5b748883050e9d8c69fe6398d ]

aux_watermark is a u32. For a 64-bit size, cap the aux_watermark
calculation at UINT_MAX instead of truncating it to 32-bits.

Fixes: 874fc35cdd55 ("perf intel-pt: Use aux_watermark")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240625104532.11990-2-adrian.hunter@intel.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/intel-pt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index af102f471e9f4..357eef045f3be 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -780,7 +780,8 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
 	}
 
 	if (!opts->auxtrace_snapshot_mode && !opts->auxtrace_sample_mode) {
-		u32 aux_watermark = opts->auxtrace_mmap_pages * page_size / 4;
+		size_t aw = opts->auxtrace_mmap_pages * (size_t)page_size / 4;
+		u32 aux_watermark = aw > UINT_MAX ? UINT_MAX : aw;
 
 		intel_pt_evsel->core.attr.aux_watermark = aux_watermark;
 	}
-- 
2.43.0



