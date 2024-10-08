Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FEF1DE88F;
	Tue,  8 Oct 2024 13:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392698; cv=none; b=Q8FEFupVZMGuy2MYKBUCP7Nk+U5zpnQ4drhX3EvNMon+npr5Ow1pzLCCYIjJpk+ihj3PgfRVxRwz4WxBaw4adTtDefhRVCCk+B0X+uq6pfmboImwCmWeHA0eeuHg5rjHLaKE3WF3pFOVfZBCCg91ZCmc4eRfXbuBDRg6bJUsoi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392698; c=relaxed/simple;
	bh=nj6crMyt/pxGrVkEzhoSJWsAXr2U3xovQGx3feduQcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EU+ZHw5x3lFUeuqZ6rRcr8ZbJVBbJg+yBa9+AnIs5gwB+n8f0JpT/RhijlL4XG/oCBo0wXCuT3RqtQUgjIWGbthEkrx258LCmxs22MkWj7WlZ1ZFT6t8MLH9avkR9XNF1QoxSrNzTYTNlnHnrTt5CEK9VQnyhk4ZWnxw3H62ams=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sBI5ZnQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sBI5ZnQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE74C4CEC7;
	Tue,  8 Oct 2024 13:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392698;
	bh=nj6crMyt/pxGrVkEzhoSJWsAXr2U3xovQGx3feduQcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sBI5ZnQc0p+rhHJwhzQahHdJ3vqPIY9Ja0Gc2k5rpI/qwVToPPRmv/rJBQCjdttCc
	 5yeggG65iFbzb/uUfCnCuARUZl+0HYrko4XP8H4TYwHBFTlSiml5aGW+kN/elxiOyH
	 G7YyYVjj75+JbpweHDsZGtlC8UKyChnrWc5eWuLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 493/558] ACPI: resource: Loosen the Asus E1404GAB DMI match to also cover the E1404GA
Date: Tue,  8 Oct 2024 14:08:43 +0200
Message-ID: <20241008115721.631995508@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 63539defee17bf0cbd8e24078cf103efee9c6633 upstream.

Like other Asus Vivobooks, the Asus Vivobook Go E1404GA has a DSDT
describing IRQ 1 as ActiveLow, while the kernel overrides to Edge_High.

    $ sudo dmesg | grep DMI:.*BIOS
    [    0.000000] DMI: ASUSTeK COMPUTER INC. Vivobook Go E1404GA_E1404GA/E1404GA, BIOS E1404GA.302 08/23/2023
    $ sudo cp /sys/firmware/acpi/tables/DSDT dsdt.dat
    $ iasl -d dsdt.dat
    $ grep -A 30 PS2K dsdt.dsl | grep IRQ -A 1
                IRQ (Level, ActiveLow, Exclusive, )
                    {1}

There already is an entry in the irq1_level_low_skip_override[] DMI match
table for the "E1404GAB", change this to match on "E1404GA" to cover
the E1404GA model as well (DMI_MATCH() does a substring match).

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219224
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240927141606.66826-2-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -504,10 +504,10 @@ static const struct dmi_system_id irq1_l
 		},
 	},
 	{
-		/* Asus Vivobook Go E1404GAB */
+		/* Asus Vivobook Go E1404GA* */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_BOARD_NAME, "E1404GAB"),
+			DMI_MATCH(DMI_BOARD_NAME, "E1404GA"),
 		},
 	},
 	{


