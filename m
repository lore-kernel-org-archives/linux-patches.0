Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC83436F431;
	Tue, 17 Feb 2026 20:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361014; cv=none; b=XwM1GjN3ZrNAYGkB5uEB/qGzjTHuVWzB/Wdi+nzHscTAQWhvJz6bx5eJQHazcMV2vv32YwSXtQS2uIizXlVw348IMLRLFE9LdfueqHYT8AAG8AfAQTOEHViyaZvHADadxCffXXXgHtHhYzYgEVXl+hesKSXkFLGtky21W85Pv48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361014; c=relaxed/simple;
	bh=3fRjGDn2huDDSRyqJtQEjgYvALlGoLkeXNo7UscDNHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWS2I4lm7RPQvigmv9yzlgLHMNqMdOtDL6+z/uWDhrO72P+5xT+r5pbCV+lYsB1Qv/NkFfzsMJsLAZCUOFx1JOBlCEQ+hhs8kc0/y3aIab1Nt20mjVgYvl1N2sMa6SxHY5fEnwRAA/vc0f9G7KuBnEiZbrir6J3mzr4ZrVsd3a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMBYjq9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMBYjq9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD65C19421;
	Tue, 17 Feb 2026 20:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361014;
	bh=3fRjGDn2huDDSRyqJtQEjgYvALlGoLkeXNo7UscDNHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMBYjq9HIGm36fKamjb6kf+7jqF6KiCwyCHM9aGd/qgjtaKeU6MlKAZ7EHpIRLk5y
	 loQCvN8ccHCAJ9B/z891PDYQyVB6M+VaFjTltrwNjDlmfOP7r5uiirlFV3cSfOsi/Z
	 014p10eUP3gbK62WIlLrVQaXHo7rGoEU/VrML7Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/39] gpiolib: acpi: Fix gpio count with string references
Date: Tue, 17 Feb 2026 21:31:25 +0100
Message-ID: <20260217200003.554952275@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit c62e0658d458d8f100445445c3ddb106f3824a45 ]

Since commit 9880702d123f2 ("ACPI: property: Support using strings in
reference properties") it is possible to use strings instead of local
references. This work fine with single GPIO but not with arrays as
acpi_gpio_package_count() didn't handle this case. Update it to handle
strings like local references to cover this case as well.

Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260129145944.3372777-1-alban.bedel@lht.dlh.de
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 3e4fd028a82da..0e6a2200a5feb 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1369,6 +1369,7 @@ static int acpi_gpio_package_count(const union acpi_object *obj)
 	while (element < end) {
 		switch (element->type) {
 		case ACPI_TYPE_LOCAL_REFERENCE:
+		case ACPI_TYPE_STRING:
 			element += 3;
 			fallthrough;
 		case ACPI_TYPE_INTEGER:
-- 
2.51.0



