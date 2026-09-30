Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49ED252120A;
	Wed, 30 Sep 2026 17:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790933; cv=none; b=rXhUHJdOpJ+17Wej4CaXAVOCY56N6QigEwo03wqm3m0//JqBBoknk80p6zxmKFExLaYPt7IbQZ6U8LntXj6JfY9IBb+9HqN90uGISHdhdP7gHjc1S3+Qyl8AENI/A+pc5LSbi9+1p/ua7WoIGr1zMBp+Mui+/ur6vT4H+jX1jzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790933; c=relaxed/simple;
	bh=xSjtcp0nRYEsCYqwvPOsDgsmhsJrFVNO/TukAaVz8X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNyLRl2fwFFM+CsfxAgxyFfk1G2O600ZFM6+2e5k8oz3u6Xo/uGzuiVZ6oZBamwYleQ+/Nv5/KeV0eJRzqiV6/6O5PtVGOtVYcN6jQcrA32r7emPiEO8VYqUxO6hx7nd3cXwSitEUmQCFye8eek+ivi8MkoPe0SoiY9x1RzInhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZ2iuR6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZ2iuR6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BEC1F00898;
	Wed, 30 Sep 2026 17:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790932;
	bh=A4h1u2VRLL8V3UtKa9bi6MnXxTLteQ4kndXBVpydoHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZ2iuR6GV5qZQJXXsXQNEtXvVtpyONoZaLYw3QTNVUnOhINnTIv4yUpjWqkL9FxHr
	 jk3GwsyiUWuFORbDtMg4iXPz29xs3RFtmrJigiPXVsuuog6ksXHu0yZcQOIP3rjfHP
	 b29oXqWJ6l4w34zToKp+5UQNgj6r6L/z6tAuxsG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/752] ACPICA: Prevent adding invalid references
Date: Wed, 30 Sep 2026 17:19:10 +0200
Message-ID: <20260930152359.898036839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fdd503bb69c47..133770b3c18d2 100644
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



