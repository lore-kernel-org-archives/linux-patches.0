Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261707E0F3;
	Mon,  8 Apr 2024 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585052; cv=none; b=P02U4Of+wxvwOYHfPawuUaPY2GdOQEmgQzBdBreN4K05oIQSN87W+Xyb4u7VV3+YseDK7j/vyxPEb7p11gWKnbuEbky9wtpqKitv798orqmjygVd9lpeLinQMd8Hg8CgTGVKNbAadRi7Z2kfyklS+Wa6ddzXG2/H1O9q6Udr0kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585052; c=relaxed/simple;
	bh=pN1P/vKXqpeiAGKlrO8EmxKX6uRaVm3LGP7+tmfcDR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO13nwiMYv3ZIEGLWkE4t40R/dnaAG4R4sLyXOM8Jpa9X9d9Dkfc6l4qAR0cTJe3mdjxsL++pBhbu8Ky2ktpDTshKVYjtuoYVWSwDw45yos92p7SpUDA0jigQm6nhyhQlQJoejxtCo8Ykg5qbR5GL9Vc29y0o+EHqvnIq3gMeF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UimtgBVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UimtgBVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E39C433C7;
	Mon,  8 Apr 2024 14:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585052;
	bh=pN1P/vKXqpeiAGKlrO8EmxKX6uRaVm3LGP7+tmfcDR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UimtgBVVjrPZdvMkUdQ8Y4nGjxNsFYY96j79s37NhCczvrMBymIBKIWRJaq1EBWoM
	 0tyGc2YjyNA1/WpiPlDhgyvWfNdEah5XVo99KirgXJ3eAefj/NKAit6/Pp1yrkiChC
	 rN0g7rF8+DsnAx5XKbsHICagxICB3hUcZyq/AgOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Kiryushin <kiryushin@ancud.ru>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 616/690] ACPICA: debugger: check status of acpi_evaluate_object() in acpi_db_walk_for_fields()
Date: Mon,  8 Apr 2024 14:58:02 +0200
Message-ID: <20240408125421.926350670@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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



