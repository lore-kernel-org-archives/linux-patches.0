Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D6A8486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A252C433C1;
	Thu, 27 Oct 2022 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889946;
	bh=ojMYa8cMqS9ptbuTQW+4MrXlRTJ//MoTiOoHBkxUJhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K95N9IRkj8Ti6FYCzeOasmR2Mvaw18iwyAx1IAuZwiXVM/bozgBOogl1QW/U+PI0v
	 /j8+1p5rT/zBHqkXtxnak8bDYFv7Hduhm+jildB2wDVb0QOkQhJCLSuX+DO6kjS6K5
	 AucInbd3d9Jf77/aeb+COuBn5DX+NKCFKBZGNbTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	You-Sheng Yang <vicamo.yang@canonical.com>,
	Anson Tsao <anson.tsao@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.0 28/94] platform/x86/amd: pmc: Read SMU version during suspend on Cezanne systems
Date: Thu, 27 Oct 2022 18:54:30 +0200
Message-Id: <20221027165058.214888326@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 0b6e6e149c136677f1cc859d4185b5a2db50ffbf upstream.

commit b0c07116c894 ("platform/x86: amd-pmc: Avoid reading SMU version at
probe time") adjusted the behavior for amd-pmc to avoid reading the SMU
version at startup but rather on first use to improve boot time.

However the SMU version is also used to decide whether to place a timer
based wakeup in the OS_HINT message. If the idlemask hasn't been read
before this message was sent then the SMU version will not have been
cached.

Ensure the SMU version has been read before deciding whether or not to
run this codepath.

Cc: stable@vger.kernel.org # 6.0
Reported-by: You-Sheng Yang <vicamo.yang@canonical.com>
Tested-by: Anson Tsao <anson.tsao@amd.com>
Fixes: b0c07116c894 ("platform/x86: amd-pmc: Avoid reading SMU version at probe time")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20221020113749.6621-2-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -635,6 +635,13 @@ static int amd_pmc_verify_czn_rtc(struct
 	struct rtc_time tm;
 	int rc;
 
+	/* we haven't yet read SMU version */
+	if (!pdev->major) {
+		rc = amd_pmc_get_smu_version(pdev);
+		if (rc)
+			return rc;
+	}
+
 	if (pdev->major < 64 || (pdev->major == 64 && pdev->minor < 53))
 		return 0;
 


