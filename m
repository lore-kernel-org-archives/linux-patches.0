Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A60D2E64F;
	Fri, 24 Nov 2023 19:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZVqS7xK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5402C433C8;
	Fri, 24 Nov 2023 19:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852903;
	bh=0Z8tLaq+3nq/83TEB73/h3IN4ph06Ze+55hnzSdJFBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UZVqS7xK1NV/uDIXwB9aid3YmpDoycwaMPxPtSxuEZ1VkP9SZqLMu3BYkStOhcpIT
	 5MFy5Fdvs2QQlpuuOTNlam06EUpl4IKyct5YfczFiukU1smy8eRiNwXRzuHbKckktZ
	 QNVIvRCTzGMVbdrFH3CK219mi4xMZj+N8lcZ6N3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 143/193] parisc/power: Fix power soft-off when running on qemu
Date: Fri, 24 Nov 2023 17:54:30 +0000
Message-ID: <20231124171952.922051543@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 6ad6e15a9c46b8f0932cd99724f26f3db4db1cdf upstream.

Firmware returns the physical address of the power switch,
so need to use gsc_writel() instead of direct memory access.

Fixes: d0c219472980 ("parisc/power: Add power soft-off when running on qemu")
Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/parisc/power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/parisc/power.c
+++ b/drivers/parisc/power.c
@@ -196,7 +196,7 @@ static struct notifier_block parisc_pani
 static int qemu_power_off(struct sys_off_data *data)
 {
 	/* this turns the system off via SeaBIOS */
-	*(int *)data->cb_data = 0;
+	gsc_writel(0, (unsigned long) data->cb_data);
 	pdc_soft_power_button(1);
 	return NOTIFY_DONE;
 }


