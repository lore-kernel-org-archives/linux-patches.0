Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE8E13AA43;
	Tue, 27 Feb 2024 14:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042931; cv=none; b=EhBvqUV3CXHEpTQcJCd5mduF8cHUP9lMj2hBtf8ns9Zh3cLfsc7tOJbfohbSszqyVklCjM7Z1nY6xoVX7WkD7aQ1pAUMoVarIjog5aC5sKKoTJrztgFI0EOP5mrt7Z+BeCgleXTTosa/CBiRTbJApbTGp3bHY8bP+f8qe9i0sro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042931; c=relaxed/simple;
	bh=c169iZOpKzRN1Wi9qGwhR9fiUDzIcK5J8AOsA7gBUrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLbmcTAX+nAbPz6IXVZYH3BG7MPVqPA+LYYglASh3sPOZuHBV/Wa0YG5HKWULV7+Yq2QYH3Di4zQvdjjMZjs2N49m3AWvfarpWVdGTwSDkzQhwCkea9bJlliUPCDj5lu+nDPLWaj6IPKnlW+gRnjrPbzRYLq1uhJ2QVn6kDwImE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7QdD4NE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7QdD4NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C01C433C7;
	Tue, 27 Feb 2024 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042931;
	bh=c169iZOpKzRN1Wi9qGwhR9fiUDzIcK5J8AOsA7gBUrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7QdD4NEI2ll5fbt54huSFUQ4+cHBnb16SsrWIiHGHTAV2BhHV86bn+gFE72xkUoV
	 bWwvaCgT8OqsYNEQIYf80TGNOy9d52kKAsb48EpW4qvNI4OYPI7sIZnb4Z3pxhd+LA
	 qTcElR5SiMsyO/WukW/3NNyha9fb1pH4VwUAh5ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/245] ACPI: video: Add backlight=native DMI quirk for Apple iMac11,3
Date: Tue, 27 Feb 2024 14:26:00 +0100
Message-ID: <20240227131620.796234774@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 48436f2e9834b46b47b038b605c8142a1c07bc85 ]

Linux defaults to picking the non-working ACPI video backlight interface
on the Apple iMac11,3 .

Add a DMI quirk to pick the working native radeon_bl0 interface instead.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: bd5d93df86a7 ("ACPI: video: Add backlight=native DMI quirk for Lenovo ThinkPad X131e (3371 AMD version)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 5afc42d52e49b..be923911e87c1 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -341,6 +341,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "82BK"),
 		},
 	},
+	{
+	 .callback = video_detect_force_native,
+	 /* Apple iMac11,3 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "iMac11,3"),
+		},
+	},
 	{
 	 /* https://bugzilla.redhat.com/show_bug.cgi?id=1217249 */
 	 .callback = video_detect_force_native,
-- 
2.43.0



