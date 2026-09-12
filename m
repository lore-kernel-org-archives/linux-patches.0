Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237153F1AAD;
	Sat, 12 Sep 2026 07:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198067; cv=none; b=Z/62NnfjuhFb9/e0HHSZeJDzM30LDjazuTiyOtQzNZ0JZqidbjSiZrDbWD0PztlWo6a8KyHRnd6k5a0vInKjfS5Vz25sa+3INvrrVhYfB8RaDQSnODQYwLVPomXfjbMbMZVD22Ly8zWcxkRNGCUu3T6wju4YSMEh2Ak5sPe40yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198067; c=relaxed/simple;
	bh=jiIIdR90w3xuWnLXsmdq6IPYu9pgUt/X1M35PRoUXoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QR7JiDaR/I0pjTWV7TItTYiWaUJPDWALtHU9pj81F/wknfjp9LtlGUX3H+gwFLs0uXbVsb/bKoE8QI45UOFc9rhi38A+jLwjeozgDP7LzuDbwaEtH3F5AxJDnxa9vCNNc1UFnWAYytr7xPF3HBWblvkSeQ+Iy/CusuS1DSk2r9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdQM07+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdQM07+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72C61F00893;
	Sat, 12 Sep 2026 07:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198065;
	bh=KDN3DWTL0hC2oMDme6IwSoBlAnmUsx7tt0m+HfjvYLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdQM07+ZxYHpBM0n8yeHlpDyQwYQlASVBbnYluZ435WvlppdnoqyNb9aOy4NZT9WY
	 L8WgFNIfV9/is5P/0+94LhaBbzwa8nKCcbUPicmh0hjybv2OvLbjwohOazkfO5eaa2
	 xLpNo8eE1qa/U/ucwjNQQYWmsgza+2BJajnrneBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0303/1815] platform/x86: dell-privacy: Fix race condition
Date: Sat, 12 Sep 2026 08:34:13 +0200
Message-ID: <20260912065656.061477456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f9d275b2f900c..366e5b8dc868f 100644
--- a/drivers/platform/x86/dell/dell-wmi-privacy.c
+++ b/drivers/platform/x86/dell/dell-wmi-privacy.c
@@ -92,11 +92,11 @@ bool dell_privacy_has_mic_mute(void)
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



