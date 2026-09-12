Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37AE3264EF;
	Sat, 12 Sep 2026 14:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222984; cv=none; b=ZGSmvsto4T3zmFZrP06A7Bsi22sQjfeHATssFMoV8rSTr0DdutC5VJv22OBzJOFpbm3+5to6Qp4VhuQDRRiP+ywUbElXIZsYXTLX/VUKwbKtU1QIQr8jME1DEIRZJg+vtahsu9H6qunaQefEkbnqqPcAhqJcTOdffo00h6VYbvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222984; c=relaxed/simple;
	bh=CEtx1jFEI5y55VYHdpAVTEMwAIYDcIUlj3NNRujzEm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MtRwtC2Vgp2uLx+N4X78WA9iIs4vUkCVi17a52VlU6YJCgsTXA7qvmii8nxFD5URQIVvv6GaG+V0QuSw5Mmhfvujz5UWDMbBvxP6likwlkhesNyPWXvu3LQIXJRjKJ4AWOh1Rs28RWCuQznV3FIKN/mXb1Z1aa/RvFLHmdR43As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atzb1jo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atzb1jo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F52D1F000FF;
	Sat, 12 Sep 2026 14:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222983;
	bh=G4sW+kPX8qzsT5W+sJMVtDsKGqYj1EmpET3mndMNRHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atzb1jo0dMHeGvcUrY8RUHW0KCPXC7lCZDbP/BBUzAL7MgJ73lGkVhzUtdFOCVvvD
	 nlU0N3MxBymKvxoADJfv0Wi0hiNVDXgOTzGJlveTOJTPjs8b6ISZBOOjyF45ZKWEYG
	 xPmeEo8iDu5dhQ1AYTjLvMun2OFqHwVfyc4S8F+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0697/1424] platform/x86: dell-privacy: Fix race condition
Date: Sat, 12 Sep 2026 08:52:09 +0200
Message-ID: <20260912065622.907462095@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



