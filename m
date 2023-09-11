Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0215F11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741B1C433C7;
	Mon, 11 Sep 2023 15:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444461;
	bh=n53DhF8hzTyTI/j2CCH7cyYQXJwTPgi3/odqs8WAdis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGCajlQ1an9C3sj5jEgjkZNg7gISOocggDf41OZxHYDff28DyGtd7e46fM1SZMLTe
	 dzyIzU10swibfX/OdVTBtrivVvHDd9UNpW+WPZfcqUIGA7NJi2am3JUHzaoSnwzwKV
	 cu06VOudzHDSKTd0VckStTLpSXM9nnIT6zZA/0Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.4 701/737] platform/chrome: chromeos_acpi: print hex string for ACPI_TYPE_BUFFER
Date: Mon, 11 Sep 2023 15:49:20 +0200
Message-ID: <20230911134710.104558507@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 0820debb7d489e9eb1f68b7bb69e6ae210699b3f upstream.

`element->buffer.pointer` should be binary blob.  `%s` doesn't work
perfect for them.

Print hex string for ACPI_TYPE_BUFFER.  Also update the documentation
to reflect this.

Fixes: 0a4cad9c11ad ("platform/chrome: Add ChromeOS ACPI device driver")
Cc: stable@vger.kernel.org
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230803011245.3773756-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-driver-chromeos-acpi |    2 -
 drivers/platform/chrome/chromeos_acpi.c              |   31 ++++++++++++++++++-
 2 files changed, 31 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-driver-chromeos-acpi
+++ b/Documentation/ABI/testing/sysfs-driver-chromeos-acpi
@@ -134,4 +134,4 @@ KernelVersion:	5.19
 Description:
 		Returns the verified boot data block shared between the
 		firmware verification step and the kernel verification step
-		(binary).
+		(hex dump).
--- a/drivers/platform/chrome/chromeos_acpi.c
+++ b/drivers/platform/chrome/chromeos_acpi.c
@@ -90,7 +90,36 @@ static int chromeos_acpi_handle_package(
 	case ACPI_TYPE_STRING:
 		return sysfs_emit(buf, "%s\n", element->string.pointer);
 	case ACPI_TYPE_BUFFER:
-		return sysfs_emit(buf, "%s\n", element->buffer.pointer);
+		{
+			int i, r, at, room_left;
+			const int byte_per_line = 16;
+
+			at = 0;
+			room_left = PAGE_SIZE - 1;
+			for (i = 0; i < element->buffer.length && room_left; i += byte_per_line) {
+				r = hex_dump_to_buffer(element->buffer.pointer + i,
+						       element->buffer.length - i,
+						       byte_per_line, 1, buf + at, room_left,
+						       false);
+				if (r > room_left)
+					goto truncating;
+				at += r;
+				room_left -= r;
+
+				r = sysfs_emit_at(buf, at, "\n");
+				if (!r)
+					goto truncating;
+				at += r;
+				room_left -= r;
+			}
+
+			buf[at] = 0;
+			return at;
+truncating:
+			dev_info_once(dev, "truncating sysfs content for %s\n", name);
+			sysfs_emit_at(buf, PAGE_SIZE - 4, "..\n");
+			return PAGE_SIZE - 1;
+		}
 	default:
 		dev_err(dev, "element type %d not supported\n", element->type);
 		return -EINVAL;


