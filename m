Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253AE36B912;
	Wed, 30 Sep 2026 18:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794184; cv=none; b=XSxchDeeFeUJwWApqx4vmPcHdr3GGLzwtn11+BFBjfz8SDWmwFb/wn6xNK/VmRCe1lP1czz/m2nyP7YRUeP1/UNXBE+69DVAIoh0dyDlpiH47Ga19WBXdQwkWBIGjD9F37cs1jWNos1ac/YpXVaGPmCtsN6wFjX/KeBza2zGrmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794184; c=relaxed/simple;
	bh=yVMk+e5PSgpVho90NoaNDBiIN0ECeFttDCvgulSXkJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOHWk4llG1sTLtK+d2m7Y3TxFmYeIeAE+U3D7mVltz9kmzVQ7qfV7NgwvAp5W7HzZXR1vUPntGIZ1SVfHUn6QW1JyRorGW/aWTi9QsFaIgENUQShQ3vsLjFloqO+NqIN5UJTQFLLzKHuTUaENC5bmERL7We2ZLAEBr5iFK062IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0gZhNoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0gZhNoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9581F000FF;
	Wed, 30 Sep 2026 18:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794182;
	bh=qh4QVKjP7E5/ERKwMjjEsUmlYgoCe8CZC19xrENHv9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0gZhNoi/4c6+7vv+1+1N6b3X7+nmmiXuUJ/KCaEqtzooQcNnpJmY0sa/oapT8jKY
	 0tmJGcJ7hYXb9Y7vK5NwupWN1P4bIIYtYayEDMvX2/QzTorykRpBpMwFoqk/Xq7T+S
	 ZjSiu4xoP51L15CJGAsaxDG1q0pk4W/kCSo6V7wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0121/1193] ACPICA: Prevent adding invalid references
Date: Wed, 30 Sep 2026 17:13:25 +0200
Message-ID: <20260930152436.910395999@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2e17e657dfa45..36f85c802d126 100644
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



