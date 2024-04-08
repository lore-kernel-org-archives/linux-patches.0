Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B8F7B3E5;
	Mon,  8 Apr 2024 13:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582104; cv=none; b=ZMgMwE1mAXIrpuc+pquawBT9WCoz3vIY7gnEfeOmQA6v4sbSVz08qN4HiOWRQ0KcdQExPqCz0aQE2ftRjwSHTdc+w97vsXQ/NpWUUZQEnwGE0mOPEP7laATFXNvERooENFzUgw5jZvgp1KwtW3M7pb1uCgkGnhuJoAzvVQLfEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582104; c=relaxed/simple;
	bh=tQpKB/WOim+2nSgLZ9vPhqTbzdjS2uQegNYa/4S9uek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXVehJzHtt13MP5XYyonTeQGytbtFT8eN/Zm6PsC0OoFRSkUHB6pOERlTMvImwzOZ5dNoCmTKS/OUl5nHEgCAVaVNQkdudmpPoBh441IAVCNq3LEVgHWXTZeh+9ozwLvah6F4OU01T6XgaiI6E7SC6RKqPJwDNyvtgLGapJn31I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfRaet7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfRaet7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79FDC433C7;
	Mon,  8 Apr 2024 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582104;
	bh=tQpKB/WOim+2nSgLZ9vPhqTbzdjS2uQegNYa/4S9uek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfRaet7MdnI70uIiSin8EHmOry/R3DlKKFdgrT5cVweUTf790Y8k9fb/cqykuAjGU
	 2U8zyl1iFkq6WvEKjAVxYy6iotfxELrf3obGZns4jfFayKq5JW9pMCHxD9EcCDSV5d
	 x8I1AhvD0H8GdNcv+J/cfAFZeKGu1v3yXkuF/cmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 033/273] ACPICA: debugger: check status of acpi_evaluate_object() in acpi_db_walk_for_fields()
Date: Mon,  8 Apr 2024 14:55:08 +0200
Message-ID: <20240408125310.323850039@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Kiryushin <kiryushin@ancud.ru>

[ Upstream commit 40e2710860e57411ab57a1529c5a2748abbe8a19 ]

ACPICA commit 9061cd9aa131205657c811a52a9f8325a040c6c9

Errors in acpi_evaluate_object() can lead to incorrect state of buffer.

This can lead to access to data in previously ACPI_FREEd buffer and
secondary ACPI_FREE to the same buffer later.

Handle errors in acpi_evaluate_object the same way it is done earlier
with acpi_ns_handle_to_pathname.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://github.com/acpica/acpica/commit/9061cd9a
Fixes: 5fd033288a86 ("ACPICA: debugger: add command to dump all fields of particular subtype")
Signed-off-by: Nikita Kiryushin <kiryushin@ancud.ru>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dbnames.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/dbnames.c b/drivers/acpi/acpica/dbnames.c
index b91155ea9c343..c9131259f717b 100644
--- a/drivers/acpi/acpica/dbnames.c
+++ b/drivers/acpi/acpica/dbnames.c
@@ -550,8 +550,12 @@ acpi_db_walk_for_fields(acpi_handle obj_handle,
 	ACPI_FREE(buffer.pointer);
 
 	buffer.length = ACPI_ALLOCATE_LOCAL_BUFFER;
-	acpi_evaluate_object(obj_handle, NULL, NULL, &buffer);
-
+	status = acpi_evaluate_object(obj_handle, NULL, NULL, &buffer);
+	if (ACPI_FAILURE(status)) {
+		acpi_os_printf("Could Not evaluate object %p\n",
+			       obj_handle);
+		return (AE_OK);
+	}
 	/*
 	 * Since this is a field unit, surround the output in braces
 	 */
-- 
2.43.0



