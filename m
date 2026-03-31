Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0389E2E1C7C;
	Tue, 31 Mar 2026 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976792; cv=none; b=F9awmNkYK9dMDxalgDbObapHvBBzoATU+qGh+UlJSss3KJYuXHkBtuxOo1I5LYyEo9HNtVy2kqsAkJ4UKRiX9lzj/ebXEZfyz+jWS1Lf+fXj9GbfG29n2Qowxh/FcKmSl+t2Poxx9InNVuE7XU8UkdHJuEre2X86UpWjJ+XPDdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976792; c=relaxed/simple;
	bh=KQhqdVzicDc5BOtk8nFlFr89dC7YFzYWrRGcoHGz2rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7wpvKZqEMtWXoJuB35iA13ncbDez/c1B1XwQ3gSZf947M8XXr5WgDXr2KFpNoEe5/eHVYZFnR4jzERFcYgHp72LbAJdNnYpfVV/7XMQJm0Ij1/03X8bF0jlL9MtRAM66K8Qwtu60Fe5Ffk0Xj9rGy2ThnrFb+lxyE6CGKLr0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5p9pQBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5p9pQBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0BFC19423;
	Tue, 31 Mar 2026 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976791;
	bh=KQhqdVzicDc5BOtk8nFlFr89dC7YFzYWrRGcoHGz2rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5p9pQBmMqNo73+SZapZYQVKzmZ6wilsHZ0f4rgIemA1TwQTP0H5wHsZEURqZi2Nq
	 JBPWTcaIUFN6ccOQ2yh/wbbx9G/Nhb+0bwLm/6W9APOU2nQRpMncpDyQfC6zt+pthB
	 JeAcYeoZoUdIACMd/tE8uprLzNtAkd/vIVJeCoII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 202/309] hwmon: (peci/cputemp) Fix off-by-one in cputemp_is_visible()
Date: Tue, 31 Mar 2026 18:21:45 +0200
Message-ID: <20260331161800.887209721@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit b0c9d8ae71509f25690d57f2efddebf7f4b12194 upstream.

cputemp_is_visible() validates the channel index against
CPUTEMP_CHANNEL_NUMS, but currently uses '>' instead of '>='.
As a result, channel == CPUTEMP_CHANNEL_NUMS is not rejected even though
valid indices are 0 .. CPUTEMP_CHANNEL_NUMS - 1.

Fix the bounds check by using '>=' so invalid channel indices are
rejected before indexing the core bitmap.

Fixes: bf3608f338e9 ("hwmon: peci: Add cputemp driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260323002352.93417-3-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/peci/cputemp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/peci/cputemp.c
+++ b/drivers/hwmon/peci/cputemp.c
@@ -339,7 +339,7 @@ static umode_t cputemp_is_visible(const
 {
 	const struct peci_cputemp *priv = data;
 
-	if (channel > CPUTEMP_CHANNEL_NUMS)
+	if (channel >= CPUTEMP_CHANNEL_NUMS)
 		return 0;
 
 	if (channel < channel_core)


