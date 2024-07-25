Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504418468;
	Thu, 25 Jul 2024 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919058; cv=none; b=YPhJQNI3IcxjvfihSOhZfcVoJwLiZ5Vce6hnilSfsheXppQZtNhEZw0XsMSIMcVWXTErptsHcn6qWLCe4Pj6afz9pDDU2crc8MmaK/kS+mbkkDdlM1mSapr3eu1f5QzJEvq9acy0NhZeNLncfmbGKqZqxuQQfIEwbImva4Uhl0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919058; c=relaxed/simple;
	bh=tGiSg8O/kx7c8knuE6+RgYpQds0VhpRXEruzbJobg5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sv1TDPn8t3mzFy3VE9WdWy4jJ8n/qPQrvvJmJ6Gkzt6GnkNK4yGJd4LR8f3PmkXFKfo5QD34WOKJjhx4ZSxZjneqjDC1/0FcRrITFZP73lZMxPtkZ6updQxORB258jM76Hd/hj9tBIKZhM3kvIH/bm8OzmaiMCGZchMkVJdFhdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUTTXmZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUTTXmZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD591C32782;
	Thu, 25 Jul 2024 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919058;
	bh=tGiSg8O/kx7c8knuE6+RgYpQds0VhpRXEruzbJobg5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUTTXmZVMsE1enityW1JHH+iy6WiwEdbFLQU8k+g2Q4WvCSCy5D7SMGM21GbU1CIX
	 eqMzlgdzS0G7bJM2Rkns6FnJhusRo5/+8tTJqlHUQnMucVM/xP/dTgjMXsqMJnHouL
	 0rR0lJCRlreRmF3/pwKqUpG/slhgFIIA7geICB2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 11/87] ACPI: EC: Abort address space access upon error
Date: Thu, 25 Jul 2024 16:36:44 +0200
Message-ID: <20240725142738.856495273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 472418a0e0cab..1896ec78e88c7 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1303,10 +1303,13 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
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



