Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C519A1C7B9C;
	Mon, 14 Oct 2024 14:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917483; cv=none; b=mtOPGvcfFp3hBs8qw2tT6HNY/gkk4GdI0J7/N/2Aj5R8w8joD/nzqnq4YkU0V8fgIHdt2goZCgHidFz4gXjaI31b+i9cDRCFIP03xw3Jfh+jqPPNwwXJrJa9qwbwZ86I7lRfCr/QBEHk4mNrC46Whb7t97+Kwjg50iNOVQLZls0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917483; c=relaxed/simple;
	bh=d5kNKkv1+6GL6ePTeRtfRCyMu7zGFb58I+r18Ali2nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQmxS4cvgwT+Ho/ip/ZpnjepLMtwQY3Z0V9RzcIrvygW9dvXvxal1q7cU8FsXAaewqV6X3Eu+wnfVyW4uAgV/FYeupav8CRe0rsHYIdK/mnwYEMzBzMWhJBJVkVLLsURKO5XTPkuVO5sjr+Pod3CgG5OtTTbe+oTt6lu3d5DO3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buKdj/Ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buKdj/Ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D714C4CEC3;
	Mon, 14 Oct 2024 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917483;
	bh=d5kNKkv1+6GL6ePTeRtfRCyMu7zGFb58I+r18Ali2nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buKdj/EpxdTfL3yOcaMAOhXRbR4DeAFcCrBzJGNHa6O6N1rOkz9u57KdNJJF9uwz0
	 vPBfZAEhjCbkYHEZU94tU6tdGzOa8+CTX7RA6TOSl4NKAdhC9FDivR6VkOQ4tAVzy5
	 WrYxcnJrqw9pMkzPrbgOBLv8Hkz/CaogZJnF0k7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/798] ACPICA: executer/exsystem: Dont nag user about every Stall() violating the spec
Date: Mon, 14 Oct 2024 16:09:35 +0200
Message-ID: <20241014141218.782872172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit c82c507126c9c9db350be28f14c83fad1c7969ae ]

ACPICA commit 129b75516fc49fe1fd6b8c5798f86c13854630b3

Stop nagging user about every Stall() that violates the spec

On my Dell XPS 15 7590 I get hundreds of these warnings after few hours of
uptime:

$ dmesg | grep "fix the firmware" | wc -l
261

I cannot fix the firmware and I doubt that Dell cares about 4 year old
laptop either

Fixes: ace8f1c54a02 ("ACPICA: executer/exsystem: Inform users about ACPI spec violation")
Link: https://github.com/acpica/acpica/commit/129b7551
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/exsystem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/exsystem.c b/drivers/acpi/acpica/exsystem.c
index 7b5470f404f3f..104e6e96c31ea 100644
--- a/drivers/acpi/acpica/exsystem.c
+++ b/drivers/acpi/acpica/exsystem.c
@@ -133,14 +133,15 @@ acpi_status acpi_ex_system_do_stall(u32 how_long_us)
 		 * (ACPI specifies 100 usec as max, but this gives some slack in
 		 * order to support existing BIOSs)
 		 */
-		ACPI_ERROR((AE_INFO,
-			    "Time parameter is too large (%u)", how_long_us));
+		ACPI_ERROR_ONCE((AE_INFO,
+				 "Time parameter is too large (%u)",
+				 how_long_us));
 		status = AE_AML_OPERAND_VALUE;
 	} else {
 		if (how_long_us > 100) {
-			ACPI_WARNING((AE_INFO,
-				      "Time parameter %u us > 100 us violating ACPI spec, please fix the firmware.",
-				      how_long_us));
+			ACPI_WARNING_ONCE((AE_INFO,
+					   "Time parameter %u us > 100 us violating ACPI spec, please fix the firmware.",
+					   how_long_us));
 		}
 		acpi_os_stall(how_long_us);
 	}
-- 
2.43.0



