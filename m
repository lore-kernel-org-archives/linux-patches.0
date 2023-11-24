Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E018439FE3;
	Fri, 24 Nov 2023 18:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSYGC29H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F1BC433C9;
	Fri, 24 Nov 2023 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848950;
	bh=l1cgDIy7Yyw5sm4Jf73CziEVg2htsgRBb9H1AS59JI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSYGC29HtACjYv9P7jMPD37Df2BhdJa89nEwSpkIvDDR3cQo16TC/BqsGg5FpgY20
	 vNFWUtoDZWi6+U/PK5ZRksTo4PXY8AF3OILEVtcGw7dmPCPO/upwwZxqUzvukCjcC1
	 Dcz8lhVIT6TxzsbUHP6d7ONeSaXkS3+JnsXCaHV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 46/57] parisc/power: Fix power soft-off when running on qemu
Date: Fri, 24 Nov 2023 17:51:10 +0000
Message-ID: <20231124171932.020628052@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -197,7 +197,7 @@ static struct notifier_block parisc_pani
 static int qemu_power_off(struct sys_off_data *data)
 {
 	/* this turns the system off via SeaBIOS */
-	*(int *)data->cb_data = 0;
+	gsc_writel(0, (unsigned long) data->cb_data);
 	pdc_soft_power_button(1);
 	return NOTIFY_DONE;
 }


