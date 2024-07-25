Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC4A19D083;
	Thu, 25 Jul 2024 14:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918473; cv=none; b=Xh5vGEP1UKs3tlukNQtXICq7vwEULC91l7/tLidnfSb0xB12gF8e6uNRR4shkJyd+ffYHuReW/84blpK6cFn8c01mvQ0l+MXFa0fJGnrG+Pwc+2egA69gvbZ9sGrcajyRRTS9EcGXcbtu/KzWDZRlv+LhrViXFc7s00j5YegF78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918473; c=relaxed/simple;
	bh=+ISidtzFIoQud6JdCE1LnjNL4zzdqHWmecygLcl+WUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7ReZBhumFF4XqJCMHOIRHNSmkbCcz0G8BDnp0LaiM5pXtBMnynYi0MwagUqFSaPKACKf7wmnDFnHbss44YhyIIPx4udKBCYipAvR/PbFpK7hY0dXwdiLXhDySJlc+a/Jwo/IuXQx/9rjcmNxUOf+0rTSjVlLWHFz1jkn1rAJ6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lVbEPsdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lVbEPsdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E8DC116B1;
	Thu, 25 Jul 2024 14:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918473;
	bh=+ISidtzFIoQud6JdCE1LnjNL4zzdqHWmecygLcl+WUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lVbEPsdIcL/O8D71w1MTrrVcAMPvaqt8Yh8g2Z/7dvmLQfSdmNTl6aBKlf9mF+aEE
	 q7KI9LLNvpjYT9ocn7DuOKjcEriPe/3i0me0H9NWlKNZIirZgorr4ZETQZIqmluKdZ
	 NtZRSkpN/69uaM01S57zXpTrt7Acs5tZxvGzSULc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/33] ACPI: EC: Abort address space access upon error
Date: Thu, 25 Jul 2024 16:36:26 +0200
Message-ID: <20240725142728.646466042@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit f6f172dc6a6d7775b2df6adfd1350700e9a847ec ]

When a multi-byte address space access is requested, acpi_ec_read()/
acpi_ec_write() is being called multiple times.

Abort such operations if a single call to acpi_ec_read() /
acpi_ec_write() fails, as the data read from / written to the EC
might be incomplete.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index d2fde87e4d0d4..78f8b8b5a8099 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1330,10 +1330,13 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 	if (ec->busy_polling || bits > 8)
 		acpi_ec_burst_enable(ec);
 
-	for (i = 0; i < bytes; ++i, ++address, ++value)
+	for (i = 0; i < bytes; ++i, ++address, ++value) {
 		result = (function == ACPI_READ) ?
 			acpi_ec_read(ec, address, value) :
 			acpi_ec_write(ec, address, *value);
+		if (result < 0)
+			break;
+	}
 
 	if (ec->busy_polling || bits > 8)
 		acpi_ec_burst_disable(ec);
-- 
2.43.0



