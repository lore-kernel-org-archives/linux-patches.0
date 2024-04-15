Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1E745C9;
	Mon, 15 Apr 2024 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191282; cv=none; b=F0EwKkVCWcq80d6q1tiNzB4ImfMMGr/QOsjMP/psSA5lk/Nr3PAGkU6XCsrsTSIF7GWVNSJt6p5Vf2Lw9ehB4tHzxxfZ3wAS65nM1sL29l0O0L9aVHvA0aihB3ZsaIuewX6IgnccvD3YSrWWCEPcUnoX5GP1IDpj1ns8sVF3Ze4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191282; c=relaxed/simple;
	bh=IW6gzuO5YI5bs8mY2RDDGNKTKeJAR5iu9IPpEmHNE8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXJRFImc0u8h6ws9TJgJmiifi8526Pe+uoV7vNMZTY4KyPaZ7yaq55T8jCwrAxd1hnpXKDIMok+CWI922QWl+8rBwPUyY3TIrpUqFDhGeOpIKJS3bow5I2sTU8dyt/buA3CmdQ7W/P3xRZdfTrHq0VuhVgI64Q2DqSSTXk3coIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlbEyPh7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlbEyPh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE549C113CC;
	Mon, 15 Apr 2024 14:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191282;
	bh=IW6gzuO5YI5bs8mY2RDDGNKTKeJAR5iu9IPpEmHNE8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlbEyPh7DhobjnPeu/jHJSjnVthiwtLo0myGTqWDlgiyprfBBVA3s/7xYJC5DXQ6E
	 DWIO5jD72hLw0yGRHMkwrYQYWD271jMrSl+WdV8F075o3pFj8pyBn+oScgTnN2a8PK
	 pdBNxK2aV10sJ3DyG5Yldnc0+PF8SsZ4Tl+TItm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 054/172] ACPI: bus: allow _UID matching for integer zero
Date: Mon, 15 Apr 2024 16:19:13 +0200
Message-ID: <20240415142002.068165159@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit aca1a5287ea328fd1f7e2bfa6806646486d86a70 ]

Commit b2b32a173881 ("ACPI: bus: update acpi_dev_hid_uid_match() to
support multiple types") added _UID matching support for both integer
and string types, which satisfies NULL @uid2 argument for string types
using inversion, but this logic prevents _UID comparision in case the
argument is integer 0, which may result in false positives.

Fix this using _Generic(), which will allow NULL @uid2 argument for
string types as well as _UID matching for all possible integer values.

Fixes: b2b32a173881 ("ACPI: bus: update acpi_dev_hid_uid_match() to support multiple types")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
[ rjw: Comment adjustment ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/acpi_bus.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 446225aada50d..8b45b82cd5edc 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -911,17 +911,19 @@ static inline bool acpi_int_uid_match(struct acpi_device *adev, u64 uid2)
  * acpi_dev_hid_uid_match - Match device by supplied HID and UID
  * @adev: ACPI device to match.
  * @hid2: Hardware ID of the device.
- * @uid2: Unique ID of the device, pass 0 or NULL to not check _UID.
+ * @uid2: Unique ID of the device, pass NULL to not check _UID.
  *
  * Matches HID and UID in @adev with given @hid2 and @uid2. Absence of @uid2
  * will be treated as a match. If user wants to validate @uid2, it should be
  * done before calling this function.
  *
- * Returns: %true if matches or @uid2 is 0 or NULL, %false otherwise.
+ * Returns: %true if matches or @uid2 is NULL, %false otherwise.
  */
 #define acpi_dev_hid_uid_match(adev, hid2, uid2)			\
 	(acpi_dev_hid_match(adev, hid2) &&				\
-		(!(uid2) || acpi_dev_uid_match(adev, uid2)))
+		/* Distinguish integer 0 from NULL @uid2 */		\
+		(_Generic(uid2,	ACPI_STR_TYPES(!(uid2)), default: 0) ||	\
+		acpi_dev_uid_match(adev, uid2)))
 
 void acpi_dev_clear_dependencies(struct acpi_device *supplier);
 bool acpi_dev_ready_for_enumeration(const struct acpi_device *device);
-- 
2.43.0



