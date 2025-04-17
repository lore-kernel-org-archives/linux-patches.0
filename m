Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84841254AED;
	Thu, 17 Apr 2025 18:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915258; cv=none; b=UFnevxPzFLcWsOKhw02fUetav+QVhXmoiFwToLWWmwclJCigFxx03vMCzPrZuHkbp22a/Z/oo+wg4N/C1lNPlP2oMSPkf+XSJwmuqge3oepiaRR1FuHNcD56cCRtFCWx8taXbBx8c/natiGn3tncb00YqpdqB6uFAIYmCg3mMWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915258; c=relaxed/simple;
	bh=3rtnhPpvymL/9G61A9A4AswbOk5e06YtOB2jSB0noJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iJQo4nal5hNyecmeJINaiSJIxptZjKcwAwOXfeWLh5SCRtQyrPNEhT3GqVD+hYVEl8vykdsutT4dQ5+PG6TUkgQrQ4ZV0NxwkOmNRGg1zuMVKdvkkPNrEeIdD8JBih1BQmP9er86YdHgqImgNdEPBXpIcska1qThy03o8TH+5oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUBHaXeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUBHaXeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3219C4CEE7;
	Thu, 17 Apr 2025 18:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915258;
	bh=3rtnhPpvymL/9G61A9A4AswbOk5e06YtOB2jSB0noJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUBHaXeTGOtiz3sSRby8Slyzn7jlDAxm8wW6JovmYbafne24zCL+GD2CEDYCCJhAJ
	 UP2iimA8EwyT26JnfkpnS+iMAEuZzJGi7/GzC5oE38+mcai8aPb1efGQqLyhu9RBln
	 HG4OxkzcUGTV5ACFGMDqL1HhmaFEJ2tE7Vdx5tZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nolan Nicholson <nolananicholson@gmail.com>,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/393] HID: pidff: Fix null pointer dereference in pidff_find_fields
Date: Thu, 17 Apr 2025 19:47:59 +0200
Message-ID: <20250417175110.408870269@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Tomasz Pakuła <forest10pl@gmail.com>

[ Upstream commit 22a05462c3d0eee15154faf8d13c49e6295270a5 ]

This function triggered a null pointer dereference if used to search for
a report that isn't implemented on the device. This happened both for
optional and required reports alike.

The same logic was applied to pidff_find_special_field and although
pidff_init_fields should return an error earlier if one of the required
reports is missing, future modifications could change this logic and
resurface this possible null pointer dereference again.

LKML bug report:
https://lore.kernel.org/all/CAL-gK7f5=R0nrrQdPtaZZr1fd-cdAMbDMuZ_NLA8vM0SX+nGSw@mail.gmail.com

Reported-by: Nolan Nicholson <nolananicholson@gmail.com>
Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 4c94d8cbac43a..25dbed076f530 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -793,6 +793,11 @@ static void pidff_set_autocenter(struct input_dev *dev, u16 magnitude)
 static int pidff_find_fields(struct pidff_usage *usage, const u8 *table,
 			     struct hid_report *report, int count, int strict)
 {
+	if (!report) {
+		pr_debug("pidff_find_fields, null report\n");
+		return -1;
+	}
+
 	int i, j, k, found;
 	int return_value = 0;
 
@@ -917,6 +922,11 @@ static int pidff_reports_ok(struct pidff_device *pidff)
 static struct hid_field *pidff_find_special_field(struct hid_report *report,
 						  int usage, int enforce_min)
 {
+	if (!report) {
+		pr_debug("pidff_find_special_field, null report\n");
+		return NULL;
+	}
+
 	int i;
 
 	for (i = 0; i < report->maxfield; i++) {
-- 
2.39.5



