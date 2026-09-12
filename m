Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584492F617C;
	Sat, 12 Sep 2026 18:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238563; cv=none; b=WKaa8l7ecDJXfwrRSNVUjCtvTfTvNgza/4Fe+T4/kuwfRaL0C8cltqg7Mhp9mpG2iE7VrK4mPxavw/Oag+Us8Xpo4rVsR1pLFLRwAe5ebSAKDAjFweRAF53KQ3swBn97KFxJqVmM/bT3OhoWdLFHfV4mcGTmM/DxuXJGQxuYiyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238563; c=relaxed/simple;
	bh=fA28I+ivPo67t9iBP0FJxG6JrFyc4IQZBA22UJaONX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hx0UWyc2GM15RzNx1pwV9wOtR1uU97P7/tfyulai/NnbfMrK/zMkky9g70FbuJTBRuUeyayBefOVVkQiNvbEIEraDZieOkWICWX4m7v6rnIaAfYd/UTZ3GuhNTrLVEa3jIiRpJ/RoVdTMdYHohoh9djtdZxXwulDETwqob379c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1a/uVxbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1a/uVxbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D051F000FF;
	Sat, 12 Sep 2026 18:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238562;
	bh=e8lGPFJBGoL7FdVmA9TDWQkFvFPrnF6Tnfv2zD4rsHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1a/uVxbwrsty9pBUR4F2WGZDb43EL0aQpFRJKo1cObCHtxnNMyMYg9ekXxINWSEfm
	 BmGPXQUrfm7vTtVygy7+UTYq00IpCNtBEgy1xu2HaAxna70/DTLDClOoVHCvdod3LV
	 AvHdDDZf2EqljwH9dqfsdNXEuP6ALEOFwb8QYeiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 485/935] platform/x86: dell-privacy: Fix race condition
Date: Sat, 12 Sep 2026 08:58:35 +0200
Message-ID: <20260912065537.944678206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7b79e987ca088..7fe491d28c134 100644
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



