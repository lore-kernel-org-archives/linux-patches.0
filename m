Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD46F2D7380;
	Tue, 13 Oct 2026 12:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893475; cv=none; b=D/Psxibbuxw7kUCfpQYxnyvh+AsdQ4XjahbnVnSV6OylrLwgJJqiuQJJjeQCt4vZbC6fFRulnL9D4WR0zohA6nTtjZZkCpfLY2K/BR2h3QOxvCfg0qN5LtBaP/xXKLAD1RGrYEt7lj/v5gSHtCY8exr/GuLEUsNfYgXbiJKnbds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893475; c=relaxed/simple;
	bh=DjPEWmd/rJyqHF/FKAlfAPo83+aB2k7YOmrGxhCkotg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM80XMTX4TXLqQnUvb/t7dhWAk/TKx++bik0R02slvRtshlRhGcz06RwMciPNSRQawwdZfk9VbAwJjNLRtJM9FbpJVSKKds0k0ufqcuQKlolIZcqoSLK5kxqWUDDEk1/BziqSeTwxgmXG93F21XDu4TvhC5W8TXhxiBY5ejxZoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtSip5tz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtSip5tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24DBA1F000FF;
	Tue, 13 Oct 2026 12:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893474;
	bh=hLfZgEHqvF+CJCNDvaQbti573u/BUxVO9kpOmsxYowQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtSip5tznWembnq0BjDxFYN2zd9rO1F6deJsu+dG+/1kq8420+1o4jMvqCvSABgOY
	 5hyde5GUrQToe15jcjn2qbM/tniiCedaL+Z42qUPKmW8e0klVnSMCoXfYzdKysuVw0
	 Hjwcpk1c9r44wFEsCamb6GTI13qJunCpB4PoAJbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 237/621] ACPI: button: Tweak acpi_button_remove()
Date: Tue, 13 Oct 2026 13:33:52 +0200
Message-ID: <20261013112926.481848344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 1abdf9e7967f154b3d4bfe0681dd38b8e036ee63 ]

Modify acpi_button_remove() to get the ACPI device object pointer
from button->adev instead of retrieving it with the help of the
ACPI_COMPANION() macro to reduce overhead slightly.

While at it, rename the struct acpi_device pointer variable in
acpi_button_remove() to adev.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/13948466.uLZWGnKmhe@rafael.j.wysocki
Stable-dep-of: fe80251152fe ("ACPI: button: Fix ACPI GPE handler leak during removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index b899b8745fedd..63beaeb9f7cc7 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -670,10 +670,10 @@ static int acpi_button_probe(struct platform_device *pdev)
 
 static void acpi_button_remove(struct platform_device *pdev)
 {
-	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
 	struct acpi_button *button = platform_get_drvdata(pdev);
+	struct acpi_device *adev = button->adev;
 
-	switch (device->device_type) {
+	switch (adev->device_type) {
 	case ACPI_BUS_TYPE_POWER_BUTTON:
 		acpi_remove_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
 						acpi_button_event);
@@ -683,7 +683,7 @@ static void acpi_button_remove(struct platform_device *pdev)
 						acpi_button_event);
 		break;
 	default:
-		acpi_remove_notify_handler(device->handle, ACPI_DEVICE_NOTIFY,
+		acpi_remove_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
 					   button->type == ACPI_BUTTON_TYPE_LID ?
 						acpi_lid_notify :
 						acpi_button_notify);
-- 
2.53.0



