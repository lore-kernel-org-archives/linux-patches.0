Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2644D2EFE;
	Wed, 30 Sep 2026 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784300; cv=none; b=IGug7pWy6qqs0/r8J57BL5XPtfAVFeduWJWmIVO9DoLBvYaofJJZfssQbMJFPAHlFYGBgFhzxdAPX8HEddQlSp6sIgCGin8SnFzwAVRJYFR5aQErnQqhm7qhAbj7+Jle6ndcMzPngTXFyE3h8C7BjW4E62CxIcBnJD1L0viHR7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784300; c=relaxed/simple;
	bh=1BhBcSvmW58/+LXYKkDaNhNvd7xBKuN0XLUOHGle8fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBQ82/6OYokGfJHE38gPgAVMRXSNccg7m+eut45mnLyipGK5F1Ke9iiMwTmWKB9VdpJUZFRgmwWwCLWSh9qhjUP+gYG3TOOS854EMb4pUsD5/WsvOOAU0utAD8HY358lxtykumQIU2ugZLfCQ1EZ4MEptzEBcpNAGWX4qcc0YH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zwc1ymx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zwc1ymx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86081F000FF;
	Wed, 30 Sep 2026 16:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784295;
	bh=xehdT9xe2OfmZS5yebmKngw35AWh8YjeJN9QouU25UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zwc1ymx9YLgBhglPN4xxjkU5e+lPnmfnw/Fo2BWt5Tr6R7J8LQkRo7SJkr7D4ywGi
	 gf+RRU8oeMOM09FMJRBjnJwJIjQYEaLNavYqOZJoWE5ZZVif4rcYqM/RdcEHslEa1e
	 vcbdo9x15Vjy85/47TbejCi2j0gELZzgFI16IXoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ikaros <void0red@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/982] ACPICA: Prevent adding invalid references
Date: Wed, 30 Sep 2026 17:14:00 +0200
Message-ID: <20260930152419.045706619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 63c17f420fb86..9672a776513c2 100644
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



