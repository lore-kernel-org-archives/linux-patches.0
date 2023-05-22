Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DBB171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA777C433EF;
	Mon, 22 May 2023 19:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783489;
	bh=IQgHuOoRnkEGD1Jb5Lkm537dUiI0uLn05CysAyCGk+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDOoOXRyIZc+lzBwMETr+9x+GCsddSnRYNsHOlNnJlmJHemEz3UeEHsnT13Rj2KeK
	 fRWpAQ+QBdtICGKqDiJX7/Mk4Yde9jvQIcj8czZxdtoqZusVLGwjf/UZiEdewuejg3
	 +Z0fNdeOoF6MezHHHR1Z6vWhaE6KB9yWNyxmaUG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Chen <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/292] ACPI: processor: Check for null return of devm_kzalloc() in fch_misc_setup()
Date: Mon, 22 May 2023 20:06:50 +0100
Message-Id: <20230522190407.262706314@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kang Chen <void0red@gmail.com>

[ Upstream commit 4dea41775d951ff1f7b472a346a8ca3ae7e74455 ]

devm_kzalloc() may fail, clk_data->name might be NULL and will
cause a NULL pointer dereference later.

Signed-off-by: Kang Chen <void0red@gmail.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_apd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
index 3bbe2276cac76..80f945cbec8a7 100644
--- a/drivers/acpi/acpi_apd.c
+++ b/drivers/acpi/acpi_apd.c
@@ -83,6 +83,8 @@ static int fch_misc_setup(struct apd_private_data *pdata)
 	if (!acpi_dev_get_property(adev, "clk-name", ACPI_TYPE_STRING, &obj)) {
 		clk_data->name = devm_kzalloc(&adev->dev, obj->string.length,
 					      GFP_KERNEL);
+		if (!clk_data->name)
+			return -ENOMEM;
 
 		strcpy(clk_data->name, obj->string.pointer);
 	} else {
-- 
2.39.2



