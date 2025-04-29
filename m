Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C427E21ADC7;
	Tue, 29 Apr 2025 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947200; cv=none; b=p9HHF9xfQx3tiiNTPw1sgRSIkYdtvk0/2H0XDuR16d+umVM0R4bubBxDT5rXVQ0oemgR1PemFjgVFGDzzSD2fOgFKNQ0jRRvq0nEOnZjv/XzYiEjYjAAA958xp25/EMvlw8pB0N0jnWurLXFGdq8n8hIklDGZUp7Ww4gyeUQbYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947200; c=relaxed/simple;
	bh=kfh85hfAbChhk57YnAuxT+YHa14lP4e1UxBMeWxV1v4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5GzrU+tlsw2hxY9XNJJmjH37vU0JvlQeaZdbguytnifnnSaHU/QpO3jq6So8yI4jGYbSp5qE4U0HP3IYYKImBpHAWu+KNr+du6bLw/ncXPvuHZPGrvQCXDKfkPHhCfA8m5+eV5V0jONweKGyygLgSA3El61BozwzO9ZF2Jy2CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzTAEICB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzTAEICB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4979C4CEE3;
	Tue, 29 Apr 2025 17:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947200;
	bh=kfh85hfAbChhk57YnAuxT+YHa14lP4e1UxBMeWxV1v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzTAEICBNHChlyxkuzbzALuuWEW4P29e9QGZObYbaICjGd/DDXhe6OMprHjYWH8Kr
	 yryrQiscQgPmCgxvd44VxF2wNCv7iOJ2T4jPbo6Bc+FWce/7tCSG13Njo6mbmiJi3J
	 R2mC9IHggPsrIT1+VMFV6COCzK2r7QK5GdMd9XnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/286] media: venus: pm_helpers: Check instance state when calculate instance frequency
Date: Tue, 29 Apr 2025 18:41:49 +0200
Message-ID: <20250429161116.390281895@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit d33a94412ed1081f30d904cab54faea7c7b839fc ]

Skip calculating instance frequency if it is not in running state.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 9edaaa8e3e15 ("media: venus: hfi_parser: refactor hfi packet parsing logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index fd55352d743ee..12c5811fefdf9 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -937,6 +937,9 @@ static unsigned long calculate_inst_freq(struct venus_inst *inst,
 
 	mbs_per_sec = load_per_instance(inst) / fps;
 
+	if (inst->state != INST_START)
+		return 0;
+
 	vpp_freq = mbs_per_sec * inst->clk_data.codec_freq_data->vpp_freq;
 	/* 21 / 20 is overhead factor */
 	vpp_freq += vpp_freq / 20;
-- 
2.39.5



