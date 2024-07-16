Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC35119E809;
	Tue, 16 Jul 2024 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145135; cv=none; b=hnQAgLzGBdK3L0GRPTMe3v9+MXoBbpLBIhodLnSIEQZ7s2vN5SdeZhLo4Uch0kJIVsY4oubj3Qlsk/8DxzH6z64k16weZ7XKbeKdZNXTxQgi2VmlWmD4d8VVDUocDlPLsEM34NiivoxGVICAqJX3pxuZ46obFfr/fmwrLM1eeCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145135; c=relaxed/simple;
	bh=+8L2tPgsUiWKNnbY3CciScwm219vFT6/CD3SawtT4LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEqyqapp7X7hf+aNQotuaSJ3mSIMZCajyRqrvz7jBTFHWdFLk5kiqlC5w9eHQ3vnCZl01pXeTPT20KXqA8y/B9tNn3hWjvCSLZsFMvCIZ6rmmRaPiJfKCyGmK7T16XgwB2BZa68eOznSDqoy4YjhmfmgpFZhbe2CUjSQqmKlrEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wy9PzH7i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wy9PzH7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9AFC4AF0B;
	Tue, 16 Jul 2024 15:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145135;
	bh=+8L2tPgsUiWKNnbY3CciScwm219vFT6/CD3SawtT4LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wy9PzH7ioZtfLAW4EN8rjKK7JpbQR1CPvLoJXK6b5O8EneTVy+/WUyh2yf1mx0DmJ
	 maE0zIGuTBqUHRKuF283lOFPrPYDc+X9Z9Zb8DcpLqcQE9wS5KNG1lsn7d/r3SuEWX
	 f9LvYFqGPlB41WdPNVEOruUDCwZW44h9jJDuDD10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentong Wu <wentong.wu@intel.com>,
	Jason Chen <jason.z.chen@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.9 110/143] mei: vsc: Prevent timeout error with added delay post-firmware download
Date: Tue, 16 Jul 2024 17:31:46 +0200
Message-ID: <20240716152800.208810062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentong Wu <wentong.wu@intel.com>

commit a9e8fe38195ae6f8e5b32907a17b397ff3ce3e48 upstream.

After completing the firmware download, the firmware requires some
time to become functional. This change introduces additional sleep
time before the first read operation to prevent a confusing timeout
error in vsc_tp_xfer().

Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Cc: stable@vger.kernel.org # for 6.8+
Signed-off-by: Wentong Wu <wentong.wu@intel.com>
Tested-by: Jason Chen <jason.z.chen@intel.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://lore.kernel.org/r/20240625081047.4178494-3-wentong.wu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/platform-vsc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/misc/mei/platform-vsc.c
+++ b/drivers/misc/mei/platform-vsc.c
@@ -28,8 +28,8 @@
 
 #define MEI_VSC_MAX_MSG_SIZE		512
 
-#define MEI_VSC_POLL_DELAY_US		(50 * USEC_PER_MSEC)
-#define MEI_VSC_POLL_TIMEOUT_US		(200 * USEC_PER_MSEC)
+#define MEI_VSC_POLL_DELAY_US		(100 * USEC_PER_MSEC)
+#define MEI_VSC_POLL_TIMEOUT_US		(400 * USEC_PER_MSEC)
 
 #define mei_dev_to_vsc_hw(dev)		((struct mei_vsc_hw *)((dev)->hw))
 


