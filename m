Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E74336EDA;
	Fri,  9 Jan 2026 12:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962060; cv=none; b=F+k34pUYyT80xhyLZqpgZodEwS/J99eJYNWfNVVvx90Lw9RSKOAh17CqmtjXieQPQQpg9aFjTpiINyyiXH8Q4YUjbQDKUJaMztllawt7LVXOGPfrNPSbNt7uwUoS6as9Don7LexUDppq13Sa91l2imYLlOmPOcuz40Ze/B3JoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962060; c=relaxed/simple;
	bh=k7yKEOvFb52R7XsK065fwfK6Ffeg6CY5JKtOnv15zlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pp5OHyuIitfSr09dO9bHUOY4spQXCS9QzhRedGvbZjmXS2YPDtEcI6NchvVL4AmjB3qceSZA8p5BgHkivhh88Vvcx4FQrKfKYjAhub7Rjk80OdgrUBlfMSC3UxQ8sVgGtWGYIm3HBXf5CgS/KWo2UX7h96DqZFHIq55Aw4ZFFcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ0nAbN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ0nAbN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335F0C4CEF1;
	Fri,  9 Jan 2026 12:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962060;
	bh=k7yKEOvFb52R7XsK065fwfK6Ffeg6CY5JKtOnv15zlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ0nAbN8JFG+Esk0mRE0HVE3oeqrI9rHZ+bkg/Tb5LorHAg/+4szU7Hiy0F3DRC8V
	 29GiypfmJ5VTmEGhpwRKAypa5pZA2aHPY6nH+A8xCOq4V99No7zRb4msceIwS+t4Gd
	 lu0P0yZOi7vD8HIY0UtbQz+G8sEduoJ9BgWbGngs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	WangYuli <wangyl5933@chinaunicom.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 232/634] ACPICA: Avoid walking the Namespace if start_node is NULL
Date: Fri,  9 Jan 2026 12:38:30 +0100
Message-ID: <20260109112126.159390795@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>

[ Upstream commit 9d6c58dae8f6590c746ac5d0012ffe14a77539f0 ]

Although commit 0c9992315e73 ("ACPICA: Avoid walking the ACPI Namespace
if it is not there") fixed the situation when both start_node and
acpi_gbl_root_node are NULL, the Linux kernel mainline now still crashed
on Honor Magicbook 14 Pro [1].

That happens due to the access to the member of parent_node in
acpi_ns_get_next_node().  The NULL pointer dereference will always
happen, no matter whether or not the start_node is equal to
ACPI_ROOT_OBJECT, so move the check of start_node being NULL
out of the if block.

Unfortunately, all the attempts to contact Honor have failed, they
refused to provide any technical support for Linux.

The bad DSDT table's dump could be found on GitHub [2].

DMI: HONOR FMB-P/FMB-P-PCB, BIOS 1.13 05/08/2025

Link: https://github.com/acpica/acpica/commit/1c1b57b9eba4554cb132ee658dd942c0210ed20d
Link: https://gist.github.com/Cryolitia/a860ffc97437dcd2cd988371d5b73ed7 [1]
Link: https://github.com/denis-bb/honor-fmb-p-dsdt [2]
Signed-off-by: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Reviewed-by: WangYuli <wangyl5933@chinaunicom.cn>
[ rjw: Subject adjustment, changelog edits ]
Link: https://patch.msgid.link/20251125-acpica-v1-1-99e63b1b25f8@linux.dev
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/nswalk.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/nswalk.c b/drivers/acpi/acpica/nswalk.c
index 82a0dae349e2f..254b0ca0c1540 100644
--- a/drivers/acpi/acpica/nswalk.c
+++ b/drivers/acpi/acpica/nswalk.c
@@ -169,9 +169,12 @@ acpi_ns_walk_namespace(acpi_object_type type,
 
 	if (start_node == ACPI_ROOT_OBJECT) {
 		start_node = acpi_gbl_root_node;
-		if (!start_node) {
-			return_ACPI_STATUS(AE_NO_NAMESPACE);
-		}
+	}
+
+	/* Avoid walking the namespace if the StartNode is NULL */
+
+	if (!start_node) {
+		return_ACPI_STATUS(AE_NO_NAMESPACE);
 	}
 
 	/* Null child means "get first node" */
-- 
2.51.0



