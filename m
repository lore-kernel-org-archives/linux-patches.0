Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE11F317145;
	Sat, 12 Sep 2026 16:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229345; cv=none; b=sfmiuto1l1OTr8Q5j9bMjXJAArFOsdwxCg868JPG+l4Yh5LtMrMdFVnYw5PTKEAam/ObVZuagGDB8aTtbfk+oR0XU3KY3WuJZJSCWr0ZMBzFpEabB8C8qRT4IjzLE9FC8Xq4DRAUw3wOHBA3OA8R0l8YU0DVKrgx4cN4n/UY2yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229345; c=relaxed/simple;
	bh=bmLkUWY1BW3Hz9S3M7UTonNPiW1D8+hTnmqGgkhIs40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZcT2xhfcAIjJyPVx9CsIBg/sIUuzu50NNDYKqjmyOb5lOmDS/sg0Ncai1jLgf4ia1waHg5zAGhqmUaU3f/McV6RdpE5lqIW2NYIHdKBb7yvtYfqxM+Z4t2fvNtyzELIM2zM7mJqQZRpPmsopmpf4EoBIC+i05uFLRVNN+0nS4/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grFgS//h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grFgS//h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063441F000FF;
	Sat, 12 Sep 2026 16:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229344;
	bh=padoA7tat+/mCpuSJ0si4rFPGSOU5HiTOPwAfd3UTFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=grFgS//hvhLToK5Vx41Dv0+N5VpCtGG4auUUPXC3PwdwbijRbvEgd/q8OUZEq6+K/
	 lgO7m0nLEtpMFPJk1Si9EKhPpGU8izAgSqq0aZ7c/9vleWyb+TouvY0A03NJ60ZtMz
	 rA6xLKz+klQP+1HuIuLfRl8tzHcGgxPhqrMfv1fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0572/1191] platform/x86: dell-privacy: Fix race condition
Date: Sat, 12 Sep 2026 08:55:00 +0200
Message-ID: <20260912065601.094639984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit ca9338dbc64759b30741b12017c050b33c94dfa2 ]

Accessing priv->features_present needs to happen with the list mutex
being held, otherwise priv can be freed at any moment.

Fixes: 8af9fa37b8a3 ("platform/x86: dell-privacy: Add support for Dell hardware privacy")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260612173451.467629-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-privacy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-privacy.c b/drivers/platform/x86/dell/dell-wmi-privacy.c
index c517bd45dd32e..3c3865a73226f 100644
--- a/drivers/platform/x86/dell/dell-wmi-privacy.c
+++ b/drivers/platform/x86/dell/dell-wmi-privacy.c
@@ -69,11 +69,11 @@ bool dell_privacy_has_mic_mute(void)
 {
 	struct privacy_wmi_data *priv;
 
-	mutex_lock(&list_mutex);
+	guard(mutex)(&list_mutex);
+
 	priv = list_first_entry_or_null(&wmi_list,
 			struct privacy_wmi_data,
 			list);
-	mutex_unlock(&list_mutex);
 
 	return priv && (priv->features_present & BIT(DELL_PRIVACY_TYPE_AUDIO));
 }
-- 
2.53.0



