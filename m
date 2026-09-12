Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6539547AF6A;
	Sat, 12 Sep 2026 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215367; cv=none; b=s2NxXAsheXvEATu73tZupJtZEaA3kSFWg6BHdsB1PHizeifnc0e83q0kqb76yI1idzi7TPDrziZHwNYN5h6wliH4nhadM3F1kBW7GDrVX9rgMxfnnVyKvAg8JuQ047fzuZjv08vm6PFBNYlWeiHWOBrI45rYSlfl5G/MlEfbjDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215367; c=relaxed/simple;
	bh=MJzUouuZF0N3Rme4E+b7QFs5ZLjAuH7/fQTEtN80k/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MIMCdrci8mmT7ZMKgeU9uF6N+oFxaxdOZ+sxo0whuIoyAgkeEOwgxi/mcQ2PLmz+pJK2Ikdt4XDLSIQ7WqSMUHHsPLRMW7blkZxeeth7zOlFY7XjWti7gW1EF/Vki9gOxAloknSeXWO5AMw/xE6aoDn3fZTy56SnmUWgJS+xNUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flmyke5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flmyke5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7861F000FF;
	Sat, 12 Sep 2026 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215365;
	bh=PmiLFQJ/LSCGJNebNFPIpFYclKwD+sy72+BDvDtCfjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=flmyke5Bl2ACcgqRFwhy8Cd6rY6r+8uctjoASA74pINNadsdC1sbPurywvLtAK/Oo
	 kps2QpnaTvCxvMK/FdKjp+trNcQVob0c3c6rSu6t29ly3NnLNMtWLnjY5YijlDY18x
	 us7FK07av3nTm31r65ACBr4APyPdqcV+dsVE1378=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0474/1376] platform/x86: dell-privacy: Fix race condition
Date: Sat, 12 Sep 2026 08:48:20 +0200
Message-ID: <20260912065618.097099469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4b65e1655d42a..7c2b6fae96c52 100644
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



