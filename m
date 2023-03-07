Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EA9BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60835C4339B;
	Tue,  7 Mar 2023 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212409;
	bh=cegYx0cWUNTy3wCL6/RqqFojrJ0GVY2kK39OgrQ698U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uG8mhPH20zGOxAzD8MMdCplQz/BVNErmpl+z7gJROxsOGXCsg2Y+Zig0lbPjQGB0J
	 iGPKZ6tyYTl/EG4v3r5fPFthP0i5D5lCX6S5ZQq7NcPKbYk8rLLjCdzHW+rqPpCdMf
	 3ThEujqnxgnd7yiiAzocTnXCAj7bOqUmSvY9fIXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/885] ACPI: battery: Fix missing NUL-termination with large strings
Date: Tue,  7 Mar 2023 17:51:47 +0100
Message-Id: <20230307170009.475696627@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit f2ac14b5f197e4a2dec51e5ceaa56682ff1592bc ]

When encountering a string bigger than the destination buffer (32 bytes),
the string is not properly NUL-terminated, causing buffer overreads later.

This for example happens on the Inspiron 3505, where the battery
model name is larger than 32 bytes, which leads to sysfs showing
the model name together with the serial number string (which is
NUL-terminated and thus prevents worse).

Fix this by using strscpy() which ensures that the result is
always NUL-terminated.

Fixes: 106449e870b3 ("ACPI: Battery: Allow extract string from integer")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 306513fec1e1f..084f156bdfbc4 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -440,7 +440,7 @@ static int extract_package(struct acpi_battery *battery,
 
 			if (element->type == ACPI_TYPE_STRING ||
 			    element->type == ACPI_TYPE_BUFFER)
-				strncpy(ptr, element->string.pointer, 32);
+				strscpy(ptr, element->string.pointer, 32);
 			else if (element->type == ACPI_TYPE_INTEGER) {
 				strncpy(ptr, (u8 *)&element->integer.value,
 					sizeof(u64));
-- 
2.39.2



