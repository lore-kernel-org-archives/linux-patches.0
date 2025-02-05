Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FE71519AA;
	Wed,  5 Feb 2025 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764578; cv=none; b=eYztnWbsTMrpMhF8LbXul6beDtGcWj1WksHpfArRi0lJLLq0fmphWzRbQTDGSxsKiS0YC0JH+nuaqWm+RtyGwEex7o44WQBAGDYi0CKvqcXlJvipMWSDxizUKbtJlmBpud8J+Nabs+bLxjRuWhOTkvPBNBgu63GayVBF9u0CS+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764578; c=relaxed/simple;
	bh=IOj4mtUSvrjRVZC6hO5gS3bN1wlpPNI6EXBXCG4TVSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwY16BGFWqS4BFEi2+7Ya+yqKK/r8xm5LNYYmLmMebz5qZgVDNwlbS6uc4162hPeaVtPuMz0AY1eLQkrS1HVDsp8ax8A994zaCWEtEeUOdzkQxqiF2I/KKNZ6b6c4MgwiQcY5VXolgf1Zo4/rRtxRtIXy8Etlp3bfcSlfbMqQ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uv+0Pxh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uv+0Pxh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B64C4CED1;
	Wed,  5 Feb 2025 14:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764578;
	bh=IOj4mtUSvrjRVZC6hO5gS3bN1wlpPNI6EXBXCG4TVSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uv+0Pxh20koWv3JYTXmplECh1D8zN0uPLFMsikcDT9phAek2yjt8wJ1wZEobhTAJF
	 kwIRY6koWcKYFDP+9sDJpalfwN7SCdNu446ytq3gYQxIymu1l0KUKSmtKUPUW4FZuy
	 pcrm1dsC6GWMhj+X4OVohcJCwMLA2GTARE6efr6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 092/623] clk: renesas: cpg-mssr: Fix soc node handling in cpg_mssr_reserved_init()
Date: Wed,  5 Feb 2025 14:37:14 +0100
Message-ID: <20250205134459.746045493@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit a6ca7e6240f0651412da6a17d0e7a8f66d3455a6 ]

A device_node reference obtained via of_find_node_by_path() requires
explicit calls to of_node_put() after it is no longer required to avoid
leaking the resource.

Instead of adding the missing calls to of_node_put() in all execution
paths, use the cleanup attribute for 'soc' by means of the __free()
macro, which automatically calls of_node_put() when the variable goes
out of scope.

Fixes: 6aa175476490 ("clk: renesas: cpg-mssr: Ignore all clocks assigned to non-Linux system")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20241031-clk-renesas-cpg-mssr-cleanup-v2-1-0010936d1154@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 79e7a90c3b1be..bf85501709f03 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -979,7 +979,7 @@ static void __init cpg_mssr_reserved_exit(struct cpg_mssr_priv *priv)
 static int __init cpg_mssr_reserved_init(struct cpg_mssr_priv *priv,
 					 const struct cpg_mssr_info *info)
 {
-	struct device_node *soc = of_find_node_by_path("/soc");
+	struct device_node *soc __free(device_node) = of_find_node_by_path("/soc");
 	struct device_node *node;
 	uint32_t args[MAX_PHANDLE_ARGS];
 	unsigned int *ids = NULL;
-- 
2.39.5



