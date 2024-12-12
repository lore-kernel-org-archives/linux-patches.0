Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0701217F26;
	Thu, 12 Dec 2024 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016653; cv=none; b=iStrwG8do6/sMmfgrSe+DiF7FiJNQWEbICDalle0yiRiyCs6ViLVyKUJ/C+0cng0WMWSfbimzs9vESWh7TLFfQYvCrWI1Kj8U9vHotEZP1IMrvxXTNc/XqFnCDK6jygitbvAvLLtSJb4ZwFsWPMlrrkoWL1vrc1yO7FytOgMxlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016653; c=relaxed/simple;
	bh=v9YPEko2fGWbrX4UsD+Cts5igXWVubUHr6XYqz4v+ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4oDbZ6CcXz4kgTmjNcghe5MHSaBGmjSxKZUFfzfeG8wPuBUxtAATWUr20brw4Iw3S5MdIht362CH7KS6GvhLm5rYXcTGR/z1PwdbVGiQS6FqdLUrZfXJlYaHOUgaMmbGHkB4T2kgulvCasIHZE+cnk0ZZtH2OteL2M0yt+OP+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JYmFKa+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JYmFKa+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C16C4CED4;
	Thu, 12 Dec 2024 15:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016653;
	bh=v9YPEko2fGWbrX4UsD+Cts5igXWVubUHr6XYqz4v+ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JYmFKa+OcGJfDzNyAms2owCXyBqGMIzlZciJX8SMt+buQir0nDbSW1QskNeeVdO+
	 V/q6EHGu5vq0eibLrZK5urCsJEXHcvGvhPhlU9PF190dh9EAJTRLYbwKfjNKEILRsw
	 tdgMeEX/H8TZ4LjdOtYTMTa4m8K9T3cqg4I/jAcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/466] ACPI: x86: Add adev NULL check to acpi_quirk_skip_serdev_enumeration()
Date: Thu, 12 Dec 2024 15:56:38 +0100
Message-ID: <20241212144315.819864740@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4a49194f587a62d972b602e3e1a2c3cfe6567966 ]

acpi_dev_hid_match() does not check for adev == NULL, dereferencing
it unconditional.

Add a check for adev being NULL before calling acpi_dev_hid_match().

At the moment acpi_quirk_skip_serdev_enumeration() is never called with
a controller_parent without an ACPI companion, but better safe than sorry.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241109220028.83047-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 3eec889d4f5f8..423565c31d5ef 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -536,7 +536,7 @@ int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *s
 	 * Set skip to true so that the tty core creates a serdev ctrl device.
 	 * The backlight driver will manually create the serdev client device.
 	 */
-	if (acpi_dev_hid_match(adev, "DELL0501")) {
+	if (adev && acpi_dev_hid_match(adev, "DELL0501")) {
 		*skip = true;
 		/*
 		 * Create a platform dev for dell-uart-backlight to bind to.
-- 
2.43.0



