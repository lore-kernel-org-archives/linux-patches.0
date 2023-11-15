Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD2131725
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/5Et60T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF2AC433C9;
	Wed, 15 Nov 2023 19:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077187;
	bh=3EEbhHRSLtS8aDRLjD67Ec66T9VUz8w158xA2TihxL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/5Et60T01+0xN/I19mqTf7fd//YWZOjxdBCoSgiSE+qeGMIyHn3q84HydfQHe0wd
	 oYnSk2pwqBZPmabJ+yL0e/BBWiRmdOam5MUBFW/lBlveTEjVOdk2mmVtwxtW1SdFTn
	 u7MIwrmFwLm5GAeXYbPRgXlB2RQwOd/86w7yzidA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/603] ACPI: sysfs: Fix create_pnp_modalias() and create_of_modalias()
Date: Wed, 15 Nov 2023 14:11:37 -0500
Message-ID: <20231115191623.700123908@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 48cf49d31994ff97b33c4044e618560ec84d35fb ]

snprintf() does not return negative values on error.

To know if the buffer was too small, the returned value needs to be
compared with the length of the passed buffer. If it is greater or
equal, the output has been truncated, so add checks for the truncation
to create_pnp_modalias() and create_of_modalias(). Also make them
return -ENOMEM in that case, as they already do that elsewhere.

Moreover, the remaining size of the buffer used by snprintf() needs to
be updated after the first write to avoid out-of-bounds access as
already done correctly in create_pnp_modalias(), but not in
create_of_modalias(), so change the latter accordingly.

Fixes: 8765c5ba1949 ("ACPI / scan: Rework modalias creation when "compatible" is present")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
[ rjw: Merge two patches into one, combine changelogs, add subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/device_sysfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/device_sysfs.c b/drivers/acpi/device_sysfs.c
index b9bbf07461992..a34d8578b3da6 100644
--- a/drivers/acpi/device_sysfs.c
+++ b/drivers/acpi/device_sysfs.c
@@ -158,8 +158,8 @@ static int create_pnp_modalias(const struct acpi_device *acpi_dev, char *modalia
 		return 0;
 
 	len = snprintf(modalias, size, "acpi:");
-	if (len <= 0)
-		return len;
+	if (len >= size)
+		return -ENOMEM;
 
 	size -= len;
 
@@ -212,8 +212,10 @@ static int create_of_modalias(const struct acpi_device *acpi_dev, char *modalias
 	len = snprintf(modalias, size, "of:N%sT", (char *)buf.pointer);
 	ACPI_FREE(buf.pointer);
 
-	if (len <= 0)
-		return len;
+	if (len >= size)
+		return -ENOMEM;
+
+	size -= len;
 
 	of_compatible = acpi_dev->data.of_compatible;
 	if (of_compatible->type == ACPI_TYPE_PACKAGE) {
-- 
2.42.0



