Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C691C175A;
	Wed, 19 Feb 2025 08:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954387; cv=none; b=n4RgGIFTZvd+zLiv2fNQEQ0EEZytX+i8WNo1Y5qEuEDo/Uwmip9nlLlZuxjVKcdOW6zmg0wCTP01pvFW+K84IDf8c3noXRRbc2HIVLsMAY636bBduHKlyvdC1zObwm/b7iqLJSUyT1l+r8tw3BgQqkwp+EfWfIXqBBfXcMnUp4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954387; c=relaxed/simple;
	bh=zgCtU7GroL0YaoqL9s5sH7WOOzXoegtjlQaLFZRBtaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqgD0axtk9YXU9Tzu4GsJxdWnPOhb5z2SHsH9iLXln0lNgDFD0FK8TUkdQ8E3GjUNS4lPs+h4xUWDDLoPYgORHghmTsXOKshnH7maaOJoYIE3M0TUiVnNXyV0HLTqPi9iw8T+B/CQT4+qkhUp9pqHUA/71tFne6Bmf1dygOd2eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2GHoZmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2GHoZmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699DCC4CEE6;
	Wed, 19 Feb 2025 08:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954387;
	bh=zgCtU7GroL0YaoqL9s5sH7WOOzXoegtjlQaLFZRBtaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2GHoZmP3cbiEey6WBYZqX9NQrNjN4fVRp/5A7zL+QZROem9kvU6Eb11CBzptduYZ
	 A01JGtLt6WJ9lfH+DEX7fm9aq1OaQjDI170TUId4yvCcCO0FFH7UPP+AE/It45xsfu
	 7Y97QRjycp0Oss7FJDZnkH8VTTl+pMFi5kXdj6Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Zheng Zengkai <zhengzengkai@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.13 189/274] ACPI: GTDT: Relax sanity checking on Platform Timers array count
Date: Wed, 19 Feb 2025 09:27:23 +0100
Message-ID: <20250219082616.980374058@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Upton <oliver.upton@linux.dev>

commit f818227a2f3d1d4f26469347e428323d61cc83f0 upstream.

Perhaps unsurprisingly there are some platforms where the GTDT isn't
quite right and the Platforms Timer array overflows the length of the
overall table.

While the recently-added sanity checking isn't wrong, it makes it
impossible to boot the kernel on offending platforms. Try to hobble
along and limit the Platform Timer count to the bounds of the table.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: Zheng Zengkai <zhengzengkai@huawei.com>
Cc: stable@vger.kernel.org
Fixes: 263e22d6bd1f ("ACPI: GTDT: Tighten the check for the array of platform timer structures")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Acked-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Link: https://lore.kernel.org/r/20250128001749.3132656-1-oliver.upton@linux.dev
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/arm64/gtdt.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/arm64/gtdt.c b/drivers/acpi/arm64/gtdt.c
index 3561553eff8b..70f8290b659d 100644
--- a/drivers/acpi/arm64/gtdt.c
+++ b/drivers/acpi/arm64/gtdt.c
@@ -163,7 +163,7 @@ int __init acpi_gtdt_init(struct acpi_table_header *table,
 {
 	void *platform_timer;
 	struct acpi_table_gtdt *gtdt;
-	int cnt = 0;
+	u32 cnt = 0;
 
 	gtdt = container_of(table, struct acpi_table_gtdt, header);
 	acpi_gtdt_desc.gtdt = gtdt;
@@ -188,13 +188,17 @@ int __init acpi_gtdt_init(struct acpi_table_header *table,
 		cnt++;
 
 	if (cnt != gtdt->platform_timer_count) {
+		cnt = min(cnt, gtdt->platform_timer_count);
+		pr_err(FW_BUG "limiting Platform Timer count to %d\n", cnt);
+	}
+
+	if (!cnt) {
 		acpi_gtdt_desc.platform_timer = NULL;
-		pr_err(FW_BUG "invalid timer data.\n");
-		return -EINVAL;
+		return 0;
 	}
 
 	if (platform_timer_count)
-		*platform_timer_count = gtdt->platform_timer_count;
+		*platform_timer_count = cnt;
 
 	return 0;
 }
-- 
2.48.1



