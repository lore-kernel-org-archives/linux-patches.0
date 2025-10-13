Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8642A311958;
	Mon, 13 Oct 2025 15:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368188; cv=none; b=QFssIbv16r+9iKnQtqhMYwqvK9g7jyNhH/fufRZuGrw/QAYLvkGvyyn7bltC8ozrMKKsWj0tkKhGvj22oFKbf17q6qu9LqrJerGDhcfu/855e+y1GiuQqTv5Lvs4y0Qqz9C+QwZbAOgY3sN1lmf8XfGYH1FBDoyYVB7RrEsKDwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368188; c=relaxed/simple;
	bh=7VdeC7ODruayH2jsWSJ+H0HDohUQ4ODNOu4BE4sssPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPV2TODgGo69tL5dk43e4Uc3iOp/zvWOCSforrHWHj5ZvjUBR9M1gQJaYQZ22dLf3wSR/kDglbzfVF45kjfSg2yQPdQ5BcxIQ83PVNqAHcQUCi3vpOrD0oa30mT3iVh7TlytmdHrtPb7ruJmIW8Sn9mx7RhMMbQn7fouQAUde/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJVhvATk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJVhvATk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021E9C4CEFE;
	Mon, 13 Oct 2025 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368188;
	bh=7VdeC7ODruayH2jsWSJ+H0HDohUQ4ODNOu4BE4sssPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJVhvATkj4naSbU5KuEiB5WPj6kCFqmwBix32vruoJybPQC9gG4/VSe+wX1/gybjU
	 jk/u2vlQLVAIo18cWP9iZ10T9IlieAeMbStQ7V8CgfSkxeaS3+ck72br5xxiX04cl4
	 jtrqVvBNeVSJg51PTpmeFZUFA03sdTO75jmbHdIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/262] ACPI: processor: idle: Fix memory leak when register cpuidle device failed
Date: Mon, 13 Oct 2025 16:42:53 +0200
Message-ID: <20251013144327.254081743@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 11b3de1c03fa9f3b5d17e6d48050bc98b3704420 ]

The cpuidle device's memory is leaked when cpuidle device registration
fails in acpi_processor_power_init().  Free it as appropriate.

Fixes: 3d339dcbb56d ("cpuidle / ACPI : move cpuidle_device field out of the acpi_processor_power structure")
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20250728070612.1260859-2-lihuisong@huawei.com
[ rjw: Changed the order of the new statements, added empty line after if () ]
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 0888e4d618d53..b524cf27213d4 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1410,6 +1410,9 @@ int acpi_processor_power_init(struct acpi_processor *pr)
 		if (retval) {
 			if (acpi_processor_registered == 0)
 				cpuidle_unregister_driver(&acpi_idle_driver);
+
+			per_cpu(acpi_cpuidle_device, pr->id) = NULL;
+			kfree(dev);
 			return retval;
 		}
 		acpi_processor_registered++;
-- 
2.51.0



