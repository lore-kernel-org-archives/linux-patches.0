Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0B019E992;
	Tue, 12 Nov 2024 10:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408517; cv=none; b=r1+FUsl5kZYqolmLg5hSBJZXSHQmc++8sDHluMzfZ4Ie2A/IrcuoDtdoegOx3ZhGeCVxhD8XOrlVDh9vxFLyA0LDGYPZYTcu70GPxBn3nnw5ADU5r2NuN/2963GTQS73RHpK4My1Qs1pvKUbkAeziFHNW9ELeoIpAjlmYqbZ/XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408517; c=relaxed/simple;
	bh=DL18UrsICnRHsaAu4SFn4Uw70rYYU0JSe3cPf+y322o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cK31AGjnB/r/EMKjf9h+Z+nJf8FXwblCIIYkAZpHUII8as5djVytof50kiLPRYvUNewnIEv/kVSpIhsZ+BWbGUhVaWjV0Kppde/sn4Kvrkaxqvpyd82TsEiJbUfHaiBb7fJS15mEWjcU4QWvzZRHVgs1GyDuPCHPHRzo4BjkZOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErFHAgWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErFHAgWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3ACC4CED6;
	Tue, 12 Nov 2024 10:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408517;
	bh=DL18UrsICnRHsaAu4SFn4Uw70rYYU0JSe3cPf+y322o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ErFHAgWjcqXrTNG/+uDqGDA3EZ5EhTI81EJwkCqJm179xtLn52EDf8v9URLLHuB3v
	 6Fbj2qxc5jOHpAU6Ybii8BoKAcJd2JetD6fgfNlPqCeVJgaPyRETWxE+TFr6DMmdm4
	 Rz8XYQQK438kwYhyVdXPbJzpNQsqvTyZ+uQ99ogE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Lahaye <rick@581238.xyz>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.11 166/184] thunderbolt: Fix connection issue with Pluggable UD-4VPD dock
Date: Tue, 12 Nov 2024 11:22:04 +0100
Message-ID: <20241112101907.239463857@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit bd646c768a934d28e574ee940d6759c7954a024d upstream.

Rick reported that his Pluggable USB4 dock does not work anymore after
upgrading to v6.10 kernel.

It looks like commit c6ca1ac9f472 ("thunderbolt: Increase sideband
access polling delay") makes the device router enumeration happen later
than what might be expected by the dock (although there is no such limit
in the USB4 spec) which probably makes it assume there is something
wrong with the high-speed link and reset it. After the link is reset the
same issue happens again and again.

For this reason lower the sideband access delay from 5ms to 1ms. This
seems to work fine according to Rick's testing.

Reported-by: Rick Lahaye <rick@581238.xyz>
Closes: https://lore.kernel.org/linux-usb/000f01db247b$d10e1520$732a3f60$@581238.xyz/
Tested-by: Rick Lahaye <rick@581238.xyz>
Fixes: c6ca1ac9f472 ("thunderbolt: Increase sideband access polling delay")
Cc: stable@vger.kernel.org
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/usb4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 0a9b4aeb3fa1..402fdf8b1cde 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -48,7 +48,7 @@ enum usb4_ba_index {
 
 /* Delays in us used with usb4_port_wait_for_bit() */
 #define USB4_PORT_DELAY			50
-#define USB4_PORT_SB_DELAY		5000
+#define USB4_PORT_SB_DELAY		1000
 
 static int usb4_native_switch_op(struct tb_switch *sw, u16 opcode,
 				 u32 *metadata, u8 *status,
-- 
2.47.0



