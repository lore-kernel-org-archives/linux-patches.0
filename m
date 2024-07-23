Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AB813D896;
	Tue, 23 Jul 2024 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759907; cv=none; b=QGMoyrSVVeT9GaevyUmOeqyH+w36OPIMxqm1iAgXfOJTQbbRG+bkMuCsYB6zGgveyJ4NJJff5fGHGcelc3ALZtBrBQu4DfPVNU3Gnq9iWMJUkAXDLgCBOIjqCGGyoSyPMy+4ygH2KuiPIwOKJr/uhAW9b90+Pd7nJ3DlmljbX0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759907; c=relaxed/simple;
	bh=BP6sNZjOHwIou8OrUYh8Ea16NKZ8f7WPzCdifCpEHsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STJDU8egizLq58vz9bfCcYYTNJY2g1wt4nYJfpNpc19agNdYEz3Pkx7Xcp54ZFwPYVUu+j14TX0k+H2UBuYHxj2W3BQpcAC1foklkp3vz5NDVtArVlfSiIzPzr4d8KfZ8uWndfvUffRNI/rP1+ycc20pAewYk51jT4OWp9PkgSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVaZoVZ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVaZoVZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515EDC4AF0A;
	Tue, 23 Jul 2024 18:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759907;
	bh=BP6sNZjOHwIou8OrUYh8Ea16NKZ8f7WPzCdifCpEHsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVaZoVZ+Y8PlvTT5VsKrtpLtuV0wZvtvE7wFFtunqBD++aLuA3wmMlsL0C0cFeyZ7
	 9KaOCoUoPcOIGNkTyW4X7kC+itwG1rznG/cok5eQh/l4AgFCIdwnf1gO4/ZbTPQvcO
	 ycMi5hJ9wtEqssDPkqldFDuUmO84OFAUbOz+m/cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 008/163] ACPI: EC: Abort address space access upon error
Date: Tue, 23 Jul 2024 20:22:17 +0200
Message-ID: <20240723180143.787495191@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 1cec29ab64ce8..b66e5971fd3d1 100644
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



