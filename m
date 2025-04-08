Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D63227BA4;
	Tue,  8 Apr 2025 12:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115397; cv=none; b=hu5vtNYJLgp4ZkPzALXMVhGDKmir+H9X4WBhCxtptWPOdXD0aoEitlqW8cXVkq7B5y4C8zn+nGHnktjVMR0tTRCS7x3FOapRKNxGbxnZ3311NK7T6J1jvCUX3I78S5HIvNCsQMKCRhBvz16vAgo2J4B/qb0pW4WuCLXL79neEqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115397; c=relaxed/simple;
	bh=Rkp5gXFPTRweu9va1/UdAWPzpIyuGsoRd0M3guCVeiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AB14ylfljTZyZZvVF5QTJk3ieQqEvrvVsaMGIF8TjFdg1MttRlH4izxmUmQNOWaM/e2DZMK8S0DyoaoDmXhxpDdPe2YJTqyjRkN1soEM8bnVcBHsjc6xj43OwXuH8GGE07u0E6jdzxifBF7wXJnzVwSZ1x5A9wssaugtuH4ZA1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gsg+mk1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gsg+mk1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99224C4CEE5;
	Tue,  8 Apr 2025 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115397;
	bh=Rkp5gXFPTRweu9va1/UdAWPzpIyuGsoRd0M3guCVeiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gsg+mk1ztlCForamGriqHEn1NaLiMkrrCRh8ryPMsxi8SHAHokmJjdBoLGjNIbnxm
	 tvw68d3Abyfj/qp3cIit9YgBYCjjPa3SoX7oJHi+odvvSRZqJPjDuwgEcQzfyhGBQH
	 Mu1IAq8yVv02Zf/S4fsJysLLR6dQEwKA0AaOW0i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Hans de Goede <hdegoede@redhat.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.13 458/499] ACPI: video: Handle fetching EDID as ACPI_TYPE_PACKAGE
Date: Tue,  8 Apr 2025 12:51:10 +0200
Message-ID: <20250408104902.659153666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

commit ebca08fef88febdb0a898cefa7c99b9e25b3a984 upstream.

The _DDC method should return a buffer, or an integer in case of an error.
But some Lenovo laptops incorrectly return EDID as buffer in ACPI package.

Calling _DDC generates this ACPI Warning:
ACPI Warning: \_SB.PCI0.GP17.VGA.LCD._DDC: Return type mismatch - \
found Package, expected Integer/Buffer (20240827/nspredef-254)

Use the first element of the package to get the EDID buffer.

The DSDT:

Name (AUOP, Package (0x01)
{
	Buffer (0x80)
	{
	...
	}
})

...

Method (_DDC, 1, NotSerialized)  // _DDC: Display Data Current
{
	If ((PAID == AUID))
        {
		Return (AUOP) /* \_SB_.PCI0.GP17.VGA_.LCD_.AUOP */
	}
	ElseIf ((PAID == IVID))
	{
		Return (IVOP) /* \_SB_.PCI0.GP17.VGA_.LCD_.IVOP */
	}
	ElseIf ((PAID == BOID))
	{
		Return (BOEP) /* \_SB_.PCI0.GP17.VGA_.LCD_.BOEP */
	}
	ElseIf ((PAID == SAID))
	{
		Return (SUNG) /* \_SB_.PCI0.GP17.VGA_.LCD_.SUNG */
	}

	Return (Zero)
}

Link: https://uefi.org/htmlspecs/ACPI_Spec_6_4_html/Apx_B_Video_Extensions/output-device-specific-methods.html#ddc-return-the-edid-for-this-device
Cc: stable@vger.kernel.org
Fixes: c6a837088bed ("drm/amd/display: Fetch the EDID from _DDC if available for eDP")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4085
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/61c3df83ab73aba0bc7a941a443cd7faf4cf7fb0.1743195250.git.soyer@irl.hu
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_video.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -648,6 +648,13 @@ acpi_video_device_EDID(struct acpi_video
 
 	obj = buffer.pointer;
 
+	/*
+	 * Some buggy implementations incorrectly return the EDID buffer in an ACPI package.
+	 * In this case, extract the buffer from the package.
+	 */
+	if (obj && obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 1)
+		obj = &obj->package.elements[0];
+
 	if (obj && obj->type == ACPI_TYPE_BUFFER) {
 		*edid = kmemdup(obj->buffer.pointer, obj->buffer.length, GFP_KERNEL);
 		ret = *edid ? obj->buffer.length : -ENOMEM;
@@ -657,7 +664,7 @@ acpi_video_device_EDID(struct acpi_video
 		ret = -EFAULT;
 	}
 
-	kfree(obj);
+	kfree(buffer.pointer);
 	return ret;
 }
 


