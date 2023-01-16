Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AF16FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C12AC433D2;
	Mon, 16 Jan 2023 16:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887873;
	bh=oL1VJMfEq5tvAuOLKDNswXJuZ+SFEbwpFCgRvOWeplg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyHVhBdb9NoxDXxlwGi4F3GWExwDyEA1J7dYt1mMRWW9fQTfPh5IkmNFCiZO/cOKJ
	 yVrDJgv0pJj6geUJTvFURiK2U72dij15jeBEYjLBU1CJP13k9R1qVBHR9bA5rIB28g
	 knpOknQIcWF8Gu9uW+4qyA6s8+J53rQBTihPiCrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 314/521] ACPICA: Fix error code path in acpi_ds_call_control_method()
Date: Mon, 16 Jan 2023 16:49:36 +0100
Message-Id: <20230116154901.182826527@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 404ec60438add1afadaffaed34bb5fe4ddcadd40 ]

A use-after-free in acpi_ps_parse_aml() after a failing invocaion of
acpi_ds_call_control_method() is reported by KASAN [1] and code
inspection reveals that next_walk_state pushed to the thread by
acpi_ds_create_walk_state() is freed on errors, but it is not popped
from the thread beforehand.  Thus acpi_ds_get_current_walk_state()
called by acpi_ps_parse_aml() subsequently returns it as the new
walk state which is incorrect.

To address this, make acpi_ds_call_control_method() call
acpi_ds_pop_walk_state() to pop next_walk_state from the thread before
returning an error.

Link: https://lore.kernel.org/linux-acpi/20221019073443.248215-1-chenzhongjin@huawei.com/ # [1]
Reported-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dsmethod.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/dsmethod.c b/drivers/acpi/acpica/dsmethod.c
index dd4deb678d13..a00516d9538c 100644
--- a/drivers/acpi/acpica/dsmethod.c
+++ b/drivers/acpi/acpica/dsmethod.c
@@ -517,7 +517,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 	info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_evaluate_info));
 	if (!info) {
 		status = AE_NO_MEMORY;
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	info->parameters = &this_walk_state->operands[0];
@@ -529,7 +529,7 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
 	ACPI_FREE(info);
 	if (ACPI_FAILURE(status)) {
-		goto cleanup;
+		goto pop_walk_state;
 	}
 
 	/*
@@ -561,6 +561,12 @@ acpi_ds_call_control_method(struct acpi_thread_state *thread,
 
 	return_ACPI_STATUS(status);
 
+pop_walk_state:
+
+	/* On error, pop the walk state to be deleted from thread */
+
+	acpi_ds_pop_walk_state(thread);
+
 cleanup:
 
 	/* On error, we must terminate the method properly */
-- 
2.35.1



