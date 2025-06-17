Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F66C2F234A;
	Tue, 17 Jun 2025 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176245; cv=none; b=k/JW6+AEFxtdlk7F4N8CprwH4/Q6hkDAyqGwQxuYUWWhBjC41LA4hbJbcb9elMsa2aAQznSa84tL8BBDC7YlJcgJSpepfB7pAZQVCS0/qvloXkRjHnyxSYuN81/esF6CGBI8oWk+c6yo3b+2CGeq+3oauBK8VU0Llg8bxXnqeRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176245; c=relaxed/simple;
	bh=jjv3Kwy8HFZvGavRZ2koC0XTyoyLmLfYfCupnPMvFxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0im/ey6Bp62LMtSAU+QfJcV+ctvFUB6QmmeqY6exz1jXL2IlvG0eLREfyn1RC2ggrzu4bGpKVeBtoL2smKU8hQH29Xm1cq6aC0HoasdQKki509DmuhiebISkOBfNVAJsVFMAQLPYl1EHIsDUPgCkNld/UOUUjxXnPFGR4pRgYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2xF5Z+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2xF5Z+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D011C4CEE3;
	Tue, 17 Jun 2025 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176245;
	bh=jjv3Kwy8HFZvGavRZ2koC0XTyoyLmLfYfCupnPMvFxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2xF5Z+w9DqlDw7RRmvm+q9xKdhk0/m4M4EhTqjo006+dWQd/MiS6dnsOTijboawf
	 UMTHFlapSEd92mQxVjEOzZiDb0N3ec0magHjv3P/is53jhhMbSTmW0qsRpbc1jGlOt
	 7YZTR0nKW6vMyc8t/i3mGdLs5HpVGPSg55Mrjkaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 168/780] bpf: Check link_create.flags parameter for multi_kprobe
Date: Tue, 17 Jun 2025 17:17:56 +0200
Message-ID: <20250617152458.324640304@linuxfoundation.org>
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

[ Upstream commit 243911982aa9faf4361aa952f879331ad66933fe ]

The link_create.flags are currently not used for multi-kprobes, so return
-EINVAL if it is set, same as for other attach APIs.

We allow target_fd, on the other hand, to have an arbitrary value for
multi-kprobe, as there are existing users (libbpf) relying on this.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250407035752.1108927-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 187dc37d61d4a..ec19942321e6d 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2987,6 +2987,9 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (sizeof(u64) != sizeof(void *))
 		return -EOPNOTSUPP;
 
+	if (attr->link_create.flags)
+		return -EINVAL;
+
 	if (!is_kprobe_multi(prog))
 		return -EINVAL;
 
-- 
2.39.5



