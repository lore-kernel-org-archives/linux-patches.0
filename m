Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC4269B0E;
	Tue,  8 Apr 2025 12:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114140; cv=none; b=WvIAgqloSQRiqzE+Qi4DPYfAMrmWJYqQ/7/nNZ5GaFrFV8hArk39mdoEqm2OY+XEqpv+GIqZZ8HTU0PtZefF7dDYun+MnWDWvtT0fDm2PoIY5krxVuhyNCk+J5sB/TcZwLeKcKFq7dOeZEtc9gST7kO8wIXCq50hAkpk0kbqWlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114140; c=relaxed/simple;
	bh=wbw7JGLIgXugmeVmRUAStXZ8JKhYKpKRs+Mm277KEjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NfsAbqpX5L61XRe/OUOHWbRVsedIQ/TWilqz4ljfkSonZYQyJawhzFjqDdsi3+PlobuZsQqW5/w0STiBDve5BJf+bd89lKhrpKa/X3l/dLtHVNHA+n5s2+lKQgWHmfkFkGc/11zxrWtxqCon7KDuoD2L0r094/HghBDP+ef2Hv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmfeU99p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmfeU99p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BC6C4CEE5;
	Tue,  8 Apr 2025 12:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114140;
	bh=wbw7JGLIgXugmeVmRUAStXZ8JKhYKpKRs+Mm277KEjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EmfeU99pw34ZvnEo/z1YewWOVsOH0pKDoOzbJaiXWnSIzcLljOwqUk77NXRkzjRM6
	 YAa/yTMsuPL6E9sS6H/2dMJjxe4RIX63kwr+0PA759KTRJ3NozaV/F+ywbzDcimtoZ
	 VmVRgHCyon7GJDea4qzCPMVHOqX6ZrLPkal2jvLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Anton Shyndin <mrcold.il@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 150/154] ACPI: resource: Skip IRQ override on ASUS Vivobook 14 X1404VAP
Date: Tue,  8 Apr 2025 12:51:31 +0200
Message-ID: <20250408104820.103200062@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -443,6 +443,13 @@ static const struct dmi_system_id asus_l
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


