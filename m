Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E64D12C476;
	Tue, 30 Apr 2024 11:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474952; cv=none; b=pGvHyqITfCfiaY62nLy0me7AENb4INWNG0VKyS5IIRXzV+au0DmtOyVPFqIApyi0jqS5SJxMHbhb6/GfOsEQ5kaza+xg05NU+uk9SE/lycpd1hLr/jkhe3XSFPlyWDtx1GOq2745pYxqE2/9P6PYWqG9+YCHl2KrhIY0s6UEnBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474952; c=relaxed/simple;
	bh=Xrig/rlZ8EwOCmZ6v1tkdKBUENT6RrT0023WUQDN+bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAYiBjuZ7to0IXox4i1bnpwdFOx0L1cd/yiLE9U6mPnviF02JlE9YVDljNNkpqfWWkgPj8Gr6eXJA+E2qrsL0FruZGN29Mxo6NOPAJZ7XwIoZD9PfXX7aXCVrntRwsjnMxp4Ol++w7PG3lWOdANpg5C/ShkhQiapyf2KbUfh0kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LONaDjr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LONaDjr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FF5C2BBFC;
	Tue, 30 Apr 2024 11:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474952;
	bh=Xrig/rlZ8EwOCmZ6v1tkdKBUENT6RrT0023WUQDN+bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0LONaDjrWynq6Hd8/XcDBAPCc/d/d2JDqbH/hUKqhITwHpbmIiq6Jv0CkQYkjYyYi
	 PAhvATc4hHqS5EVPGQPk7pCdsg67ygTBehrojcsPQ9H7pvcz/SUwC6NJPJ4WlN6el6
	 2GpS9aLOPtJ09hSyGw+7twOK+V6lLuHiYcUl58k0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/138] clk: Print an info line before disabling unused clocks
Date: Tue, 30 Apr 2024 12:38:52 +0200
Message-ID: <20240430103050.813744403@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f6be526005bbe..bcaaadb0fed8d 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1309,6 +1309,8 @@ static int __init clk_disable_unused(void)
 		return 0;
 	}
 
+	pr_info("clk: Disabling unused clocks\n");
+
 	clk_prepare_lock();
 
 	hlist_for_each_entry(core, &clk_root_list, child_node)
-- 
2.43.0



