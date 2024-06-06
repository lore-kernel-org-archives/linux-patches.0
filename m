Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B73E1C95C9;
	Thu,  6 Jun 2024 14:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683724; cv=none; b=ZdvQ5ZuqhAhsISF0UXVzimk6LbQA9yqfuNYCymYwhUZyAv7oUKjt+8YDsP7A5Hsa0qvvubHHJhLTQ6AD28XZSTgkM60ekhNA8qokT8wpdkt2YsDy4AMxx8zHyMVjAjk3xVozKSK3LwS8wc72jegzebon+I1tGz7xXmQiLCJbab4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683724; c=relaxed/simple;
	bh=bQJGvtGm8PqrZPAhWjdwvTXJZ6fVmERq3IEo13q/J5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLz+O1g0pMH08ZX12MpVVGpazMRUseVGv28qlPl9aA+Hd0Dm8UeBMWhUzonADFyzxyfokx9VgQHEC57PYebZR4rZrRWqA9uPYyxqoV9F78bYfTGzMyQVv7KLz5scJB+li26Vd1fbwbVYnaEtKvpgXP/fOjzYVCEGishG+g1mw08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qRrqBBpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qRrqBBpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B476C32781;
	Thu,  6 Jun 2024 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683724;
	bh=bQJGvtGm8PqrZPAhWjdwvTXJZ6fVmERq3IEo13q/J5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRrqBBpqOu/GlTGoBo53jaFENnlbvKax6MC1GtYzlSnSDcolXq2l82L32ypb97xyL
	 WotAg9g1aH6o0ycDoq3dp4mqVCVEmSZdb5x1lzkA64WIN+Smg+FVN13dPn6Ir1w7QA
	 SBkgJruqq7Mu69z8+1GxLo8TutFaxUIO2/hB+JrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 670/744] tracing/probes: fix error check in parse_btf_field()
Date: Thu,  6 Jun 2024 16:05:42 +0200
Message-ID: <20240606131753.971752098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos López <clopez@suse.de>

[ Upstream commit e569eb34970281438e2b48a3ef11c87459fcfbcb ]

btf_find_struct_member() might return NULL or an error via the
ERR_PTR() macro. However, its caller in parse_btf_field() only checks
for the NULL condition. Fix this by using IS_ERR() and returning the
error up the stack.

Link: https://lore.kernel.org/all/20240527094351.15687-1-clopez@suse.de/

Fixes: c440adfbe3025 ("tracing/probes: Support BTF based data structure field access")
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 34289f9c67076..ae162ba36a480 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -553,6 +553,10 @@ static int parse_btf_field(char *fieldname, const struct btf_type *type,
 			anon_offs = 0;
 			field = btf_find_struct_member(ctx->btf, type, fieldname,
 						       &anon_offs);
+			if (IS_ERR(field)) {
+				trace_probe_log_err(ctx->offset, BAD_BTF_TID);
+				return PTR_ERR(field);
+			}
 			if (!field) {
 				trace_probe_log_err(ctx->offset, NO_BTF_FIELD);
 				return -ENOENT;
-- 
2.43.0



