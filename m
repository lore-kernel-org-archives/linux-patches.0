Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6187817B4EC;
	Tue,  8 Oct 2024 12:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389888; cv=none; b=Ac2UWzT85W1IvqGigF3U0bZMou9AUVK9lWu3Qzq8FKKRV8jNynVipUw0CaFWWF0lyxNxiqwiOYT3J+l0hnTbPtqRIlKRi1Y28FjMBmgnW1NgCXpv4vyxSyZKyjSMj6NqFfvv3zHizFepdH9wZw2IS0bb0OqEFoCcYhNiguqAOXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389888; c=relaxed/simple;
	bh=71n+qRQgogkc1TVTLmQF6XDL3qR5go+0RorX1Sp8WgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGv4lK29T7a0xM/p3KJtvWzyqTWvboxsNEy7FvD200mEfctNrNlYc2T+xSi08IMwQ3I1daXeW/Aldk7bsFOrReNYuCGzdHu7awwLEfQRMPpIZAsz8k3tBxlFnKbqdf+TaU3arkQWepFJPgIk9lNLwbzEI3OgwMadqXdoA5FSqhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rmYFa28E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rmYFa28E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C3BC4CEC7;
	Tue,  8 Oct 2024 12:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389888;
	bh=71n+qRQgogkc1TVTLmQF6XDL3qR5go+0RorX1Sp8WgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rmYFa28E4rXef+zVHGKmHTADemb9xhCrmazd2+MDutFWyZZ+S1djb6b1oEFse6kHi
	 N0liF/BAede16niortQYOjajN3prztoj4fPdmem1VCEv6jaQmJ/81qHpctrpn5qMCQ
	 Qfr1jAJj6BXl7Lv4VR7OG3AHHEj7cUYuBLZIMUi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 095/482] ACPI: video: Add force_vendor quirk for Panasonic Toughbook CF-18
Date: Tue,  8 Oct 2024 14:02:38 +0200
Message-ID: <20241008115652.049621206@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit eb7b0f12e13ba99e64e3a690c2166895ed63b437 ]

The Panasonic Toughbook CF-18 advertises both native and vendor backlight
control interfaces. But only the vendor one actually works.

acpi_video_get_backlight_type() will pick the non working native backlight
by default, add a quirk to select the working vendor backlight instead.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20240907124419.21195-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 75a5f559402f8..428a7399fe04a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -254,6 +254,14 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "PCG-FRV35"),
 		},
 	},
+	{
+	 .callback = video_detect_force_vendor,
+	 /* Panasonic Toughbook CF-18 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Matsushita Electric Industrial"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "CF-18"),
+		},
+	},
 
 	/*
 	 * Toshiba models with Transflective display, these need to use
-- 
2.43.0



