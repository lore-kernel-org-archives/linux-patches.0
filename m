Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92393F23B3;
	Tue, 17 Mar 2026 16:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766761; cv=none; b=Flb95O6VmxDv2Z3EZtt27W/7ZzHadWu8hSIC0OD6voGkWZXv+PaPHdiY0vpttKxNUpdUy7GHdv3ieZZI5cRtOQ8IKn8zsxm6umVGubY1WLrpdrF+1nbPniauJ54uDndfhSt77cgf/lJJEpINHs1Yil+qIjKpKr9uMzYxFRkVMZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766761; c=relaxed/simple;
	bh=VXD1vzjG817AaMyFHHf2NDX/Dcy4H7XTZnQl2CXbN2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxeoT5LYReIeEhhtvTY35ypY1JlvwO2YxXlgXCf349bNqwdzkylQQsFbQPnLKhHMnJT+9ZV9tqXMLGbCbXn7PdSfROu3jmiM7ttrTqwR/+3IlZgJHMhvhfnNzjpqtM7yklYsIQYA/KdT3XSVZAoaOLey1kRel0aiIYSHF40GDxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMZEv6Xg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMZEv6Xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3A3C4CEF7;
	Tue, 17 Mar 2026 16:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766761;
	bh=VXD1vzjG817AaMyFHHf2NDX/Dcy4H7XTZnQl2CXbN2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMZEv6XgKS0nBb9AzJK48KxceglS/y5kwJQcQ2u9YGTBE5XMGHa18wNt1IhTql1QM
	 uXgr9dT45SNWV4qzdXwmO/oVjb9lOXBVsLC/Ka1RZD70uyIrDlMAMHZFMuPMlWJl9M
	 QX+MKmwsI8mmK01ggn7FFCbHjxJQEVSOPRIS/uTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.19 316/378] can: dev: keep the max bitrate error at 5%
Date: Tue, 17 Mar 2026 17:34:33 +0100
Message-ID: <20260317163018.618383806@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit 1eea46908c57abb7109b1fce024f366ae6c69c4f upstream.

Commit b360a13d44db ("can: dev: print bitrate error with two decimal
digits") changed calculation of the bit rate error from on-tenth of a
percent to on-hundredth of a percent, but forgot to adjust the scale of the
CAN_CALC_MAX_ERROR constant.

Keeping the existing logic unchanged: Only when the bitrate error exceeds
5% should an error be returned. Otherwise, simply output a warning log.

Fixes: b360a13d44db ("can: dev: print bitrate error with two decimal digits")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Link: https://patch.msgid.link/20260306-can-fix-v1-1-ac526cec6777@nxp.com
Cc: stable@kernel.org
[mkl: improve commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/dev/calc_bittiming.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/calc_bittiming.c b/drivers/net/can/dev/calc_bittiming.c
index cc4022241553..42498e9d3f38 100644
--- a/drivers/net/can/dev/calc_bittiming.c
+++ b/drivers/net/can/dev/calc_bittiming.c
@@ -8,7 +8,7 @@
 #include <linux/units.h>
 #include <linux/can/dev.h>
 
-#define CAN_CALC_MAX_ERROR 50 /* in one-tenth of a percent */
+#define CAN_CALC_MAX_ERROR 500 /* max error 5% */
 
 /* CiA recommended sample points for Non Return to Zero encoding. */
 static int can_calc_sample_point_nrz(const struct can_bittiming *bt)
-- 
2.53.0



