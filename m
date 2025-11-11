Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E964C97;
	Tue, 11 Nov 2025 00:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822141; cv=none; b=WKca9OXg1WMV0hM78RzuuRnz8V+7y12pf81MeJJOQrsYUxl4BIrQS+b5YWDCu3nJYARdwwSqJAW+xUaTNvTUoOPJorN9tUZ+l2IS3tGHaT7j3lMrzRNITFZWrUpa3T3PxyiS/GKvbSK1M1QqO1KvCdyjV8n/23SJZTOoc5jfkF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822141; c=relaxed/simple;
	bh=8CpDyj6SyeGo/HC3CLRHCkOJV0fEeQuraYQoXVWp18o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT5wPInbH0CedfkjnhKvrOI/BnTFKbLqIsnQPT2FZEu9xYxNmpmSvXG0pma9RQizi5PNfKfNGPDd2yvhTbCvyFOPNpnr6933Y+tU2EWM4IqadriuV0Pekp9Qyfa+BBs2rqtqeGNKEr7IuwvjkR1VeFwxzgr9/YHD7Hd8uzdLXSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AaBUho+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AaBUho+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4951C16AAE;
	Tue, 11 Nov 2025 00:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822141;
	bh=8CpDyj6SyeGo/HC3CLRHCkOJV0fEeQuraYQoXVWp18o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AaBUho+95gFjtywz0LJStEGIhkCW/FO65eLffmsn6iL9vjymwJ2ZM8oehdBd7Eqgf
	 ZVpyub37C+P1YOCkEqHJtZy9OcqquxxT5RRefoHPxowrEloclcnfQC2d4ma1o/cV7P
	 7LkiuCQ1fZa17RhGtV+MMNkAP/fUnZjHj8Fodado=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.17 010/849] ACPI: button: Call input_free_device() on failing input device registration
Date: Tue, 11 Nov 2025 09:33:00 +0900
Message-ID: <20251111004536.712502202@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -619,8 +619,10 @@ static int acpi_button_add(struct acpi_d
 
 	input_set_drvdata(input, device);
 	error = input_register_device(input);
-	if (error)
+	if (error) {
+		input_free_device(input);
 		goto err_remove_fs;
+	}
 
 	switch (device->device_type) {
 	case ACPI_BUS_TYPE_POWER_BUTTON:


