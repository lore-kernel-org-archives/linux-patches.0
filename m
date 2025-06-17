Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364352DF3C7;
	Tue, 17 Jun 2025 16:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176255; cv=none; b=l0lwU+ck/LjZMKxACuTVFrdj/U/19cowFKSj+ihOAoyBTsm2QlsobIvq0KsspogDKMpqUaxV67KyNNG0bsLN8ilgwQTN5ubSyBewjc7dKLQ0tjszh3wzgn4Vt5vA5I2hJ3mDCFLFqtSRVvSnSyx2COcSEAc360JvUJpl2ApVbp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176255; c=relaxed/simple;
	bh=Z4GCbQs/YqLdgyqbXvBVkOk0jcUT7wbYHctGPT9cROY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQFlmrFUUn/JNvrcGY95ymzeT8T35ndkxnNAoxwQQKr+IMQL7FrjNN3JLrFa7uDE1xac7xAray8MUIGwNNup8OLIZzY2YZPbpIIzKxBu/spPXEUXzo+2CcXOWAW+albJtW47K+6O8iTEmJbPPrTazF1aXVy+Ar8/VMUKbs1Dqvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IroV9ts/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IroV9ts/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9777AC4CEE3;
	Tue, 17 Jun 2025 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176255;
	bh=Z4GCbQs/YqLdgyqbXvBVkOk0jcUT7wbYHctGPT9cROY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IroV9ts/BH+mozIdfrIQMMMWFjDF1Aad7oMV2RpM9RCMGxuYOwWptgv48QmN2JNsQ
	 pNpRaBpqc0CY7Gy+30YIgDq/fZrEudJozwVW1Nj830/WcKdh1DyEQcng8Oyy5otrpK
	 oMef2iNisjlltcciidOgTN/MAwSbH7WnI5uRqQHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 169/780] bpf: Check link_create.flags parameter for multi_uprobe
Date: Tue, 17 Jun 2025 17:17:57 +0200
Message-ID: <20250617152458.365885967@linuxfoundation.org>
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

[ Upstream commit a76116f422c442ab691b4dcabb25613486d34360 ]

The link_create.flags are currently not used for multi-uprobes, so return
-EINVAL if it is set, same as for other attach APIs.

We allow target_fd to have an arbitrary value for multi-uprobe, though,
as there are existing users (libbpf) relying on this.

Fixes: 89ae89f53d20 ("bpf: Add multi uprobe link")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250407035752.1108927-2-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ec19942321e6d..0f5906f43d7ca 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -3379,6 +3379,9 @@ int bpf_uprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (sizeof(u64) != sizeof(void *))
 		return -EOPNOTSUPP;
 
+	if (attr->link_create.flags)
+		return -EINVAL;
+
 	if (!is_uprobe_multi(prog))
 		return -EINVAL;
 
-- 
2.39.5



