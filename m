Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1F444C93;
	Sun,  1 Sep 2024 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209455; cv=none; b=HA0XW6NxmsSgloOS4yWepFbGkZrDSSFeE00dDWUfImdOxDNcwBsdLyxPT9qopb7rOJU/28e+SybsgIZoR+cIBzJdu02CmEJGJ+6QT4qRdxInYh5aOOgBRo0i0ycYL0isdb9QkDkGk/7Q0HZ5Y1W9Cb4K1rpzKqDFUenln3HykRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209455; c=relaxed/simple;
	bh=2DcXS82PniV7qp61ns1hzWimT3+8bE/4JqHgD4pl/EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGc/Q954iTegCHhxPqC7vAoLBpgSv4y4d55FDyqcQ4EQTlbHqH+1NLXzJKokNI4IDuvRbObZ9o1HMI1U0eiW2YTXtTzgTlIf4MBMfWG6YL9UwWfq9pqnWM6Y01Nzu1B2xVY/kCH/S7hOQjo+BdbNdLpXrvvKvsAjYUt1PdcH8Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTpv8ipw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTpv8ipw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411BDC4CEC3;
	Sun,  1 Sep 2024 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209455;
	bh=2DcXS82PniV7qp61ns1hzWimT3+8bE/4JqHgD4pl/EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTpv8ipwXmDd2gyxSS7jAXYS7COetajwQ3bV9An7bKeejuEhRlV8DBRJX2aAHwfUi
	 dUf0C4vw/NtH5YEb6GsWwGU1Mlm9P88oiOElQHLW5CFMrii5+ArQSz0e7a/kxW6aAc
	 pYks80SU3LNvZdhU5Ff03Ek3JoODs2GOHnm7RpmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/151] media: qcom: venus: fix incorrect return value
Date: Sun,  1 Sep 2024 18:16:42 +0200
Message-ID: <20240901160815.691237867@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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
index 6bf9c5c319de7..fd55352d743ee 100644
--- a/drivers/media/platform/qcom/venus/pm_helpers.c
+++ b/drivers/media/platform/qcom/venus/pm_helpers.c
@@ -765,7 +765,7 @@ static int vcodec_domains_get(struct venus_core *core)
 		pd = dev_pm_domain_attach_by_name(dev,
 						  res->vcodec_pmdomains[i]);
 		if (IS_ERR_OR_NULL(pd))
-			return PTR_ERR(pd) ? : -ENODATA;
+			return pd ? PTR_ERR(pd) : -ENODATA;
 		core->pmdomains[i] = pd;
 	}
 
-- 
2.43.0



