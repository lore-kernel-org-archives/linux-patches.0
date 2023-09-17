Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CD96FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:13:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17B2C4339A;
	Sun, 17 Sep 2023 20:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981592;
	bh=U2r6mRIQ4l6aSCiGjRvZn6PZ+V4xKLlks7v2kAeN56g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IS6SmhXtojBtwlXNqPYbmMlRcaKjg34f29aGJwZIGtP4hJVzQ+Ykv9H6WL2T6dBaC
	 orQXgSKflxLHf1hphezBENW7T53Wy/pwUrDDdMFzFXsPuAzwHUZgmYMxv694U4+yj4
	 EOWOyZy9N09sJLocsqNyIPqaM5bpqkCKufyWMR64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/511] ACPI: x86: s2idle: Fix a logic error parsing AMD constraints table
Date: Sun, 17 Sep 2023 21:08:23 +0200
Message-ID: <20230917191115.712062728@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 9cc8cd086f05d9a01026c65c98da88561e9c619e ]

The constraints table should be resetting the `list` object
after running through all of `info_obj` iterations.

This adjusts whitespace as well as less code will now be included
with each loop. This fixes a functional problem is fixed where a
badly formed package in the inner loop may have incorrect data.

Fixes: 146f1ed852a8 ("ACPI: PM: s2idle: Add AMD support to handle _DSM")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 7658953dfce8f..946e0160ad3bf 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -127,12 +127,11 @@ static void lpi_device_get_constraints_amd(void)
 				struct lpi_constraints *list;
 				acpi_status status;
 
+				list = &lpi_constraints_table[lpi_constraints_table_size];
+
 				for (k = 0; k < info_obj->package.count; k++) {
 					union acpi_object *obj = &info_obj->package.elements[k];
 
-					list = &lpi_constraints_table[lpi_constraints_table_size];
-					list->min_dstate = -1;
-
 					switch (k) {
 					case 0:
 						dev_info.enabled = obj->integer.value;
@@ -147,27 +146,21 @@ static void lpi_device_get_constraints_amd(void)
 						dev_info.min_dstate = obj->integer.value;
 						break;
 					}
+				}
 
-					if (!dev_info.enabled || !dev_info.name ||
-					    !dev_info.min_dstate)
-						continue;
+				if (!dev_info.enabled || !dev_info.name ||
+				    !dev_info.min_dstate)
+					continue;
 
-					status = acpi_get_handle(NULL, dev_info.name,
-								 &list->handle);
-					if (ACPI_FAILURE(status))
-						continue;
+				status = acpi_get_handle(NULL, dev_info.name, &list->handle);
+				if (ACPI_FAILURE(status))
+					continue;
 
-					acpi_handle_debug(lps0_device_handle,
-							  "Name:%s\n", dev_info.name);
+				acpi_handle_debug(lps0_device_handle,
+						  "Name:%s\n", dev_info.name);
 
-					list->min_dstate = dev_info.min_dstate;
+				list->min_dstate = dev_info.min_dstate;
 
-					if (list->min_dstate < 0) {
-						acpi_handle_debug(lps0_device_handle,
-								  "Incomplete constraint defined\n");
-						continue;
-					}
-				}
 				lpi_constraints_table_size++;
 			}
 		}
-- 
2.40.1



