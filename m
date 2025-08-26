Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F8334F461;
	Tue, 26 Aug 2025 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216804; cv=none; b=pCLXBqouqoK54IuhkVCg79HHiXuOtSextG5IvrTEnOKJZNojVylEi03zWjB49LlY1J5EyTKOyCchv/MNDn98Cfx7N4WW0GXPZnDQNp7nECm+6+uVBOTZgX6dVH17R0RBzayeQlPaqoNnRpEnyzJ9s3lCCaEz4YiCC2tKTe8QSz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216804; c=relaxed/simple;
	bh=PE6xDi5d7CZl2VJ5oPkDuFBLthPL51PXU5ZgtWwRzZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYWbMFMyhKpLiSzexHTb7dbyN5VWTTCzHASInvqbXYiLKJidMDLQmjitF2ipbLkSaetAAiYbPs3HYKHx21U1DE4wyRWaZ8MMVpP9Pu9Vv+uHlHOouS7axS0L+Fm9kWjE3rW224F0OuensQ2kdB8lp71HRNRAjl7Htayzlid1/1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3nrydY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3nrydY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD94C4CEF1;
	Tue, 26 Aug 2025 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216804;
	bh=PE6xDi5d7CZl2VJ5oPkDuFBLthPL51PXU5ZgtWwRzZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3nrydY/dwv7NVLrmUkXFLOfOa5VnJScHBh6cuqfxqBZoJSpzpPtm6IXssUFm3wcS
	 HFr3i2KW9tGFCr9fEXA8GSdbhVED6jVcx1H0o7Oxagwa+bH2W/2Gk0mT3K5qe7OOLD
	 jAquUoRHjf0DODbPG0/s0F2ogMJ1TacoAuE2BOHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhong <floridsleeves@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Teddy Astie <teddy.astie@vates.tech>,
	Yann Sionneau <yann.sionneau@vates.tech>,
	Dillon C <dchan@dchan.tech>
Subject: [PATCH 5.15 550/644] ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value
Date: Tue, 26 Aug 2025 13:10:41 +0200
Message-ID: <20250826111000.155000264@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1125,7 +1125,9 @@ static int acpi_processor_get_lpi_info(s
 
 	status = acpi_get_parent(handle, &pr_ahandle);
 	while (ACPI_SUCCESS(status)) {
-		acpi_bus_get_device(pr_ahandle, &d);
+		if (acpi_bus_get_device(pr_ahandle, &d))
+			break;
+
 		handle = pr_ahandle;
 
 		if (strcmp(acpi_device_hid(d), ACPI_PROCESSOR_CONTAINER_HID))


