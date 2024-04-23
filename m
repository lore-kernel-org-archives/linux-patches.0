Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A715014B071;
	Tue, 23 Apr 2024 21:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908786; cv=none; b=CrBCG4cIJ63yu56kaZjR4q63wAFzGoRx0Gdl5YOh1MWvJ7VqRUNyGyjq6h63bgWfy3ozVhd/OYpn2z0yGvXyz1aNbmgxsFKymllfa9cvR2WxlUYJ8mZsUru0lIWm8lsdNh5SnAvNi0aKqBIgEpNv2ho68EJu3OwU6ufNalQG6Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908786; c=relaxed/simple;
	bh=vGbxujm043WFiC+owW2JSvg8dVgiQZzc/V8KjndEwX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+RTqkZrHk0pbMmrhl+2YYREYupLIiWLVWzbso2KLLLSdvdJmVCmkT3E7bakPR80dltfy07dUejQE1vbb414RrLgejBomix/OAfMhBaFSpdNiDP27oCFHhTC32y45NN/MYpTIsJGbmjufXMaYsbsudoWO/VNx1LygHL5jPC0sWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZKJQvE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZKJQvE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEF8C32781;
	Tue, 23 Apr 2024 21:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908786;
	bh=vGbxujm043WFiC+owW2JSvg8dVgiQZzc/V8KjndEwX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZKJQvE9+M2May/uFX6O+N4tKFZieBPnqZG5Ril77NZykBYgGtjq05qhkjbulRW/m
	 CVcHS5s5j2LSBKzHXlOxEMpYsb3Wb3tdg1JNGPNhNVFf3ArS4VoXwwyov3loUwkR4D
	 GlvTcCqH9AGyaGEroVsdV7xSJwHyCMwWTYqH6oUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/71] clk: Print an info line before disabling unused clocks
Date: Tue, 23 Apr 2024 14:39:50 -0700
Message-ID: <20240423213845.429732520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 12ca59b91d04df32e41be5a52f0cabba912c11de ]

Currently, the regulator framework informs us before calling into
their unused cleanup paths, which eases at least some debugging. The
same could be beneficial for clocks, so that random shutdowns shortly
after most initcalls are done can be less of a guess.

Add a pr_info before disabling unused clocks to do so.

Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230307132928.3887737-1-konrad.dybcio@linaro.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 52877fb06e181..de1235d7b659a 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1330,6 +1330,8 @@ static int __init clk_disable_unused(void)
 		return 0;
 	}
 
+	pr_info("clk: Disabling unused clocks\n");
+
 	clk_prepare_lock();
 
 	hlist_for_each_entry(core, &clk_root_list, child_node)
-- 
2.43.0



