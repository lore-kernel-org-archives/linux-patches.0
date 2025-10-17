Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5D72F12D1;
	Fri, 17 Oct 2025 15:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715316; cv=none; b=bPj38Rd+pDngsbV7jB2uxXFlWerunaXZnjoxPsK5NggXi43I4E1KkY5+STRrhBsdYCzpNvSGShft4XlfOn6ZU1D9VUbeBIiNoL4P4bjxU03Dp4RkMgXe5wn7oQtsoSdeltZ0U985qy0ZFSQD8TBvbmwreMH15UxDUSwecJeYBPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715316; c=relaxed/simple;
	bh=ay2TSw3HC/SUGTmT6eV6o+yno0VajNsBXhziLCx1o+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTCLaSkb8HbpDlvvLY8AD0w1VgusoOgkqz4W7zFNgQMA1QgZfgsheqkfV3kR3MFYb9M83b5AkM8S/XEyKit/pmzEkyUTJb+2dpRsFqwwUkwhATbxSAWDB13AbNn1oho7uabH7s1mD33yE+hPkEnzbv8LSWOM8BGCC7vtJJnvVaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dPGfA2tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPGfA2tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D57C113D0;
	Fri, 17 Oct 2025 15:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715315;
	bh=ay2TSw3HC/SUGTmT6eV6o+yno0VajNsBXhziLCx1o+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPGfA2tjhRwrI0ho8cZGrZZzYlr0FmmUe6LEc0TbWGGehGgcCH8Qd7Z2Ey+JXRqmq
	 Ze3OieczR6o2QNlz02jesawghspCgmNdFAa7Tl3ublNhXaqW3ag8SAoQ4mBYqY1ble
	 JvOJ2B7IZeHGzdVUoWQhiPLrgDDHMspWJTpsXpSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 174/371] media: pci: mg4b: fix uninitialized iio scan data
Date: Fri, 17 Oct 2025 16:52:29 +0200
Message-ID: <20251017145208.226033658@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

commit c0d3f6969bb4d72476cfe7ea9263831f1c283704 upstream.

Fix potential leak of uninitialized stack data to userspace by ensuring
that the `scan` structure is zeroed before use.

Fixes: 0ab13674a9bd ("media: pci: mgb4: Added Digiteq Automotive MGB4 driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/mgb4/mgb4_trigger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/pci/mgb4/mgb4_trigger.c
+++ b/drivers/media/pci/mgb4/mgb4_trigger.c
@@ -91,7 +91,7 @@ static irqreturn_t trigger_handler(int i
 	struct {
 		u32 data;
 		s64 ts __aligned(8);
-	} scan;
+	} scan = { };
 
 	scan.data = mgb4_read_reg(&st->mgbdev->video, 0xA0);
 	mgb4_write_reg(&st->mgbdev->video, 0xA0, scan.data);


