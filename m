Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6F2155351;
	Tue, 23 Jul 2024 18:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759498; cv=none; b=Vc7SEkNmHTRsGmFE208bmOdub+aVjA5ryLxHk16YOn/ORlMIQ+fJ4+JQDbea3nEJ0a/PC1nLWKtZxiJdQho4nRrUaWu+wtMOieD3YRHfoH+tbAr+2yaIfV8G/86+YMvejcmgAFZ0oq5hbcCdBjeXV6PXWrrPtDsVOMIkYyJFp4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759498; c=relaxed/simple;
	bh=NznWhy70FTo29nD3p+wnR4X6jyLb3pYOGkfpCiebQ4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUQiSeOJLyTABzV4X+oJL9qXDfeZF2nZY/zvTpMvK29FSb4jm0aVTy8rGRY9mzsGf+9wi1taTVsxMj7pp6qgLTdW4306hY5cDzTRumjUHfxD3/M8RZ07frkwZuTwzck+qobPhDDuau8FLho3yqQu90JzuZ80MDeaaN/ZSNcrXho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jdr7Kgfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jdr7Kgfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9404DC4AF09;
	Tue, 23 Jul 2024 18:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759497;
	bh=NznWhy70FTo29nD3p+wnR4X6jyLb3pYOGkfpCiebQ4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jdr7KgfgVtSOzQD7B9Bf5+iNodXovlmUilrSfm1bmExFLZpw1zu3yIO9UL9LmAK0P
	 DGVG15mrGSgukVlqrDd2evuKOcjG414e4foYeuBi48X/FNwZAM+3HEH8ZHop6e9HSV
	 HygOKmEp3CkUeqIG0IU4wSPxATEaj2bn5+jgRx4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/129] ACPI: EC: Abort address space access upon error
Date: Tue, 23 Jul 2024 20:22:36 +0200
Message-ID: <20240723180405.102607483@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
index bdeae6ca9f059..3a2103da6a21c 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1333,10 +1333,13 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
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



