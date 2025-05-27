Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0661D63EF;
	Tue, 27 May 2025 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364404; cv=none; b=ZWJDe3urXOObFE8GGPq8cNNgMfxRdEC7jrZCVwe/pLghT+dKP/Qw5jrk+TH9psLLQPui/4wfENm+up8YKSC9XS4UP5Z1V5PA7Fh8hN6+LWeFMbebqq87jyg7XTRl6jfo8LawiIvcUxmGNx1fSQGQhTfdcTD53disJ92j/S/Tdc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364404; c=relaxed/simple;
	bh=TWWdo0GmASUFO7I09e8IjLqiMo/OA6ihWg2Qgbblv8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyriurWIqY5sd7vkDrylXJdz2PMUcMJOqnviSv15OjOCtLhtLHMLYHyIPIX42SDwcRgf+zA64CswUG1ltbqV1xIU7G5DcQmbHG285OaeXGUV2n+kBQdS2JEIeCPSLbIVzYGxTUYYN0Fa/l1/ssUaE1o+FkrPK1U4TAPWah3HuIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csLrCG14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csLrCG14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABBAC4CEE9;
	Tue, 27 May 2025 16:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364403;
	bh=TWWdo0GmASUFO7I09e8IjLqiMo/OA6ihWg2Qgbblv8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csLrCG14JDA/7aN7U1sN8NBQXxCX3UZmwMlt99GKgNTK3SCCzujs/tMWXek4KAYuE
	 rIqoM3WPDQAtD1L3QQWIgkgorYpmf9RpIyPw9ZezuRE1OyEwky4R+JDp8GJFV/UA+J
	 4U2+YSUKliSFE4uP6kuig/Lpt7uZXVPA3+c8zKJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/626] nvmem: core: verify cells raw_len
Date: Tue, 27 May 2025 18:18:27 +0200
Message-ID: <20250527162445.638865621@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 13bcd440f2ff38cd7e42a179c223d4b833158b33 ]

Check that the NVMEM cell's raw_len is a aligned to word_size. Otherwise
Otherwise drivers might face incomplete read while accessing the last
part of the NVMEM cell.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250411112251.68002-10-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 8af2a569c23aa..3671d156c7c33 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -592,6 +592,18 @@ static int nvmem_cell_info_to_nvmem_cell_entry_nodup(struct nvmem_device *nvmem,
 		return -EINVAL;
 	}
 
+	if (!IS_ALIGNED(cell->raw_len, nvmem->word_size)) {
+		dev_err(&nvmem->dev,
+			"cell %s raw len %zd unaligned to nvmem word size %d\n",
+			cell->name ?: "<unknown>", cell->raw_len,
+			nvmem->word_size);
+
+		if (info->raw_len)
+			return -EINVAL;
+
+		cell->raw_len = ALIGN(cell->raw_len, nvmem->word_size);
+	}
+
 	return 0;
 }
 
-- 
2.39.5



