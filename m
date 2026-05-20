Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683863EFD22;
	Wed, 20 May 2026 16:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296148; cv=none; b=pMQnmpttDTSUuEZ7YU9K1di2l3aiQvGQaYotOP43OMmDJoHrCwXvTaJzHMgyWnB+hQSyZKcR2lhW8qHxqG+jVShyCvAuh4pOCLxXWddNZ/CUGOmEC55uAyxlrsL1fP8swme2JYkYwBfYrNPT8dFcZbpKSqKdFx+gUxu6oHhuYRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296148; c=relaxed/simple;
	bh=Isp3wXgVb1VQA2JEDeI/s8JHc1kVjXW/y2a7/B9vUlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G+e1d4I3iV5MYrMvSLPNDgti+u/S6SFvJ8PxdVoO5xxD6TSjUd3QSFyXVSyT2uJBsmBZUTuN8jQsoHwPMlRwWWZ5hmTcd7eOnzhNxUGEkR4PkY+2foIadOljLs/SJFjGMWhk80MLznorIL5STlPuvvwSaSOm8cC7fUF37A4V9Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WquDUJA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WquDUJA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC191F000E9;
	Wed, 20 May 2026 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296147;
	bh=0s2vxNfkKBJsMiF5bwdIJ3PCqNZ9n88umPtiydvjxO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WquDUJA9OJHmQ1duVTpVFsodA5AdchMMT24/jYlZnqn8ka7bfabL2/s75JgGkMXlk
	 Xp0YhF0nMzQUihcg+dflJm0Lr56E2lKI4Tx3DFD0PN72GYrtyIwNpGkeBZjHbV6AIo
	 j92mKK+hAtSCwmCoiljzInJeEo/OUpQSH4j7c2hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emre Cecanpunar <emreleno@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0687/1146] platform/x86: hp-wmi: avoid cancel_delayed_work_sync from work handler
Date: Wed, 20 May 2026 18:15:37 +0200
Message-ID: <20260520162203.737935159@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emre Cecanpunar <emreleno@gmail.com>

[ Upstream commit 249ddba9c0ba4453c0a6bc0e3626e7864751d940 ]

hp_wmi_apply_fan_settings() uses cancel_delayed_work_sync() to stop
the keep-alive timer in AUTO mode. However, since
hp_wmi_apply_fan_settings() is also called from the keep-alive
handler, a race condition with a sysfs write can cause the handler to
wait on itself, leading to a deadlock.

Replace cancel_delayed_work_sync() with cancel_delayed_work() in
hp_wmi_apply_fan_settings() to avoid the self-flush deadlock.

Fixes: c203c59fb5de ("platform/x86: hp-wmi: implement fan keep-alive")
Signed-off-by: Emre Cecanpunar <emreleno@gmail.com>
Link: https://patch.msgid.link/20260407142515.20683-3-emreleno@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index c9fe740d8933e..4dd7e4a118ea4 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -2389,7 +2389,7 @@ static int hp_wmi_apply_fan_settings(struct hp_wmi_hwmon_priv *priv)
 		}
 		if (ret < 0)
 			return ret;
-		cancel_delayed_work_sync(&priv->keep_alive_dwork);
+		cancel_delayed_work(&priv->keep_alive_dwork);
 		return 0;
 	default:
 		/* shouldn't happen */
-- 
2.53.0



