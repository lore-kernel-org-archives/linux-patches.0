Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED493090E1;
	Mon, 13 Oct 2025 14:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367006; cv=none; b=SBtfY+9OBFcsEyBn1T6rx0n/FyUJiov+NdxbOZ43Mh/4/E3t0gNji25+xImDjhgd2+eDvxTw+MpcAP+JGMbAm2zWz6b5/waz9s9HFnvyZydX8KD4dlagagDgsrbBEjmQ6lHpDx/P2zusAXCIznxoY3VOfjN6toKm8+1sz2cwixU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367006; c=relaxed/simple;
	bh=HuEudgYtkX6qYDy1c41amkHXMCr2g9QC71xVhsYbKpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuG+jc51hCQ6qmehPbuBU5Bu6PtcUUpJt4ugVFC4ilfGjvphU2Q/ERU8v2J9ptL6ZtSwUqK7JS+0gxJsjKRensy7TfwKcBtk/BJ8PLJM53eLY7E8j4qG4bx+UXE0s4iVw7nX3V8qDqbp73XR+DaV+Rsa9Yfn7u4e5U4kUwVGlk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ag4AUwno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ag4AUwno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA36C4CEE7;
	Mon, 13 Oct 2025 14:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367006;
	bh=HuEudgYtkX6qYDy1c41amkHXMCr2g9QC71xVhsYbKpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ag4AUwnokNSPCN9dd/oQeWgriW7vG341lBwZUQ3xvYtLOYW9eYSYgC6YBA40LrZfZ
	 7rSrp4/0JutiVB3f7KfZHOl42mCbOQJU5Hx39BLnFfsBJ9tRncW1SwbRQ45E1MV5I6
	 6Je+jSQCeXid/GlBRm8pWIlaOjHP1WNdNeqoRsEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/196] ACPI: processor: idle: Fix memory leak when register cpuidle device failed
Date: Mon, 13 Oct 2025 16:43:53 +0200
Message-ID: <20251013144316.752677598@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3386d01c1f157..afa3b4ac367a3 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1411,6 +1411,9 @@ int acpi_processor_power_init(struct acpi_processor *pr)
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



