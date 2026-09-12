Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BAC3BE14A;
	Sat, 12 Sep 2026 20:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243574; cv=none; b=NGjn/I4CLWHzU5Qcolb3TeTVV7cxOeBmGB8zQZnnNH30LcCMWX6O54Jp3aU8AOCq6yB7ChPuY26Hbf1u1wuh3WlBQdwVvkbT1GPCGDi1IL5emxHFrVRNwTflyXtPIsdbdVYxF1ndVL8Ew47VjFtSCtztwIp/Ia9xGk2etAMQa5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243574; c=relaxed/simple;
	bh=aHvkF791VSL1WnQrf7I6O2A9yh6aMzUbqMPPJH3aHzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAloUqq7vN1sH0CWSG2ABD4PmHRBT3kwSE350QtyCwZ4RvI82HPLWIywCy3OU0BSRZgARms1IvwJgQ3rYbfniVtSlJ8g+JMp71KEH1ogQJxcYNVZFgiBGfCSrJ5eoYx2UN2Pd53TSWvzcBtM+JAaxGne38ctZsWLy+UCBY9eHrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZDXnXEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZDXnXEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7431F000FF;
	Sat, 12 Sep 2026 20:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243572;
	bh=wCrmewrbQDtVWaB3olufxcc6zA4elMPe+4eZSV5oG7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZDXnXErGlMOsktQCrnl04uVzWUgNyMa3sQnLHsGNj/7MTqHrj32sMsiHo4X+OE+g
	 Im79ojR8T5/n0/cmxtzkxSIUCqhQJE8fCUWDl8RqoPtx/TODj0l0TIip4lTI2zCxBo
	 ZS+vTUnj1XsjoQSK5x0QQa2W7OvmV6bsAuPYcp3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 792/798] ACPI: utils: Document for_each_acpi_dev_match() macro
Date: Sat, 12 Sep 2026 09:07:00 +0200
Message-ID: <20260912065535.213105678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 81eeb2f57782d0dff15db97665599121e289b614 ]

The macro requires to call acpi_dev_put() on each iteration.
Due to this it doesn't tolerate sudden disappearence of the devices.

Document all these nuances to prevent users blindly call it without
understanding the possible issues.

While at it, add the note to the acpi_dev_get_next_match_dev() and
advertise acpi_dev_put() instead of put_device() in the whole family
of the helper functions.

Fixes: bf263f64e804 ("media: ACPI / bus: Add acpi_dev_get_next_match_dev() and helper macro")
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/utils.c    |  8 ++++++--
 include/acpi/acpi_bus.h | 14 ++++++++++++++
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index e6e0aba1a8552..0b9fde135a096 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -852,7 +852,11 @@ EXPORT_SYMBOL(acpi_dev_present);
  * Return the next match of ACPI device if another matching device was present
  * at the moment of invocation, or NULL otherwise.
  *
- * The caller is responsible to call put_device() on the returned device.
+ * FIXME: The function does not tolerate the sudden disappearance of @adev, e.g.
+ * in the case of a hotplug event. That said, the caller should ensure that
+ * this will never happen.
+ *
+ * The caller is responsible for invoking acpi_dev_put() on the returned device.
  *
  * See additional information in acpi_dev_present() as well.
  */
@@ -881,7 +885,7 @@ EXPORT_SYMBOL(acpi_dev_get_next_match_dev);
  * Return the first match of ACPI device if a matching device was present
  * at the moment of invocation, or NULL otherwise.
  *
- * The caller is responsible to call put_device() on the returned device.
+ * The caller is responsible for invoking acpi_dev_put() on the returned device.
  *
  * See additional information in acpi_dev_present() as well.
  */
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 0ed6b799b1699..a4c297387c77d 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -690,6 +690,20 @@ acpi_dev_get_next_match_dev(struct acpi_device *adev, const char *hid, const cha
 struct acpi_device *
 acpi_dev_get_first_match_dev(const char *hid, const char *uid, s64 hrv);
 
+/**
+ * for_each_acpi_dev_match - iterate over ACPI devices that matching the criteria
+ * @adev: pointer to the matching ACPI device, NULL at the end of the loop
+ * @hid: Hardware ID of the device.
+ * @uid: Unique ID of the device, pass NULL to not check _UID
+ * @hrv: Hardware Revision of the device, pass -1 to not check _HRV
+ *
+ * The caller is responsible for invoking acpi_dev_put() on the returned device.
+ *
+ * FIXME: Due to above requirement there is a window that may invalidate @adev
+ * and next iteration will use a dangling pointer, e.g. in the case of a
+ * hotplug event. That said, the caller should ensure that this will never
+ * happen.
+ */
 #define for_each_acpi_dev_match(adev, hid, uid, hrv)			\
 	for (adev = acpi_dev_get_first_match_dev(hid, uid, hrv);	\
 	     adev;							\
-- 
2.53.0



