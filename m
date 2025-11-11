Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768EC4C97;
	Tue, 11 Nov 2025 00:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822696; cv=none; b=dz58T2cYUH3xjf8uR+vtsTmOy6be3XSFpNtpFaFGhUiBwkUm0sZ1uHOAjsvsCfYaMGGgMao5oSXIDC2/qtzYvvX0j+5M0JQCR0/XD0tZKbk37mDDVZa+81q/AJDe54o9MYC1pQMU9YTvy6Kd/u+2fxJFyVnDmhjsKMSZKYtpGf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822696; c=relaxed/simple;
	bh=N4a0hV2/pW4mZjTPUn6P1OCbmwGehRBwRR0Hy5IJ7Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dj+4PETsZDcgLfvpSSbXn6q04OQxbvhUzrbOpwmtt8iONkDyN0TLW0PdfzyRSeB5E9KvmLHYaqfCQw+Y5FL1zocanD1mEVu63O9QUp3CruEI63optMImNk3mA9aj1IKfKLHLBznphqoOvCE84cKJ8BQ0lA+BQhIG6zQzxCZSYxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQhys9oC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQhys9oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16664C19422;
	Tue, 11 Nov 2025 00:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822696;
	bh=N4a0hV2/pW4mZjTPUn6P1OCbmwGehRBwRR0Hy5IJ7Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQhys9oC4vV62whYJ/ufymXI562hD1wJASQdxoazmTZ2xQoxHGmantxpRjwSAP+rb
	 qXA4VNR91T96MzNJvYhWt9AWKicJiLB+ra5wCFwBzZ/OGSkfEhUqGMCb+ZOzPIjsUt
	 RuCcmxCen0LuhoV7TfMpDKnlQMEF84vciutzcx0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 150/849] ACPI: scan: Add Intel CVS ACPI HIDs to acpi_ignore_dep_ids[]
Date: Tue, 11 Nov 2025 09:35:20 +0900
Message-ID: <20251111004540.047249160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit 4405a214df146775338a1e6232701a29024b82e1 ]

Some x86/ACPI laptops with MIPI cameras have a INTC10DE or INTC10E0 ACPI
device in the _DEP dependency list of the ACPI devices for the camera-
sensors (which have flags.honor_deps set).

These devices are for an Intel Vision CVS chip for which an out of tree
driver is available [1].

The camera sensor works fine without a driver being loaded for this
ACPI device on the 2 laptops this was tested on:

ThinkPad X1 Carbon Gen 12 (Meteor Lake)
ThinkPad X1 2-in-1 Gen 10 (Arrow Lake)

For now add these HIDs to acpi_ignore_dep_ids[] so that
acpi_dev_ready_for_enumeration() will return true once the other _DEP
dependencies are met and an i2c_client for the camera sensor will get
instantiated.

Link: https://github.com/intel/vision-drivers/ [1]
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://patch.msgid.link/20250829142748.21089-1-hansg@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index fb1fe9f3b1a36..9865faa996b0d 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -845,6 +845,8 @@ static bool acpi_info_matches_ids(struct acpi_device_info *info,
 static const char * const acpi_ignore_dep_ids[] = {
 	"PNP0D80", /* Windows-compatible System Power Management Controller */
 	"INT33BD", /* Intel Baytrail Mailbox Device */
+	"INTC10DE", /* Intel CVS LNL */
+	"INTC10E0", /* Intel CVS ARL */
 	"LATT2021", /* Lattice FW Update Client Driver */
 	NULL
 };
-- 
2.51.0



