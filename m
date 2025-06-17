Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A762EB5C0;
	Tue, 17 Jun 2025 16:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176727; cv=none; b=i+0/XcaP1UH1/7PiKhom8Ab6Z4iy1WiHOlb3BI0xEEDGTYZ/CU674E9WMcPr0NUo4ehEx9lNqeq5bCMYKVSYs2cykG+pQMZ79zD+o5jF5pGdkQ3A2qGnVpz/PbRMVeJRJRfZvc9SBV56vLoZNfiMq4TqCpSiy1IVFXUKmaqemkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176727; c=relaxed/simple;
	bh=XyZqTJGd1TnqVIcwJCOFb9YIC86xypVDD4rtbhQp9S4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8EfC/qK6pj0zIx2xIrHj7x3r1oFyGbB5z3HiAQhpEtxeKdzwk/GhfJ0D2LaQRG4MDFGx/Ch/PYostiClTF7jWKAj9jDhFkh5V1eWSM0BHhT3qTOq/WklKqX8GNsOTNlJrmsGhbogMU/5Jd+BgNFOzmaKZwhm9suo45JQIsuMTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0L0rz3ox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0L0rz3ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A341C4CEE3;
	Tue, 17 Jun 2025 16:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176726;
	bh=XyZqTJGd1TnqVIcwJCOFb9YIC86xypVDD4rtbhQp9S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0L0rz3oxDKPB7ph9ViKVfNn4hsumxaqPcaSSwJ0IiEWdGHLDA7ck43R9VsFeX2t8K
	 CfQX+rByuZSHnorhoTg8Ojboa+VqWhR5Tlhc9cLVIXzwFMmj/iKX6iAuC/gHNYHvhp
	 Tu3BgCr0syR0sk5mdPMpjw93FYTAnwfXl7Qc8EBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 220/780] libbpf: Remove sample_period init in perf_buffer
Date: Tue, 17 Jun 2025 17:18:48 +0200
Message-ID: <20250617152500.419276128@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit 64821d25f05ac468d435e61669ae745ce5a633ea ]

It seems that sample_period is not used in perf buffer. Actually, only
wakeup_events are meaningful to enable events aggregation for wakeup notification.
Remove sample_period setting code to avoid confusion.

Fixes: fb84b8224655 ("libbpf: add perf buffer API")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/bpf/20250423163901.2983689-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 087bb8daa46b5..2bc0e3bfdd491 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13351,7 +13351,6 @@ struct perf_buffer *perf_buffer__new(int map_fd, size_t page_cnt,
 	attr.config = PERF_COUNT_SW_BPF_OUTPUT;
 	attr.type = PERF_TYPE_SOFTWARE;
 	attr.sample_type = PERF_SAMPLE_RAW;
-	attr.sample_period = sample_period;
 	attr.wakeup_events = sample_period;
 
 	p.attr = &attr;
-- 
2.39.5



