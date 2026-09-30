Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F47F5038F7;
	Wed, 30 Sep 2026 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782518; cv=none; b=Tph7d+GjIoibjbhNgrcG84fMaCN6ArtzRDlzKlnVCJE0rDsVKgkJT8JI1+dHIBqABB76sjkyyEEK7brusOYpXkVF1bnSY9N4znwbQ8gWiXyzNZ/F8pK/Xvvw4oOuDtJmeX/lntr9sDlmqCqr0hEkr3DozvotQkQF5KvU5bmN9f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782518; c=relaxed/simple;
	bh=LdG/TKL1vgu889NaQB506rxLHgqLkaGzEWHPTXbKM5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoQJzL+G6BgC6NlwbKvbAHGVGrLPeGM6Lrs435F0mGR5SPM8E+QSk3NP4UC1fFfvbmdFc+WigBkPqBXNUMX/vZdpco5Bt+uUa0cYRlA3uBd8oD3wSkscdSLGhdmW/s/lmIxn8SeLFgRSmtKBJ9Y7pb5ZGzTjX2N3hxmhzyYyIvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OHwK1J+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OHwK1J+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E5F1F0089A;
	Wed, 30 Sep 2026 15:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782510;
	bh=1MIRv0fYIX3QAILAFsnt+p2ew4ScAQOo5ECYfho4L9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0OHwK1J+lA75UNI/41zjyXN/wziVpbig9KOjM6WkZc1y0Oc26jXBG+ol6pY4e75HA
	 bjtYcqeOVV5YOD+S0nDaazI+MjEhB2A5Qt8L7QfNAU5O4Q+Q+G/7SjMjomgrsw4yAu
	 WBZcmXu7Z+ubXWVHJ8x+PQ887C1FrBtkWQH4rlVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 073/595] ACPICA: Prevent adding invalid references
Date: Wed, 30 Sep 2026 17:19:26 +0200
Message-ID: <20260930152349.306983598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ikaros <void0red@gmail.com>

[ Upstream commit 6e8c55e13a5e3a9f38921d62924f18ceba3330eb ]

Prevent adding references for local, argument, and debug objects
in acpi_ut_copy_simple_object().

Link: https://github.com/acpica/acpica/commit/f576898d7814
Signed-off-by: ikaros <void0red@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4511989.ejJDZkT8p0@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utcopy.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpica/utcopy.c b/drivers/acpi/acpica/utcopy.c
index 9a7cc679e5447..e4b62202fd306 100644
--- a/drivers/acpi/acpica/utcopy.c
+++ b/drivers/acpi/acpica/utcopy.c
@@ -731,7 +731,15 @@ acpi_ut_copy_simple_object(union acpi_operand_object *source_desc,
 			break;
 		}
 
-		acpi_ut_add_reference(source_desc->reference.object);
+		/*
+		 * Local/Arg/Debug references do not have a valid Object pointer
+		 * that can be referenced
+		 */
+		if ((source_desc->reference.class != ACPI_REFCLASS_LOCAL) &&
+		    (source_desc->reference.class != ACPI_REFCLASS_ARG) &&
+		    (source_desc->reference.class != ACPI_REFCLASS_DEBUG)) {
+			acpi_ut_add_reference(source_desc->reference.object);
+		}
 		break;
 
 	case ACPI_TYPE_REGION:
-- 
2.53.0



