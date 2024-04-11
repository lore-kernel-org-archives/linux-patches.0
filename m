Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0DF1474A8;
	Thu, 11 Apr 2024 10:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831983; cv=none; b=TVasDwb2expSiqCWR2QOyirZihWV1rCmSPAzKfWLoWYmbW25O7kUxoBq8exsBshCf+I+owiwPEz5i3MD8CY8p6oVR4eIf3LxVyZrjoAvgMz+EUjImOQ33sZ+jtjrvHjD28NJ99npXj5heVPD2eFWUxrWBWiaBrsEuylg4OzBzCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831983; c=relaxed/simple;
	bh=E+fVjRU2DKYAgJz4dnaYI9bha3HV6L6ZpOdn6XNLh18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keu7S1KmXKYWgSowQhY+WqPUYlAiU8UsOUQ6f1ZKXr015H+yDScm6gXBb9LuQhWlH9XgCYWn9gVEOxzpyYQbbVFIjVnC3CT07s+JOlnPRhm+gJNi/1fSaMC383XAiVPmDJ22REuW2oQUBnpWok9FRADH7YJeXq1BXBPOF9Y2fBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNXZGeUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNXZGeUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059D6C433C7;
	Thu, 11 Apr 2024 10:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831983;
	bh=E+fVjRU2DKYAgJz4dnaYI9bha3HV6L6ZpOdn6XNLh18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNXZGeUCtNjeVVE3lHmGQRGQuFFIVYOMmDrcD84k6x//8EtRi83eYWoAQgTSh4LlC
	 +YpHXNHxXq7XoNFEBI6fcRCU4kX4rlXUexVleyt12f3h4eDvnzaRZUl+4v4uT9EZ5j
	 WzRhxKma2gvuCcBEhQ2l5op2nuqEEqqMJ/Ebj9To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 185/294] ACPICA: debugger: check status of acpi_evaluate_object() in acpi_db_walk_for_fields()
Date: Thu, 11 Apr 2024 11:55:48 +0200
Message-ID: <20240411095441.190190652@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



