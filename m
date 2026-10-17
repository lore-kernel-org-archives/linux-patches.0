Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893E33AF666;
	Sat, 17 Oct 2026 16:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256199; cv=none; b=skzitiY0Mq+lwAzg4WRhDcK+Jj/0b3rxyZCu0sCM2g9ccYMMeiSGJvJMXZ+NexOn8A3+apm4XattXTuZw92zQ87by0EcxJ+46hg8rs1F2VBU1EGGUAWqkrH1NXSOMjNDriGyO7h5HfwnIrJlHRyzNQb1RqYjtdHV1wMSzTfy2fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256199; c=relaxed/simple;
	bh=r/RodcWZ7ngZfFE+rla1vs42M5cvDMpMSdc/c4INZ7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQMXOjcQMEN9k7OahI6n4Q1THcAsGeqKgx1OORnzfvcSqOX4O7nGws2E+Jnpuj6EV0UTmy+zx16OWDpgW9iearcRliBd9KYcfgPyRWR9KPD8yTlQNMjLpqdlwSQM8/ffJpmsALquNggrNvtU33rEcA3EgMm+gjHkZ5ZIm8c+LBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HC+aq3B6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HC+aq3B6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31641F000C4;
	Sat, 17 Oct 2026 16:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256198;
	bh=ArdYkQU8ITeuFL7ubPbwMewCRFMRQNZphLUAKF0bB3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HC+aq3B6d0z2W5ifVengBnJ+dY2Y3I/gdFhqOB7poJGZN8kEHdf13UCDGppN4HNVb
	 w4gBD/EwcrhQGgE3aX8dOqKjsuo0gBaKt+d8TTMA+sUNoZ04HucpCJP2HAGCsy3dCe
	 r3cyzbIDKKM2Ye/JhEd972b+F51kCfGdO1jr/0H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0155/1674] HID: core: remove #ifdef CONFIG_PM from hid_driver
Date: Sat, 17 Oct 2026 17:40:27 +0200
Message-ID: <20261017160435.142976413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit df8b030d82dd1224881acb4e778fa06c4824f72b ]

Allow HID drivers to pass ->suspend, ->resume and ->reset_resume via
pm_ptr().
Through the usage of pm_ptr() the CONFIG_PM-dependent code will always be
compiled, protecting against bitrot.
The linker will then garbage-collect the unused function avoiding any overhead.

The only overhead in the final kernel image and at runtime are a few
extra bytes in 'struct hid_driver'.

The same approach is chosen by 'struct usb_driver' and other subsystems.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20231012-hid-pm_ptr-v1-1-0a71531ca93b@weissschuh.net
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index f560ae891d7e3..55c7061be2690 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -869,11 +869,11 @@ struct hid_driver {
 	void (*feature_mapping)(struct hid_device *hdev,
 			struct hid_field *field,
 			struct hid_usage *usage);
-#ifdef CONFIG_PM
+
 	int (*suspend)(struct hid_device *hdev, pm_message_t message);
 	int (*resume)(struct hid_device *hdev);
 	int (*reset_resume)(struct hid_device *hdev);
-#endif
+
 /* private: */
 	struct device_driver driver;
 };
-- 
2.53.0



