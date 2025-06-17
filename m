Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDE32EF2AB;
	Tue, 17 Jun 2025 15:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175639; cv=none; b=qdCbz+4/x04SsvKiJcvX1KUj2sPITafHOhsHZVINzLTCPC1NEEyTqnlNHIblv5dWRYzyR3assFTcRY+4aKpCnxihYdMDDaAVcL3ox8/qLefQpqgrCE69MRzOj+iznbrWqnsbh3bW7GSTgd+442uTmbKQeNQ9Ls+BApOGFTjrz0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175639; c=relaxed/simple;
	bh=Xzfu3MgCMkphIcR18fX8YWU6A8wrUx8DUT0/v5pc9iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYZrm1k/dY8a+4GpOH7z8YzYtIJL5vROmVLVh379YpSYCNVyL9/u2XEk77jHS7o9C4zMwq3cg2KuZ9IpYDd+05L8rUS+6SUvFpC2b1C3EgzmPWABW+x91UU7kZplbtjkPFpjYyImDD0Z0QrmFnrlPJgmwHhJPxDbbraRTrflgHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbAd4a2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbAd4a2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03A2C4CEF1;
	Tue, 17 Jun 2025 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175639;
	bh=Xzfu3MgCMkphIcR18fX8YWU6A8wrUx8DUT0/v5pc9iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbAd4a2aVcfNUKByG5cQpZdP3sTv1/ZGx7NkGhiqTqQviooVDrlSMkCVlym6nos4/
	 dsKJnYvhSWOVKdcNL3w79cvGfqEu40gAPnHDZKTNPu5C7Avp7Ho7wn2lNdUJeeFU5K
	 EnKUA5PK4P7m3c8bXmlpPSO8kpcSqBDLhzkWHnVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/512] libbpf: Remove sample_period init in perf_buffer
Date: Tue, 17 Jun 2025 17:21:43 +0200
Message-ID: <20250617152425.151823346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 976fabd5d4dbc..c6eceae4d6ff6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13245,7 +13245,6 @@ struct perf_buffer *perf_buffer__new(int map_fd, size_t page_cnt,
 	attr.config = PERF_COUNT_SW_BPF_OUTPUT;
 	attr.type = PERF_TYPE_SOFTWARE;
 	attr.sample_type = PERF_SAMPLE_RAW;
-	attr.sample_period = sample_period;
 	attr.wakeup_events = sample_period;
 
 	p.attr = &attr;
-- 
2.39.5



