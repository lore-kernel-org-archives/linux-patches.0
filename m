Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8A424113A;
	Tue, 29 Apr 2025 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945134; cv=none; b=bDhZLJLNUXNYOQ9kp4rztv5AGaJlQtQJ+mzAI+aYWAFXPoRhow4FlqnOmLsDsbYMrbRqYwNPXw7ygr0zXNA/Q3scyRLU8F+aJhVvZiudgsIR3pWAg9h1HJ6AaIqAogxqWD/se0jXaQ6Aad40irL+JcW3ScXgrAlh6H64qzj4oqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945134; c=relaxed/simple;
	bh=HdI/28dXv1xt7VfGW/7Klhh4s0Nr1Qiug1i1FDkzeH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qzKhlO0GMs7dyNFwTzFz5mOZEo99EotiHFZaxu6+1Wz5ZDkKdt6Sh5A1xL/ORmBOXiQxMbg6CzveOTGmPLcIf5J2PCjWtCNqE0KiMxBFToYNi1mAnSmYf1o29ajx9MIOIteESGF50+T69NM9fvU2P8sXt0D3/KTFsvgz1MOgfp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7B8m/Kd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7B8m/Kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0567C4CEE3;
	Tue, 29 Apr 2025 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945134;
	bh=HdI/28dXv1xt7VfGW/7Klhh4s0Nr1Qiug1i1FDkzeH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7B8m/KdHq0qGeRYubOCqnOW4Ap1L6BON3Rs6UWFG4lPSX8uhVg9dw+ZowroElue1
	 hABtyze7Stn4oa3c7iApkJzmX3rRToYV9/qyL9w1NOttrzmpb9bSzeoqgSz+mqLZFA
	 Ms2T7DCcQ9oMV5kl7LM0fPr9O/dsBlPoMOp+YCiA=
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
Subject: [PATCH 5.4 013/179] HID: pidff: Fix null pointer dereference in pidff_find_fields
Date: Tue, 29 Apr 2025 18:39:14 +0200
Message-ID: <20250429161049.930230080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -772,6 +772,11 @@ static int pidff_find_fields(struct pidf
 {
 	int i, j, k, found;
 
+	if (!report) {
+		pr_debug("pidff_find_fields, null report\n");
+		return -1;
+	}
+
 	for (k = 0; k < count; k++) {
 		found = 0;
 		for (i = 0; i < report->maxfield; i++) {
@@ -885,6 +890,11 @@ static struct hid_field *pidff_find_spec
 {
 	int i;
 
+	if (!report) {
+		pr_debug("pidff_find_special_field, null report\n");
+		return NULL;
+	}
+
 	for (i = 0; i < report->maxfield; i++) {
 		if (report->field[i]->logical == (HID_UP_PID | usage) &&
 		    report->field[i]->report_count > 0) {


