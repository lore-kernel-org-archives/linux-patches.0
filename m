Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BE78837;
	Mon, 28 Oct 2024 06:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097947; cv=none; b=ujvMnEo7HgybHPnuVcbfWE/oqX9+f9rQ6cJj4/x7dFARdrScwJR4OS7a0f9ZhGjBdQo7T88zH8nu5+cUVJc77Rm1jpGXcrnUvfz/Am0H6UhkCXxFM4NvPYwzZkfcjviZbl1TWsZC58tzR5l/rGIJdfjYh0PaV0bw83XsX+5om5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097947; c=relaxed/simple;
	bh=xCvXVMBe6TJ73MzvO1KzqQjneeRshPbvVL9WbOwZdSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZu73iwCqRtB0aAqmnowasnHFRDYmx43cjH3fRBRQ0yBRfpe1uWu3AE37HJSGCEUS+hybq+5rOWS0KOQn1xI83k5sSNooInHuYzmB4n9Xguit4qnaJLIdlvmXKoM5Ghbui+JNjj2Kn2SaefiwZBjz1xWlSHo3v+YyzdBFGED1H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bv3nOdZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bv3nOdZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D1CC4CEC3;
	Mon, 28 Oct 2024 06:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097947;
	bh=xCvXVMBe6TJ73MzvO1KzqQjneeRshPbvVL9WbOwZdSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bv3nOdZGBHfHEXKs/PA80hIgerOTFbD5LsIKBuXOHQDjwwddhdpQ3pdBkTGr1USW/
	 sQNDkmZtBRGLe2kP9SZ8XPKkvAGqCppBXhWOyNxdupOgL5V3rnaPAp8fxecYWBDleB
	 0RQfkOjjs3eH2GPamAGZ3Z967HH672eu5Ewl3DD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 010/261] bpf: Fix memory leak in bpf_core_apply
Date: Mon, 28 Oct 2024 07:22:32 +0100
Message-ID: <20241028062312.269223743@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 7783b16b87cfe..9b068afd17953 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -8905,6 +8905,7 @@ int bpf_core_apply(struct bpf_core_ctx *ctx, const struct bpf_core_relo *relo,
 	if (!type) {
 		bpf_log(ctx->log, "relo #%u: bad type id %u\n",
 			relo_idx, relo->type_id);
+		kfree(specs);
 		return -EINVAL;
 	}
 
-- 
2.43.0



