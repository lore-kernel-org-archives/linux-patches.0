Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A214819B5BE;
	Thu, 25 Jul 2024 14:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918412; cv=none; b=Je4EfL0kka1J3xxN4YxX/ZNA0u3IN2IGobCpy/XZy/+E7M5u9lNWQ+vf+gsOpVTOAbC4X6/wUqSKlPzVhhxamxigU71/lK6iPtZAb7Dnw9EksPt7bx2ErFcGKD/w2NWPZvLG28qu8n/yRJnpYvueHd5NgGc7Y0IJwkCs37DyMek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918412; c=relaxed/simple;
	bh=ibOWO7LX2eDChBhHmKPh1wkla7GA1fpfLKrVi0AGwJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4ecJ7wQ+0DXCFUNxt369R3wZTcb0JnBtdw/de8yhuq+5Nw3wFKIcE/Udu1Ea0Irv0UqIPnxspxID0RFYvO+ZATA6BZRRyVRKXfwwwqKmEgPqxX4Pt1aNZossU0gQdcMB+ofXI2TjVq4kDOfpl5duw7ctN9DXRYK3NMY7bvdYiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvX/SdK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvX/SdK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D433C116B1;
	Thu, 25 Jul 2024 14:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918412;
	bh=ibOWO7LX2eDChBhHmKPh1wkla7GA1fpfLKrVi0AGwJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvX/SdK2SrBlWTawuvR0cWS2ycz53IuwMtCKyZO2DqsRbl5kHbP+USQz/v58P7DfW
	 7hH3pWBOY0jjbS1dd8WS91wbrl/Al1c/YH4/xezBwNikB1n9PuQ+YoQ7NLki5lcsvx
	 XQq8S75PxoFN4+5oQ58AkFKZbWs3b3iEnfLWWnZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/33] mei: demote client disconnect warning on suspend to debug
Date: Thu, 25 Jul 2024 16:36:35 +0200
Message-ID: <20240725142728.985428273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
References: <20240725142728.511303502@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

[ Upstream commit 1db5322b7e6b58e1b304ce69a50e9dca798ca95b ]

Change level for the "not connected" client message in the write
callback from error to debug.

The MEI driver currently disconnects all clients upon system suspend.
This behavior is by design and user-space applications with
open connections before the suspend are expected to handle errors upon
resume, by reopening their handles, reconnecting,
and retrying their operations.

However, the current driver implementation logs an error message every
time a write operation is attempted on a disconnected client.
Since this is a normal and expected flow after system resume
logging this as an error can be misleading.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240530091415.725247-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 87281b3695e60..e87c2b13c381e 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -271,7 +271,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (!mei_cl_is_connected(cl)) {
-		cl_err(dev, cl, "is not connected");
+		cl_dbg(dev, cl, "is not connected");
 		rets = -ENODEV;
 		goto out;
 	}
-- 
2.43.0



