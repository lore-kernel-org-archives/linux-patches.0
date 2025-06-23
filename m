Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D75E1E3DCD;
	Mon, 23 Jun 2025 22:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717219; cv=none; b=GeLH2Oz4zV8pYcGk0I9MhuG2q9P8B55z4iaIgp/lpP7iGa77Yc/Nc0FayZS2taCdU3m7MzMefiuNA2iMf4eQzrUiVJHWUtP+oKE5g9YYmEo54j2q3HFZ55o3w3mDBeAMBkxzjf+ui+iJGQlONcdtyZw7prj8MayaIV1VhGgWo+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717219; c=relaxed/simple;
	bh=ZcGA1rkgbngT4Pxwo00zaP6DUPEReRgECC+RNxHoFfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPsMdyl5tI/SGHuYOfeB/KHl0aPD+DNKwwpOpqDUi92ZaoSbfk7qt45yQyXihqA3LMpOxVvCVPPVU8qJ9RjTJn2tHnprc5xkyitdW1OslC9Tje9MczH+nRIOsa+cgnthB7VHvlY4tyoNX/6tTg8yFgU4xXF/V9N49p96k7iNMJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qat+Gegl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qat+Gegl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E030C4CEEA;
	Mon, 23 Jun 2025 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717219;
	bh=ZcGA1rkgbngT4Pxwo00zaP6DUPEReRgECC+RNxHoFfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qat+GeglRrqxwmaMF9nHOg4PZUIcuvwBeJwUEBSlxrGT40PGx+gWVZJhjON8ZzgRk
	 ZgezIUWL/u6mSWvyElV+J5n5a+4ThiTBEB+FjGkWMfBUUMQbl//W1Fq3jlwnUhInPY
	 pHhd2vyS5e/7E/ke4jTgwwr6JiM6bFcZuJ5KNz70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	gldrk <me@rarity.fan>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 383/508] ACPICA: utilities: Fix overflow check in vsnprintf()
Date: Mon, 23 Jun 2025 15:07:08 +0200
Message-ID: <20250623130654.725158722@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gldrk <me@rarity.fan>

[ Upstream commit 12b660251007e00a3e4d47ec62dbe3a7ace7023e ]

ACPICA commit d9d59b7918514ae55063b93f3ec041b1a569bf49

The old version breaks sprintf on 64-bit systems for buffers
outside [0..UINT32_MAX].

Link: https://github.com/acpica/acpica/commit/d9d59b79
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/4994935.GXAFRqVoOG@rjwysocki.net
Signed-off-by: gldrk <me@rarity.fan>
[ rjw: Added the tag from gldrk ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/utprint.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/acpica/utprint.c b/drivers/acpi/acpica/utprint.c
index d5aa2109847f3..67104bfc184de 100644
--- a/drivers/acpi/acpica/utprint.c
+++ b/drivers/acpi/acpica/utprint.c
@@ -333,11 +333,8 @@ int vsnprintf(char *string, acpi_size size, const char *format, va_list args)
 
 	pos = string;
 
-	if (size != ACPI_UINT32_MAX) {
-		end = string + size;
-	} else {
-		end = ACPI_CAST_PTR(char, ACPI_UINT32_MAX);
-	}
+	size = ACPI_MIN(size, ACPI_PTR_DIFF(ACPI_MAX_PTR, string));
+	end = string + size;
 
 	for (; *format; ++format) {
 		if (*format != '%') {
-- 
2.39.5



