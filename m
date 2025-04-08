Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B52F26F478;
	Tue,  8 Apr 2025 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117075; cv=none; b=VdiCyCVwfTdaVm+VxL52x7OqG6HYw4pppOkws43WvCXL9ZmhPelVE8AtYgC5N10Plrl0bSc9JcOxZx82c3jJoWjRgOgTY633znI2Icf/o/23EQpQt9FZKoiMdV1qSPcrwRPWbV+c5FyC3SPUvlVF4b21K5rv/wHBy84Kk3VEs6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117075; c=relaxed/simple;
	bh=EBXshOUZGGscoNQX4fR/TMp34rvcEz3UrlJWnwxXzDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qmhd1o5WhD5mbxaKY2FOte82fS5b/k9yjwYvgxvhn0axCY+hJrvtSxsQVexNZIKV4jfLnepdbib+PTKToTBvCFhHvza2TDKmkRSYLynYn20sTmaDAGMJzL8a3vBt6ayBvodboRWp1vuQ8wJyeKehGhyqBlHLhi2wrF/aAn+K9zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUC3Ahnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUC3Ahnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3F9C4CEE5;
	Tue,  8 Apr 2025 12:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117074;
	bh=EBXshOUZGGscoNQX4fR/TMp34rvcEz3UrlJWnwxXzDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUC3AhnchrbPr4/Zxo8flY+Ypl7lxYYh0wWW2m7baQ/9KIKye6+SL49/LDotQTFHM
	 9Wn/y0uVttsdiz8GuwZQr3VS4yPynR9emfim9CSZy+Uskmh34pwubHpLgIO0OYtQeb
	 jle0GcIV7plqj+3E+ZXyjcDs7PnDmG/VfdwJU510=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Holer <vlastimil.holer@gmail.com>,
	Alireza Elikahi <scr0lll0ck1s4b0v3h0m3k3y@gmail.com>,
	Kurt Borja <kuurtb@gmail.com>,
	Eduard Christian Dumitrescu <eduard.c.dumitrescu@gmail.com>,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 374/423] platform/x86: thinkpad_acpi: disable ACPI fan access for T495* and E560
Date: Tue,  8 Apr 2025 12:51:40 +0200
Message-ID: <20250408104854.582676323@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Christian Dumitrescu <eduard.c.dumitrescu@gmail.com>

commit 2b9f84e7dc863afd63357b867cea246aeedda036 upstream.

T495, T495s, and E560 laptops have the FANG+FANW ACPI methods
(therefore fang_handle and fanw_handle are not NULL) but they do not
actually work, which results in a "No such device or address" error.
The DSDT table code for the FANG+FANW methods doesn't seem to do
anything special regarding the fan being secondary. The bug was
introduced in commit 57d0557dfa49 ("platform/x86: thinkpad_acpi: Add
Thinkpad Edge E531 fan support"), which added a new fan control method
via the FANG+FANW ACPI methods.

Add a quirk for T495, T495s, and E560 to avoid the FANG+FANW methods.
Fan access and control is restored after forcing the legacy non-ACPI
fan control method by setting both fang_handle and fanw_handle to NULL.

Reported-by: Vlastimil Holer <vlastimil.holer@gmail.com>
Fixes: 57d0557dfa49 ("platform/x86: thinkpad_acpi: Add Thinkpad Edge E531 fan support")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219643
Cc: stable@vger.kernel.org
Tested-by: Alireza Elikahi <scr0lll0ck1s4b0v3h0m3k3y@gmail.com>
Reviewed-by: Kurt Borja <kuurtb@gmail.com>
Signed-off-by: Eduard Christian Dumitrescu <eduard.c.dumitrescu@gmail.com>
Co-developed-by: Seyediman Seyedarab <ImanDevel@gmail.com>
Signed-off-by: Seyediman Seyedarab <ImanDevel@gmail.com>
Link: https://lore.kernel.org/r/20250324152442.106113-1-ImanDevel@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8795,6 +8795,7 @@ static const struct attribute_group fan_
 #define TPACPI_FAN_NS		0x0010		/* For EC with non-Standard register addresses */
 #define TPACPI_FAN_DECRPM	0x0020		/* For ECFW's with RPM in register as decimal */
 #define TPACPI_FAN_TPR		0x0040		/* Fan speed is in Ticks Per Revolution */
+#define TPACPI_FAN_NOACPI	0x0080		/* Don't use ACPI methods even if detected */
 
 static const struct tpacpi_quirk fan_quirk_table[] __initconst = {
 	TPACPI_QEC_IBM('1', 'Y', TPACPI_FAN_Q1),
@@ -8825,6 +8826,9 @@ static const struct tpacpi_quirk fan_qui
 	TPACPI_Q_LNV3('N', '1', 'O', TPACPI_FAN_NOFAN),	/* X1 Tablet (2nd gen) */
 	TPACPI_Q_LNV3('R', '0', 'Q', TPACPI_FAN_DECRPM),/* L480 */
 	TPACPI_Q_LNV('8', 'F', TPACPI_FAN_TPR),		/* ThinkPad x120e */
+	TPACPI_Q_LNV3('R', '0', '0', TPACPI_FAN_NOACPI),/* E560 */
+	TPACPI_Q_LNV3('R', '1', '2', TPACPI_FAN_NOACPI),/* T495 */
+	TPACPI_Q_LNV3('R', '1', '3', TPACPI_FAN_NOACPI),/* T495s */
 };
 
 static int __init fan_init(struct ibm_init_struct *iibm)
@@ -8876,6 +8880,13 @@ static int __init fan_init(struct ibm_in
 		tp_features.fan_ctrl_status_undef = 1;
 	}
 
+	if (quirks & TPACPI_FAN_NOACPI) {
+		/* E560, T495, T495s */
+		pr_info("Ignoring buggy ACPI fan access method\n");
+		fang_handle = NULL;
+		fanw_handle = NULL;
+	}
+
 	if (gfan_handle) {
 		/* 570, 600e/x, 770e, 770x */
 		fan_status_access_mode = TPACPI_FAN_RD_ACPI_GFAN;


