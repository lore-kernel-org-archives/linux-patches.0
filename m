Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F68F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F495C4339B;
	Mon, 13 Feb 2023 14:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300204;
	bh=isHMXmmCPO2lH7MLsNVdh+K6PFj6mLc6duGdSmEhzc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVOaYyklNv3tOPT7G9ukCx5zbz89yEG1kghh0SDb53242HhLY0dVWM+Dl3cjQ1Y9B
	 ydrS9b7wMVI4WUPScpHjeZF+npaYcfgcJ3VdWT2TyNzj7IU2rzT8i56Klcjfq0O1lk
	 19UuaW5letox+KoX6+eCNtZRJnU7OOsh32HtyQ2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@gmail.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Justin He <justin.he@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 104/114] arm64: efi: Force the use of SetVirtualAddressMap() on eMAG and Altra Max machines
Date: Mon, 13 Feb 2023 15:48:59 +0100
Message-Id: <20230213144747.580887465@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Darren Hart <darren@os.amperecomputing.com>

commit 190233164cd77115f8dea718cbac561f557092c6 upstream.

Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
on Altra machines") identifies the Altra family via the family field in
the type#1 SMBIOS record. eMAG and Altra Max machines are similarly
affected but not detected with the strict strcmp test.

The type1_family smbios string is not an entirely reliable means of
identifying systems with this issue as OEMs can, and do, use their own
strings for these fields. However, until we have a better solution,
capture the bulk of these systems by adding strcmp matching for "eMAG"
and "Altra Max".

Fixes: 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap() on Altra machines")
Cc: <stable@vger.kernel.org> # 6.1.x
Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
Tested-by: Justin He <justin.he@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -20,10 +20,13 @@ static bool system_needs_vamap(void)
 	const u8 *type1_family = efi_get_smbios_string(1, family);
 
 	/*
-	 * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
-	 * has not been called prior.
+	 * Ampere eMAG, Altra, and Altra Max machines crash in SetTime() if
+	 * SetVirtualAddressMap() has not been called prior.
 	 */
-	if (!type1_family || strcmp(type1_family, "Altra"))
+	if (!type1_family || (
+	    strcmp(type1_family, "eMAG") &&
+	    strcmp(type1_family, "Altra") &&
+	    strcmp(type1_family, "Altra Max")))
 		return false;
 
 	efi_warn("Working around broken SetVirtualAddressMap()\n");


