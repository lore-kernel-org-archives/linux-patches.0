Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDB23B2BB;
	Fri,  6 Dec 2024 15:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498150; cv=none; b=RSDMDiHSMJvRArf1f/PJ1ogMxEZXDyTt1XzYGWgzjMPjYplnBqdY5HpHYdOrwViWT2a/X0e+63uJ5KDbsmj8hpeQ5vXYf4c1rIZMbUPbqytTI9LYF1++0erXx6nudXuEqybXte42tzYrzIuFWwH8auvrpbOg/JJOz9NIuuYPUuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498150; c=relaxed/simple;
	bh=OrO2rxSjV57H9uQIGtvKAihMn5UNt/gFuxoU3QVU3gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSc9RrTHWbDQ3hKM5C9K4G7ehlaW+9ikDBzUDFrcKy2cWPxzB5abAQt0pIShX0tkmtkW5z49JCY2ox1EqJkAb2BFG3m1tWAVw3yWk0S9gnfJ59fdkDAzaeETLCOgz76rPwhLN9FpGFWoIPv3MTX5yk0lfvgQdbgda0JOvSPiMKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGjO1d0J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGjO1d0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 121B2C4CED1;
	Fri,  6 Dec 2024 15:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498150;
	bh=OrO2rxSjV57H9uQIGtvKAihMn5UNt/gFuxoU3QVU3gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGjO1d0JziRgImWKbHfsfnZLZk8m8qTuImuUF86DQEg2nr85sz5ji7kH01OPC+sFz
	 o0Jy35nh5dPfYkBOVqM8n5eBpgj5yVzX/vZ9K7q6oc3AV4SqXCbXrXeQI8hoAj1qB8
	 YMTMkpGiU3QXNRZMEOjj/Yr4VKIF/2+TPIek4FaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH 6.6 500/676] wifi: ath12k: fix crash when unbinding
Date: Fri,  6 Dec 2024 15:35:19 +0100
Message-ID: <20241206143712.887724306@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 1304446f67863385dc4c914b6e0194f6664ee764 upstream.

If there is an error during some initialization related to firmware,
the function ath12k_dp_cc_cleanup is called to release resources.
However this is released again when the device is unbinded (ath12k_pci),
and we get:
BUG: kernel NULL pointer dereference, address: 0000000000000020
at RIP: 0010:ath12k_dp_cc_cleanup.part.0+0xb6/0x500 [ath12k]
Call Trace:
ath12k_dp_cc_cleanup
ath12k_dp_free
ath12k_core_deinit
ath12k_pci_remove
...

The issue is always reproducible from a VM because the MSI addressing
initialization is failing.

In order to fix the issue, just set to NULL the released structure in
ath12k_dp_cc_cleanup at the end.

cc: stable@vger.kernel.org
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Link: https://patch.msgid.link/20241017181004.199589-2-jtornosm@redhat.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/dp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1214,6 +1214,7 @@ static void ath12k_dp_cc_cleanup(struct
 	}
 
 	kfree(dp->spt_info);
+	dp->spt_info = NULL;
 }
 
 static void ath12k_dp_reoq_lut_cleanup(struct ath12k_base *ab)


