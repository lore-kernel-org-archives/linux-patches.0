Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E399421FF4B;
	Mon, 18 Aug 2025 13:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524755; cv=none; b=azMRdCz8zmGb2UgjT1s+1qIQlEMIDNpqfKOlO71VQvOzTiCYafCumNfEbEsPwwJAKZHVv1E6xNSkFV3QQ6M7pMM94a4GtsLlv5CMmDpIKcQ4O6gQZ0gjmMK/shcSWOYxBAdkY0ekEduSfXkjznJZCYepNxHxhWnpZPloLlk7mjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524755; c=relaxed/simple;
	bh=FpOvzk+4ALntbWidujc49mkUd0hVyCzH+oHa5DbNETQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCIpgu9vqvZkBRTGJJpUyM+feuEVQCiFrn8Wf/pS+xclKgFrVf//Ctl+eEixgIi+rcmK2yJv3ac5MNB3RzlS2D7cdnF3x7UbxzzA91EdmaDJuLFj6Pau1LV4kZcx5lZdKqhU0PZfd+4nahmNt+AZ3oB6o3qiT0tB4tpU8+cBoCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mr6icTv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mr6icTv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D7CC4CEEB;
	Mon, 18 Aug 2025 13:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524754;
	bh=FpOvzk+4ALntbWidujc49mkUd0hVyCzH+oHa5DbNETQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mr6icTv0GH5/+oGNs1b2TtIxgtdKLzxNCECBoIb/MD2pKNQVsoj0JO2erdDlSk/Xr
	 9oJSlsPRfw/fP/NTgtIJVjx2yohl2OkTfxLosOuGHtUbUopAu/E6phQwq7/dFXouNW
	 GdRN0gJW87xwipin5VDgYLT1RbZ+ndtAQO6gkCnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya K <me@0upti.me>,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.16 052/570] ACPI: EC: Relax sanity check of the ECDT ID string
Date: Mon, 18 Aug 2025 14:40:39 +0200
Message-ID: <20250818124507.819515773@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit 963e22c084c2b6097e1e635d29c6336881f67708 upstream.

It turns out that the ECDT table inside the ThinkBook 14 G7 IML
contains a valid EC description but an invalid ID string
("_SB.PC00.LPCB.EC0"). Ignoring this ECDT based on the invalid
ID string prevents the kernel from detecting the built-in touchpad,
so relax the sanity check of the ID string and only reject ECDTs
with empty ID strings.

Reported-by: Ilya K <me@0upti.me>
Fixes: 7a0d59f6a913 ("ACPI: EC: Ignore ECDT tables with an invalid ID string")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Tested-by: Ilya K <me@0upti.me>
Link: https://patch.msgid.link/20250729062038.303734-1-W_Armin@gmx.de
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 75c7db8b156a..7855bbf752b1 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2033,7 +2033,7 @@ void __init acpi_ec_ecdt_probe(void)
 		goto out;
 	}
 
-	if (!strstarts(ecdt_ptr->id, "\\")) {
+	if (!strlen(ecdt_ptr->id)) {
 		/*
 		 * The ECDT table on some MSI notebooks contains invalid data, together
 		 * with an empty ID string ("").
@@ -2042,9 +2042,13 @@ void __init acpi_ec_ecdt_probe(void)
 		 * a "fully qualified reference to the (...) embedded controller device",
 		 * so this string always has to start with a backslash.
 		 *
-		 * By verifying this we can avoid such faulty ECDT tables in a safe way.
+		 * However some ThinkBook machines have a ECDT table with a valid EC
+		 * description but an invalid ID string ("_SB.PC00.LPCB.EC0").
+		 *
+		 * Because of this we only check if the ID string is empty in order to
+		 * avoid the obvious cases.
 		 */
-		pr_err(FW_BUG "Ignoring ECDT due to invalid ID string \"%s\"\n", ecdt_ptr->id);
+		pr_err(FW_BUG "Ignoring ECDT due to empty ID string\n");
 		goto out;
 	}
 
-- 
2.50.1



