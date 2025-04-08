Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0992626B97E;
	Tue,  8 Apr 2025 12:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116008; cv=none; b=dxl/X9FbioH7rLk3Tz12+ztlOFQcbqHXylN1kk+NT+P54gCmAFsVZzFY24R9KE3JAmOpHowDgmaJ+iz4oNQZ+Ojx9ws6fVWNMQ4pAAXTn63VzpiTZRSqdp1xlerXf7BkyVkIMtO9HvaMAVMmlVxqFs/zjyQseSiGY/ELcuLMPwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116008; c=relaxed/simple;
	bh=rlginEH5PnJHnxvz3Qc1SV5jT+bn0FekBevDzUA6ay4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dTnbLRh88mYO/fPVb8pwjF2UDDIkwwFC+FDwNyD8F2iXpLwgWNDc/N00LlPOs4BqbZ1unkJAFZAoOYla3FxF7QO+ZPDKefqvJ/og2j5jBTn6SfQolWqIfGPktjPdbDsOZU8sX8FnDtq+0jwOZIshIS0HUlrJjW/NMgQEN6dK0XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Enak57rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Enak57rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9AEC4CEE5;
	Tue,  8 Apr 2025 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116007;
	bh=rlginEH5PnJHnxvz3Qc1SV5jT+bn0FekBevDzUA6ay4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Enak57rFQEb7X68y7y+vph/eDDkqGE1iiOjgxwcXTQlEvn6l7pNOHyM8ujzeoh7DQ
	 2aIgXLxFzlZ5mEVvrZNNFGBdMyPyWUmzDWAXEZZrXzuPeGYLmlv4Wz6yx1NaM0iGBy
	 iKHTFMuizxQIM1ynbtFcuD5yN398dt/o2M85F06Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Anton Shyndin <mrcold.il@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 186/204] ACPI: resource: Skip IRQ override on ASUS Vivobook 14 X1404VAP
Date: Tue,  8 Apr 2025 12:51:56 +0200
Message-ID: <20250408104825.773947575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

commit 2da31ea2a085cd189857f2db0f7b78d0162db87a upstream.

Like the ASUS Vivobook X1504VAP and Vivobook X1704VAP, the ASUS Vivobook 14
X1404VAP has its keyboard IRQ (1) described as ActiveLow in the DSDT, which
the kernel overrides to EdgeHigh breaking the keyboard.

    $ sudo dmidecode
    […]
    System Information
            Manufacturer: ASUSTeK COMPUTER INC.
            Product Name: ASUS Vivobook 14 X1404VAP_X1404VA
    […]
    $ grep -A 30 PS2K dsdt.dsl | grep IRQ -A 1
                 IRQ (Level, ActiveLow, Exclusive, )
                     {1}

Add the X1404VAP to the irq1_level_low_skip_override[] quirk table to fix
this.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219224
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Anton Shyndin <mrcold.il@gmail.com>
Link: https://patch.msgid.link/20250318160903.77107-1-pmenzel@molgen.mpg.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -440,6 +440,13 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		/* Asus Vivobook X1404VAP */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "X1404VAP"),
+		},
+	},
+	{
 		/* Asus Vivobook X1504VAP */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),


