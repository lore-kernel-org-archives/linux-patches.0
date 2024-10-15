Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23691A76DA;
	Tue, 15 Oct 2024 11:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992785; cv=none; b=LYv1it4bqmANK45sfqPHiSIgmt/11/Mw1P8KsfHyT2GTKly6SV++ZbStiXRNvI0/pUFJd4n4LIRaOpRX5Tp+gSjKZgjHcEUqnU3tVAZBJnjUeAsvZNfpZjttGAQlSr906fSxaX1ajP60vky8/CGi+BHLVyeRTygi3ePKZt2U48Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992785; c=relaxed/simple;
	bh=Er5lDbBlPVTnsFUTkOudc6GWEUi0wXOC57wj6z30mXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN9LwDj848fZ+/HtSYzVK4P5/3TgbG45eMbh1A/fL+T/xRLWdnreTs21a+1TUEzBEnlD7gLIgjyh7qCoY1wEQKqzBKotYJ9f7aUmIbwsqBAyAGjleZDwoKyRdA00TgZ3vyJk8n+oIHcFzHl/sEKhCI2wQP5wzomrXW2biLvuupo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+xIJ69Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+xIJ69Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7EBC4CEC6;
	Tue, 15 Oct 2024 11:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992784;
	bh=Er5lDbBlPVTnsFUTkOudc6GWEUi0wXOC57wj6z30mXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+xIJ69Q57Oyp4Y+yePbxV7r+mgd0c/7zcn6T0s6iMhfwabMh/C18EPIyifudUtm4
	 U5q+hmfNljNz+qmqRGJL9egl02jxMO78zABzVIilxFSvOPrPFl81x81SP4bNo+MKpt
	 1xKsrVcRdxXldWqb4NjGcww++IgiaBhZ9AmqRCkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Yang <sherry.yang@oracle.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 186/691] drm/msm: fix %s null argument error
Date: Tue, 15 Oct 2024 13:22:14 +0200
Message-ID: <20241015112447.741494266@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Sherry Yang <sherry.yang@oracle.com>

[ Upstream commit 25b85075150fe8adddb096db8a4b950353045ee1 ]

The following build error was triggered because of NULL string argument:

BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c: In function 'mdp5_smp_dump':
BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c:352:51: error: '%s' directive argument is null [-Werror=format-overflow=]
BUILDSTDERR:   352 |                         drm_printf(p, "%s:%d\t%d\t%s\n",
BUILDSTDERR:       |                                                   ^~
BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c:352:51: error: '%s' directive argument is null [-Werror=format-overflow=]

This happens from the commit a61ddb4393ad ("drm: enable (most) W=1
warnings by default across the subsystem"). Using "(null)" instead
to fix it.

Fixes: bc5289eed481 ("drm/msm/mdp5: add debugfs to show smp block status")
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/611071/
Link: https://lore.kernel.org/r/20240827165337.1075904-1-sherry.yang@oracle.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
index d7fa2c49e7410..45820ac1a5254 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
@@ -356,7 +356,7 @@ void mdp5_smp_dump(struct mdp5_smp *smp, struct drm_printer *p)
 
 			drm_printf(p, "%s:%d\t%d\t%s\n",
 				pipe2name(pipe), j, inuse,
-				plane ? plane->name : NULL);
+				plane ? plane->name : "(null)");
 
 			total += inuse;
 		}
-- 
2.43.0



