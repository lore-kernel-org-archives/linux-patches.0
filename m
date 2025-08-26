Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D702BEC45;
	Tue, 26 Aug 2025 14:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218405; cv=none; b=oVWIMVchosT2Jc5WqfqE6JU7qbebHY+8vwtM6TNG3DAAfBJxP8hkTTQQu6+BUgMhxM+D4it4FJGiGMKsjThBxK1ZSXMUKoob3BTHETDa/fJSfTzJXyA6NRhlfVT8kUXNVSVKV8wXdX4igKNSKZX3HETTqhZEyMlSQFQwCWNMVqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218405; c=relaxed/simple;
	bh=OTufjo6raQUQTU0xQrcmM6sWhewervq9yivdOFD6tLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc8McbNnQfvEzsb38yFQ2x03hWGTkmVosUiBlg/6eff+y1dOTqt4HBUce/NMvzS+6pQX0Ga/3mtXaNrFvDGu1eJxpD6MMkc0u4aOZ83QsSiv/PoT5803nAaerfjyxh9T2FouRhLR3XT9JolE4jx2jb+s66KD4LcQqEcTKpzJpok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPUVWiv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPUVWiv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA4AC4CEF1;
	Tue, 26 Aug 2025 14:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218405;
	bh=OTufjo6raQUQTU0xQrcmM6sWhewervq9yivdOFD6tLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPUVWiv4IIkAaHsBc0HEfxRDioROaLgYvgsna9gZt15F4tcITQZJQsCbn+ciKaGu6
	 JMFDt7fGXCPxIavf4e4OG9337hRson7LFuFlcnKwioqBLtED1Z35hR//f0CDXRzAM2
	 BUslTMA0LygNWYdj+nZavQlob8CqY51oMa/0JJtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhong <floridsleeves@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Teddy Astie <teddy.astie@vates.tech>,
	Yann Sionneau <yann.sionneau@vates.tech>,
	Dillon C <dchan@dchan.tech>
Subject: [PATCH 5.10 469/523] ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value
Date: Tue, 26 Aug 2025 13:11:19 +0200
Message-ID: <20250826110936.012873723@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Li Zhong <floridsleeves@gmail.com>

commit 2437513a814b3e93bd02879740a8a06e52e2cf7d upstream.

The return value of acpi_fetch_acpi_dev() could be NULL, which would
cause a NULL pointer dereference to occur in acpi_device_hid().

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
[ rjw: Subject and changelog edits, added empty line after if () ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Teddy Astie <teddy.astie@vates.tech>
Signed-off-by: Yann Sionneau <yann.sionneau@vates.tech>
Reported-by: Dillon C <dchan@dchan.tech>
Tested-by: Dillon C <dchan@dchan.tech>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1128,7 +1128,9 @@ static int acpi_processor_get_lpi_info(s
 
 	status = acpi_get_parent(handle, &pr_ahandle);
 	while (ACPI_SUCCESS(status)) {
-		acpi_bus_get_device(pr_ahandle, &d);
+		if (acpi_bus_get_device(pr_ahandle, &d))
+			break;
+
 		handle = pr_ahandle;
 
 		if (strcmp(acpi_device_hid(d), ACPI_PROCESSOR_CONTAINER_HID))


