Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F0B280CC1;
	Tue, 17 Feb 2026 20:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361683; cv=none; b=ouGwbOGBHiI7X7cZhmFNtEto8wHb0AuNyi4AIF65gV68pj3d6QlmtkuShCyBHfW7kJWR/bnpNllqYpHLgc9cf/TlqFQjxZof8qbEnil8tTMn3rI0Xe/L7zT7Zvd/CRLdkydZNz3r+JSv8vNXI/uTZufS8Yxz/NrKbq7FOhKs2R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361683; c=relaxed/simple;
	bh=c2Qm2XP2eiAY7Ijq+GbAZdjXyoKKwmtHJ+9609OkkKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIejV1JbUpyx+GqM9BKUlfyaH6BW2CzFioHMcV0aAtNJsV20gEzZ7iLa+XrbMVabsE6wV+E5gfhpGFjUJIgQKYRzQ8zyBZ6/TzHnzajP+ASoePNHm6IeF3GRm8pY/G/6clz/dVZqJGkqXLxz0JeBZZ+hhZGvYLY5686dAHF2SGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgLKU4L0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgLKU4L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE884C4CEF7;
	Tue, 17 Feb 2026 20:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361683;
	bh=c2Qm2XP2eiAY7Ijq+GbAZdjXyoKKwmtHJ+9609OkkKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kgLKU4L05ml/JkH1rR//2UWbhX6hX2qMBm5mUqJManNQ2gbUr/C4jozywA5lQAzRE
	 dLDPe62bk4IK62dcg2N9i5aR5aQMV2yE4E0lm9qoWkz0FK6GaYQtLFK9XMZ/fPWfa6
	 ugXTFwbNNnb6eN6L15tfPU4oTZWneniM6i2nqQuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 25/42] gpiolib: acpi: Fix gpio count with string references
Date: Tue, 17 Feb 2026 21:32:16 +0100
Message-ID: <20260217200006.962340251@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpio/gpiolib-acpi-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib-acpi-core.c b/drivers/gpio/gpiolib-acpi-core.c
index fc2033f2cf258..f6bec9d2fd265 100644
--- a/drivers/gpio/gpiolib-acpi-core.c
+++ b/drivers/gpio/gpiolib-acpi-core.c
@@ -1351,6 +1351,7 @@ static int acpi_gpio_package_count(const union acpi_object *obj)
 	while (element < end) {
 		switch (element->type) {
 		case ACPI_TYPE_LOCAL_REFERENCE:
+		case ACPI_TYPE_STRING:
 			element += 3;
 			fallthrough;
 		case ACPI_TYPE_INTEGER:
-- 
2.51.0



