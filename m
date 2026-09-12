Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A53219D8BC;
	Sat, 12 Sep 2026 09:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206882; cv=none; b=O5pgJgoMr0FvEp+vjaGJp0P4JBIIog4FkZFVNVHOgoLSI//BZw6FgxaWZqsG23xn/P57MNlQxgY02KxTdc8QqaBN6EdHTotf9wcFVUBGitxt9104Ow0Xl1BwdANGMO8mxQJuuSF9mtKM30u4JdcPmqMVJHr4YO7kiHkIfyBmSWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206882; c=relaxed/simple;
	bh=Ghn9oa6x3b+1clNZDUESy0k3XWtjn9UDE6ULrtEjt0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OOaJr1ihCD8jxsY5eIjmamBddDH00fBLBD/yhaL1UuxB3wFCjSM+uRuH8gcvhP8/pyo6WRKIl4muzLYV2dxIr3OnrscAATKCqL2lgL6ADbmqgNUo794a6RbCROMqkt2TUpBHbcTS0O4BzygGx9iZpG7tM4PwToMFIVfP4jKpy5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFWJMrfj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFWJMrfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B721F000FF;
	Sat, 12 Sep 2026 09:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206881;
	bh=Qn4C67RDPAfBsPNn84L4XFuORoeRfSIp34iwaOQpILI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFWJMrfjPK0u3bMb+2ziL90KflcRZB4AqRreMPk8+/V+nekFZCE9L0h5rzV9jJeUW
	 vJPMLo9Z/EgTEXdIkuDfcxQcB9KrsxIDzdkqaReUo7rtMVp+lhgUFs7Vz5469TeJtt
	 1zjVhwNIPk4WcbenqSYUaNZgFi5lwX0k9dc9UUKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0298/1518] platform/x86: dell-privacy: Fix race condition
Date: Sat, 12 Sep 2026 08:41:07 +0200
Message-ID: <20260912065630.221838295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



