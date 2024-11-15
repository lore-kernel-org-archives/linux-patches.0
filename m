Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC680189528;
	Fri, 15 Nov 2024 06:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652994; cv=none; b=OhdMiu9wI/2VWs3Qe1Upfr05GqgtMIpuJEdywirY2umt9FV2F5fomylVPXfgbVbCBn2/zeBhyhf/nnrS+5y4oTJwGcIj00DyIzfR6JiMLMj4wSODsD60zLrdS/B/+lNawh9cgoGk2yhQMGgiurRzl1xy5TkcG1vQEVh5gz2HJUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652994; c=relaxed/simple;
	bh=MjEFB7KvfUnppRRJK/5FJ3uH1izvucOa/aYfRlPgOzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKTJbAF/nFLuJkOIQ+2h7ttlZbY8ghR0l+TtAuu2UXnu0P6Ug/ZkznqUqAmCdQ3K2dNjffV7IZ6lqFDO1iwAif85wCNCHxRCzl8ZxJeHho9UlzPMw9FXw1T5YNL1g915TiwWARsXqbMdNUIGI1btodpqNF7mpIi3zVM1M579zhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6Vx6Jkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6Vx6Jkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037B1C4CED0;
	Fri, 15 Nov 2024 06:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652993;
	bh=MjEFB7KvfUnppRRJK/5FJ3uH1izvucOa/aYfRlPgOzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6Vx6JkjAs75Xox48czR4f1FHP2Ikc31nG/1eQEbh50wgbA78UXRTjx/3ZIN3470D
	 AdA1eulq/qGiJI5uGPWkZI9DI4fcqbsHoocDFrQcHiIAzA35f6hPurQZRgZyiQu9wl
	 miCwMcbhzSWDJZEacA5QanTx6SAKX5VstMc6vWuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 23/66] media: v4l2-tpg: prevent the risk of a division by zero
Date: Fri, 15 Nov 2024 07:37:32 +0100
Message-ID: <20241115063723.680549871@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit e6a3ea83fbe15d4818d01804e904cbb0e64e543b upstream.

As reported by Coverity, the logic at tpg_precalculate_line()
blindly rescales the buffer even when scaled_witdh is equal to
zero. If this ever happens, this will cause a division by zero.

Instead, add a WARN_ON_ONCE() to trigger such cases and return
without doing any precalculation.

Fixes: 63881df94d3e ("[media] vivid: add the Test Pattern Generator")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -1789,6 +1789,9 @@ static void tpg_precalculate_line(struct
 	unsigned p;
 	unsigned x;
 
+	if (WARN_ON_ONCE(!tpg->src_width || !tpg->scaled_width))
+		return;
+
 	switch (tpg->pattern) {
 	case TPG_PAT_GREEN:
 		contrast = TPG_COLOR_100_RED;


