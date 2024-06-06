Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7CF198853;
	Thu,  6 Jun 2024 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683043; cv=none; b=T1ePRzb/eLdzhHXQFYVZQQwSHJ2OWytHdKTjd8xzHFL5AMI1bCCq65Cbh84374LBgwXnpB25vo1KfKuHXUWRGvA8lIjjdhngBdUDCLc2E3OtLacV3XIA/my3hHHGPs3zoPeFosSQFprMIKEjmIr7AaNNqBwj1j9CkZVmgqrx4lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683043; c=relaxed/simple;
	bh=eq62H+9RG7/QYlcemx6aFpgdIxOjEHvpkm6A4faUdz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBP4ebjTNBAiSS6whkQV34qPRs8H908W2a+sDRPEq6R7w9AwbsgzKbEqnFrRwtXilh50YkX52mlbz46ggEIT8fkFKO/oFqiI2I38UNivnY8qm1DLfH/N277C3fC3pZupCc8ToxY32FtUdHUPDF6U1fzTPGn+x/WSmNeRD1/7H74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kbi4uvvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kbi4uvvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274A6C2BD10;
	Thu,  6 Jun 2024 14:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683043;
	bh=eq62H+9RG7/QYlcemx6aFpgdIxOjEHvpkm6A4faUdz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbi4uvvWxsECwS15et8LDPhN9qwB93EgRx8F7Qod64ZcbvvhYrrWQkM4/ETuoPEdv
	 2DON2zf6It5w13+WfnNbLYCdlx1Qc9eAOS87Tp/IYJ5CAF1aSbwIUpY/mivPx6qqoa
	 U9KZqDu+zBT037hD8mYcf6djvXxV81q3zHifonNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 280/374] tracing/probes: fix error check in parse_btf_field()
Date: Thu,  6 Jun 2024 16:04:19 +0200
Message-ID: <20240606131701.279772484@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 42bc0f3622263..1a7e7cf944938 100644
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



