Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6487D2DF3C9;
	Tue, 17 Jun 2025 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174656; cv=none; b=F1KjtV3pe7z3ONNxAp1OO7/PFvZncrU8bGYQo6opcbl6CbxZaydlZE/8AHdjcKFmaKeKYn5x3fuZoUJhQgDvY73dTkwo1p4sW6Vs+udHkzKOsUUVe0nYjy7UoAW83mup20ai+UOkWISW+07AanFI1alopULyiW2DCCDDPzgcW7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174656; c=relaxed/simple;
	bh=JypuzBis73hv2S0zz4bsC4aywDqJOnJUn41Jn552veo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igf7WlM0xmSRvxLiqJtUoupSbs8HNecGmkirVXP18Iua5mSDJ3pWiObXcBO0qQ+f7QOaDgh/THiC1OElprdpFagHZYEvBP2U1TcrowojryJHDex2KAORH8aknioXQAJTbJcs5svIAZ0gL8Bfk58DLWHP+PkPQY2UWOGMpXlxCeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=erItK4tJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="erItK4tJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E69C4CEF0;
	Tue, 17 Jun 2025 15:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174656;
	bh=JypuzBis73hv2S0zz4bsC4aywDqJOnJUn41Jn552veo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erItK4tJJspralb6SGsNSMdH/6NLjukmr4jG2jLcARWWb+WlnFBRsaDO5jQ8Lu8e/
	 2IdRzSGHOfNJXvstZ6ODxmQs3GzG1oX7hiji7GrIHvdq2TIJUuCLIXSLsY9T8wvwtr
	 mdQzSiv48HbjTeFJ9HYXGQ6WQHlQGRJUFpmqDYSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Wiepert <jonathan.wiepert@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/356] Use thread-safe function pointer in libbpf_print
Date: Tue, 17 Jun 2025 17:23:34 +0200
Message-ID: <20250617152342.210098182@linuxfoundation.org>
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

From: Jonathan Wiepert <jonathan.wiepert@gmail.com>

[ Upstream commit 91dbac4076537b464639953c055c460d2bdfc7ea ]

This patch fixes a thread safety bug where libbpf_print uses the
global variable storing the print function pointer rather than the local
variable that had the print function set via __atomic_load_n.

Fixes: f1cb927cdb62 ("libbpf: Ensure print callback usage is thread-safe")
Signed-off-by: Jonathan Wiepert <jonathan.wiepert@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
Link: https://lore.kernel.org/bpf/20250424221457.793068-1-jonathan.wiepert@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 18e96375dc319..5dc2e55553358 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -246,7 +246,7 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 	old_errno = errno;
 
 	va_start(args, format);
-	__libbpf_pr(level, format, args);
+	print_fn(level, format, args);
 	va_end(args);
 
 	errno = old_errno;
-- 
2.39.5



