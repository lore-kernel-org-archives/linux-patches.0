Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D06018DF88;
	Mon, 28 Oct 2024 06:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097197; cv=none; b=PbcHmydtTX4o3wYvfAoaBb+JwypE5mx0QyZmUkqilXdyMSgh/iZiQgvogOQ9pMoND+atNspEqXEVbfXaDXG2tD+SaFRzMuWXoxVuD4YZLiVMT1vnZ+8sczLEqAfSFV2mQ0RFyB8y8cIyd081x+fYROvwKEdj0X8ZffN5vSx0chI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097197; c=relaxed/simple;
	bh=6xF4s1XqKSHW8cjxAcnBASc4jLhDFMtNE6ROvqRPy+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dt9H2ipWErsA46nLNtapr5ar1h4WLtC4VLMvC9WFGP9q8X5Hh3sj10uEEErLntr4zGA2+bRyt48LU48dMqx7oxD3uZENsvPGMFmD0iwKS82lchohSW56lzv4X+8aj1F9thmI3tbw2A30cIT2VDveuwHmYfP/pZDoszQ8SPprUPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUmYjdNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUmYjdNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7078C4CEC7;
	Mon, 28 Oct 2024 06:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097197;
	bh=6xF4s1XqKSHW8cjxAcnBASc4jLhDFMtNE6ROvqRPy+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUmYjdNIEYAExU6P0iupoUNR79i88SotfufoO7Mvbktoglg/15sGTIhPRt8te9lIx
	 XtaaplEep4og0f2L2MXyUI3kbtuVIF9VHkl49FfgEnJPUW5MuUxcadi7SlTxAKIN3H
	 HYMGrfKmF6rzWjpYPVjIncYsv/arHrnppBi7BV2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/137] bpf: Fix memory leak in bpf_core_apply
Date: Mon, 28 Oct 2024 07:24:02 +0100
Message-ID: <20241028062258.855911354@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 45126b155e3b5201179cdc038504bf93a8ccd921 ]

We need to free specs properly.

Fixes: 3d2786d65aaa ("bpf: correctly handle malformed BPF_CORE_TYPE_ID_LOCAL relos")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20241007160958.607434-1-jolsa@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8c684a0e1c4bc..9f9996cdb6e2f 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7987,6 +7987,7 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 	if (!type) {
 		bpf_log(ctx->log, "relo #%u: bad type id %u\n",
 			relo_idx, relo->type_id);
+		kfree(specs);
 		return -EINVAL;
 	}
 
-- 
2.43.0



