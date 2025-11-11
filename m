Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F25012DDA1;
	Tue, 11 Nov 2025 00:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822222; cv=none; b=KTusqgaY7gCZcCSI3JUDiuwz3kXE0ua57MOYRF0VLwdb8Ctqbn7hLZx5Suj0sOFhT0o4rODCZ2rRXTjc+4zzXEMq+iGv7LNie+SnNuY5YBoHF1iEgZoJ0HstLUm7jVLntx32CXWP22eZ3B7Ibjgx7nj4UvlZBBl14irkkEDAxUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822222; c=relaxed/simple;
	bh=Hk8+7wq/agBau/9JNfhK7tNjXKVSWpGvE6k4Ni0YPjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaT504EjJ18giOOmAtVPzpOH4jqa+uMkU9NWVEeJLJ5FCTt+5uXfUPMwNIkyKN/FPx9yKhvgO0T3tjm72CbgTkqoKhDkJ7OpC90Z716Ys/3n2USl2NADX0jiobOsFhq4F15yKXx0l4qrlQ/GUmtJ2L9QuGEztBnlpQiwOurFXb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8kLP0v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8kLP0v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE320C113D0;
	Tue, 11 Nov 2025 00:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822222;
	bh=Hk8+7wq/agBau/9JNfhK7tNjXKVSWpGvE6k4Ni0YPjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8kLP0v3Splm2RfDBhDAtD25wuM3Dx1SEpkkCF4x7Ff54to27muL/zgA2dNE8tTC1
	 PI0nCydvm8pKbYqW4Z0a/5E/M+8TGynxvwcxXHlNKEIBFLGRypmAJ54M87GSD9c4tM
	 ZXJCRgJjkrXO5Sd6eoRFQd09bwCmdflejYDoHmtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 006/565] ACPI: button: Call input_free_device() on failing input device registration
Date: Tue, 11 Nov 2025 09:37:42 +0900
Message-ID: <20251111004526.991524083@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

commit 20594cd104abaaabb676c7a2915b150ae5ff093d upstream.

Make acpi_button_add() call input_free_device() when
input_register_device() fails as required according to the
documentation of the latter.

Fixes: 0d51157dfaac ("ACPI: button: Eliminate the driver notify callback")
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
[ rjw: Subject and changelog rewrite, Fixes: tag ]
Link: https://patch.msgid.link/20251006084706.971855-1-kaushlendra.kumar@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/button.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -613,8 +613,10 @@ static int acpi_button_add(struct acpi_d
 
 	input_set_drvdata(input, device);
 	error = input_register_device(input);
-	if (error)
+	if (error) {
+		input_free_device(input);
 		goto err_remove_fs;
+	}
 
 	switch (device->device_type) {
 	case ACPI_BUS_TYPE_POWER_BUTTON:


