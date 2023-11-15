Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEED328DB1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAX54HMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F136C433C8;
	Wed, 15 Nov 2023 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076146;
	bh=z+IU6j5aot5FTtxRHeOxG4sRkLrA6TuqT9Rnt5g1tqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAX54HMyoRNzGoyI88o3BVf2maqI57ofQjFglKg24gtFgISa1L2tu1iH8FAQSRx5i
	 +d4rLF1MGrAnzsdIyu9pSobhwClNQ6esd3dPvUfdIXLe7+fhxUCF42Zo1QUtw6DMA/
	 SllcxyKaSP34WuR3J/8USiiRcYRjyxhWfYob6CBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 102/550] ACPI: property: Allow _DSD buffer data only for byte accessors
Date: Wed, 15 Nov 2023 14:11:26 -0500
Message-ID: <20231115191607.783930115@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 046ece773cc77ef5d2a1431b188ac3d0840ed150 ]

In accordance with ACPI specificication and _DSD data buffer
representation the data there is an array of bytes. Hence,
accessing it with something longer will create a sparse data
which is against of how device property APIs work in general
and also not defined in the ACPI specification (see [1]).
Fix the code to emit an error if non-byte accessor is used to
retrieve _DSD buffer data.

Fixes: 369af6bf2c28 ("ACPI: property: Read buffer properties as integers")
Link: https://uefi.org/specs/ACPI/6.5/19_ASL_Reference.html#buffer-declare-buffer-object # [1]
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[ rjw: Add missing braces ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/property.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index 413e4fcadcaf7..99b4e33554355 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1102,25 +1102,26 @@ static int acpi_data_prop_read(const struct acpi_device_data *data,
 	switch (proptype) {
 	case DEV_PROP_STRING:
 		break;
-	case DEV_PROP_U8 ... DEV_PROP_U64:
+	default:
 		if (obj->type == ACPI_TYPE_BUFFER) {
 			if (nval > obj->buffer.length)
 				return -EOVERFLOW;
-			break;
+		} else {
+			if (nval > obj->package.count)
+				return -EOVERFLOW;
 		}
-		fallthrough;
-	default:
-		if (nval > obj->package.count)
-			return -EOVERFLOW;
 		break;
 	}
 	if (nval == 0)
 		return -EINVAL;
 
-	if (obj->type != ACPI_TYPE_BUFFER)
-		items = obj->package.elements;
-	else
+	if (obj->type == ACPI_TYPE_BUFFER) {
+		if (proptype != DEV_PROP_U8)
+			return -EPROTO;
 		items = obj;
+	} else {
+		items = obj->package.elements;
+	}
 
 	switch (proptype) {
 	case DEV_PROP_U8:
-- 
2.42.0



