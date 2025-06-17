Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CBE2E9730;
	Tue, 17 Jun 2025 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174646; cv=none; b=kPpjdOegzMNrAP9LK+Y+sQ+/dxKRLzlyETJwtaYF/FDxiLTkKYVO6I0FzLLDMEYt9Alj5B6forsaI5j/l7SNllH96ODrTVir56qwEv+CvlBjdf6n1Kgupipl1NjMFam4JK7m/kpvxK7sqyaQq6/m3BT+MTwW+7ZHbh/vp/eBWM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174646; c=relaxed/simple;
	bh=WlbSV8j9fwu9Oumj2sEACHVxftyb72CDMsmKmdHuhDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4tLA1faLDhVwl4KMy12ie/W4X3fIRhN/kuFL140Pbzeki5W8RDe61k+eDiMSHLXSNFl5w24BH4vXnRLIX67SxHaH9IdNbZF+nRS/YdGeSOAv/9OyGqW2RjcONZIPYM4vM4DkMoIkKHDKPEEAeRnzo8adEuwqodKYheO5nITq/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXd725I2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXd725I2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F313BC4CEF2;
	Tue, 17 Jun 2025 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174646;
	bh=WlbSV8j9fwu9Oumj2sEACHVxftyb72CDMsmKmdHuhDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXd725I2jaxBvf2BXkVV2Y9/xaKk/6ZOFFRbA1QWOJB1HCk/a/VmpSj3XWsjQmfA6
	 1fFWgIKL7e79ArTM5o+ibyu6NPuwleqLpmgyFRCqh3HQKevcRT3gN2X71HyZSIG8vS
	 dw2GH0EHYECB03yFPKZcucyUL8QAgG+/b6//voVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/356] libbpf: Remove sample_period init in perf_buffer
Date: Tue, 17 Jun 2025 17:23:33 +0200
Message-ID: <20250617152342.170817377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ca764ed3aaa91..18e96375dc319 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -12453,7 +12453,6 @@ struct perf_buffer *perf_buffer__new(int map_fd, size_t page_cnt,
 	attr.config = PERF_COUNT_SW_BPF_OUTPUT;
 	attr.type = PERF_TYPE_SOFTWARE;
 	attr.sample_type = PERF_SAMPLE_RAW;
-	attr.sample_period = sample_period;
 	attr.wakeup_events = sample_period;
 
 	p.attr = &attr;
-- 
2.39.5



