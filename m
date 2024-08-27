Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23731C4EEA;
	Tue, 27 Aug 2024 15:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772266; cv=none; b=oVYg1l4a3GzORUf55Ff61egj+9E21RwT55iqr2SZ6DswEAUsGSzJ75PMZcsy1CQ99MW079QDSRUyqTsCBZehbdjTs+hIu0/3h8g8wg/P/XTHJVmKPIuyQDcj2YdEQwYmMnVy1P9DsaRte0tL45mznaTBLjpqyDjsFB3RWNMQxVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772266; c=relaxed/simple;
	bh=wvy20Qel9c8csIb2Q0KDoV1h6aGZhCUwugHOVAG8cfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeY9MywPCr/qqfC8lrUaBI9CCAJHo46lw8f8SX/ylO3IRkbBr0MhjdZTow7L6BAP9mOU1bqfXYnrsY3gVb0hW5MWuCKRSyJaW0oRI3hjzdYfq47Z0Yg5pHgPC9QewGp4RHysj7eJyjm5bK+JV2EoX5ANh8rM25Je8GUR/XFqoP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aqY8EvN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aqY8EvN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B3FC61071;
	Tue, 27 Aug 2024 15:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772264;
	bh=wvy20Qel9c8csIb2Q0KDoV1h6aGZhCUwugHOVAG8cfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aqY8EvN1QK/FKACcbYtMAqSyJmJWVlowaFm64LELWw51ghMww6+x9L6nEaPodpwaN
	 aoIz8hcVjklp838/X4wvQS5j+2K/jVk+FKyjWi0MUvbnD+XUG50kKV2bqZ5QQafF1c
	 s7V3TmgNhb+brS0fV1H9Hxlnuq2KnquG+Web+rb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/321] media: qcom: venus: fix incorrect return value
Date: Tue, 27 Aug 2024 16:37:23 +0200
Message-ID: <20240827143843.382942835@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 51b74c09ac8c5862007fc2bf0d465529d06dd446 ]

'pd' can be NULL, and in that case it shouldn't be passed to
PTR_ERR. Fixes a smatch warning:

drivers/media/platform/qcom/venus/pm_helpers.c:873 vcodec_domains_get() warn: passing zero to 'PTR_ERR'

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/pm_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/pm_helpers.c b/drivers/media/platform/qcom/venus/pm_helpers.c
index 48c9084bb4dba..a1b127caa90a7 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -870,7 +870,7 @@ static int vcodec_domains_get(struct venus_core *core)
 		pd = dev_pm_domain_attach_by_name(dev,
 						  res->vcodec_pmdomains[i]);
 		if (IS_ERR_OR_NULL(pd))
-			return PTR_ERR(pd) ? : -ENODATA;
+			return pd ? PTR_ERR(pd) : -ENODATA;
 		core->pmdomains[i] = pd;
 	}
 
-- 
2.43.0



