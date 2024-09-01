Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE831E87B;
	Sun,  1 Sep 2024 17:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210000; cv=none; b=s3if/lB11rfr+ctFcbaiOM5U4nKNnikUzPzIRMSBm2vLrKLnlI0k3oVW2wn51wu1EJgzegdn2KQJwxC4HoJHSN4bRFOAb0fOUh1bwB4wBq/EljvpNu3cBQ2l80sLzkJCPnlmwJYwqhsLDOQM1D3akDXitkie1JGk03nOgoahUto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210000; c=relaxed/simple;
	bh=7Yu82DZHBo1kEwrpUt35GMDLjItBBahCm+WTREaDzEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q92h7nDG+WKubHWOKvORzAobEeYZSWuAdwn69OM/S0iYjlstQHI7EWx6nNHhlNbJ0/55CtJCgs5tG8IbGIqvw+Ogu1cIVugAZB+6BhsPrFBAUOwTmeWd/aPhR4altZTIKnmFxx8Miq95cljODa4ZpZJFlsFmBp/4+AXQ+RQLVQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/4ugMCl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/4ugMCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2234BC4CEC3;
	Sun,  1 Sep 2024 16:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210000;
	bh=7Yu82DZHBo1kEwrpUt35GMDLjItBBahCm+WTREaDzEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K/4ugMCl2ctR1GeAFf49u7yU4fQn2rIen56zKOQulAK2VSHm+TXjUuISi/K7y0npH
	 Jj43H9OdnihNbOXYfdfas9uSHLqUVT4uNM/KPSnc+HZWUoNWtiBwTabGpgQ8KADlmm
	 keXkAwKsMcW4hAsT/2+I03DO1OJaqEJanaSsnOKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/215] media: qcom: venus: fix incorrect return value
Date: Sun,  1 Sep 2024 18:16:09 +0200
Message-ID: <20240901160825.506300339@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index 055513a7301f1..656c17986c1c3 100644
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



