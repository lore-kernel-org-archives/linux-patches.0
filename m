Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319094F68C8;
	Thu, 17 Sep 2026 17:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667659; cv=none; b=O0zUl/5VdXfT1k8mgVfOFrAjt94rIT3cYp1HkjdoQI8PwmFj/uAmFrbAocyKyjge0mGA7x/RYu6Mr+Q3lCaqO44wAXfuIewyNaqLt/RkfmRsv6YwwnJH0WXsLCn9AVPQcjYHxYiIrdy21HqZke/mla7qwLrIKBqlG8UREsI+J1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667659; c=relaxed/simple;
	bh=oY0+kRDFiJ6OE8ZNP/N91mDtr9bB5LLEgC6y1zcBhlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2LTI8stItOFBpABCgmdLvfJfPWXxzK1MJcX+s2wOKDBhApnKhquMFHIX3Zg0UbBmwa6VxyciS9ly8T6uuklQVXCN36FEagMNH9CU1hr+2W2n9J9B4efudGOMQt+ZPULiItTn68vmugzF9WUdYg0+jEnMdFYMooHPOR265yVCvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tn9rcvi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tn9rcvi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0AA1F000FF;
	Thu, 17 Sep 2026 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667658;
	bh=NkS+p7ak+EuRN7m5TmodKA5eBIV6Smm+5+fOv3ni7OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tn9rcvi2AHAbrmbh6DUSWJFLcgW1fOmDtnlaLzewzqLMXxa6FBgO/QrwcN4iic/nw
	 Rn9rmylHl4+VJ5/B+LHVBXpAdsjPiRAXJvjBddfM+SeJA/hFqsURlGVDx6XYolOUk3
	 FtC+BRFz5BCK0o77+4iA2pSKVYbSiYjFPoK6TB1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0165/1102] ACPICA: Prevent adding invalid references
Date: Thu, 17 Sep 2026 16:01:48 +0100
Message-ID: <20260917151543.682417076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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



