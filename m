Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E200128370;
	Mon,  8 Apr 2024 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583853; cv=none; b=kOXQVrgiZQN0Y3OonUvnPnErLmiV6T9axcTxAbuklXZLLicw8cccTffD73hm6HXhZHqMQGEc8vgQkjvFGiOaKdWKp7EbX/E/Ely6udJZgqush3iGu5bIOdeV5MbMhHVWpj8vzyNzdb9ixPxhGuA5QpF4cjxv6/KlEXpkLpvt3wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583853; c=relaxed/simple;
	bh=RZ8tuwPWg/PBTQOhttLBJbm1zsOMloCEy0UCAk0Y/Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkySlI9K6J7j9rTcVFDVgPap3wP/LjJJFt75MBLTv1Qw4X+6D38sbkPBGZuvxPmJfnLV00DsRenth3Y0Vm3arfJZ5FvejHck3dLEiC0w8wiMfZ6cnXOzOIYhnIaDnJw1qsYu7PxT+PB7YF4u16FI+W7pUNGs0ehWrXPRO3CdJsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p0p4pQrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p0p4pQrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1F1C43394;
	Mon,  8 Apr 2024 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583853;
	bh=RZ8tuwPWg/PBTQOhttLBJbm1zsOMloCEy0UCAk0Y/Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0p4pQrOvzdWx/8ril7JyydKGEnX/TgCKgIK14c3RdPxU3NTr5/MiBkBb/V/iZ7hw
	 Sp6u/v5PIH2alYvYmACiqK/axdPY0h0GtVLHRkwEXYt1M7EIYmIKPlXaVysQ9H19bo
	 Hbs3jPQpxuFv/mQt5M5Go32OYsSQw2DiykLUi8H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.6 242/252] of: module: prevent NULL pointer dereference in vsnprintf()
Date: Mon,  8 Apr 2024 14:59:01 +0200
Message-ID: <20240408125314.159483376@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Shtylyov <s.shtylyov@omp.ru>

commit a1aa5390cc912934fee76ce80af5f940452fa987 upstream.

In of_modalias(), we can get passed the str and len parameters which would
cause a kernel oops in vsnprintf() since it only allows passing a NULL ptr
when the length is also 0. Also, we need to filter out the negative values
of the len parameter as these will result in a really huge buffer since
snprintf() takes size_t parameter while ours is ssize_t...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/1d211023-3923-685b-20f0-f3f90ea56e1f@omp.ru
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/module.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/of/module.c
+++ b/drivers/of/module.c
@@ -16,6 +16,14 @@ ssize_t of_modalias(const struct device_
 	ssize_t csize;
 	ssize_t tsize;
 
+	/*
+	 * Prevent a kernel oops in vsnprintf() -- it only allows passing a
+	 * NULL ptr when the length is also 0. Also filter out the negative
+	 * lengths...
+	 */
+	if ((len > 0 && !str) || len < 0)
+		return -EINVAL;
+
 	/* Name & Type */
 	/* %p eats all alphanum characters, so %c must be used here */
 	csize = snprintf(str, len, "of:N%pOFn%c%s", np, 'T',


