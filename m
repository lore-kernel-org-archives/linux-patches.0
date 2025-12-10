Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFEC1DD0EF;
	Wed, 10 Dec 2025 07:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352026; cv=none; b=LIR5D/QAzDIm6Tm5XOC9EvOJND9JUTqstxhySrXkWHH+aN5IJxlF+D+ZIiyBKpL8Pv30DBR/DY4www09IFbjf565Aj7ge8OkANcTSFLIh08bryXlkb3yaKApPivdwMRtL71xJvilt876a+eCGiMLMx+5wnrXFEPoq0Ku09M6/nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352026; c=relaxed/simple;
	bh=Fezubit/8lfRERW07QmQVQrahmdEEeXolXmLq0VlrKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRqco81cUX5iT6x/lPgBrYyZhCalY93FeDFFj+Qq2bq3yZAtxx8Le4mR4HIrn4F7lxLoaXwVNGSGP8pd1dSYSyGUiSszjEE3MZMdkeuTmcsphUafJhOyYTtaDe01nn+RO12tO99/Xq3mY9hwqtYR6xq9Dkut8LnvNjW5EPLp7oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrpv7P/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrpv7P/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F610C4CEF1;
	Wed, 10 Dec 2025 07:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352025;
	bh=Fezubit/8lfRERW07QmQVQrahmdEEeXolXmLq0VlrKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrpv7P/+jF1pDeU8V1LftyxrbjurYrne64CCBjZtNo63sGaIqA5VeUS4/LYMQGXmh
	 PWUsMyymGiFJlKLzBIW0tU67EcszRGn7ApU7jrs07WkyJlVkU+y9POYJ9wkT+3FzQN
	 1t3d2G91cTj5Kw6oXkfSFP7frtiJsAsni3GOxAhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 22/60] ACPI: MRRM: Fix memory leaks and improve error handling
Date: Wed, 10 Dec 2025 16:29:52 +0900
Message-ID: <20251210072948.381340760@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 4b93d211bbffd3dce76664d95f2306d23e7215ce ]

Add proper error handling and resource cleanup to prevent memory leaks
in add_boot_memory_ranges(). The function now checks for NULL return
from kobject_create_and_add(), uses local buffer for range names to
avoid dynamic allocation, and implements a cleanup path that removes
previously created sysfs groups and kobjects on failure.

This prevents resource leaks when kobject creation or sysfs group
creation fails during boot memory range initialization.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://patch.msgid.link/20251030023228.3956296-1-kaushlendra.kumar@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_mrrm.c | 43 ++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/acpi_mrrm.c b/drivers/acpi/acpi_mrrm.c
index a6dbf623e5571..6d69554c940ed 100644
--- a/drivers/acpi/acpi_mrrm.c
+++ b/drivers/acpi/acpi_mrrm.c
@@ -152,26 +152,49 @@ ATTRIBUTE_GROUPS(memory_range);
 
 static __init int add_boot_memory_ranges(void)
 {
-	struct kobject *pkobj, *kobj;
+	struct kobject *pkobj, *kobj, **kobjs;
 	int ret = -EINVAL;
-	char *name;
+	char name[16];
+	int i;
 
 	pkobj = kobject_create_and_add("memory_ranges", acpi_kobj);
+	if (!pkobj)
+		return -ENOMEM;
 
-	for (int i = 0; i < mrrm_mem_entry_num; i++) {
-		name = kasprintf(GFP_KERNEL, "range%d", i);
-		if (!name) {
-			ret = -ENOMEM;
-			break;
-		}
+	kobjs = kcalloc(mrrm_mem_entry_num, sizeof(*kobjs), GFP_KERNEL);
+	if (!kobjs) {
+		kobject_put(pkobj);
+		return -ENOMEM;
+	}
 
+	for (i = 0; i < mrrm_mem_entry_num; i++) {
+		scnprintf(name, sizeof(name), "range%d", i);
 		kobj = kobject_create_and_add(name, pkobj);
+		if (!kobj) {
+			ret = -ENOMEM;
+			goto cleanup;
+		}
 
 		ret = sysfs_create_groups(kobj, memory_range_groups);
-		if (ret)
-			return ret;
+		if (ret) {
+			kobject_put(kobj);
+			goto cleanup;
+		}
+		kobjs[i] = kobj;
 	}
 
+	kfree(kobjs);
+	return 0;
+
+cleanup:
+	for (int j = 0; j < i; j++) {
+		if (kobjs[j]) {
+			sysfs_remove_groups(kobjs[j], memory_range_groups);
+			kobject_put(kobjs[j]);
+		}
+	}
+	kfree(kobjs);
+	kobject_put(pkobj);
 	return ret;
 }
 
-- 
2.51.0



