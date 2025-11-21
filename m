Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAEB3F9D2;
	Fri, 21 Nov 2025 13:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731855; cv=none; b=f1gl8WiBcKmTfSyY9vpZmEDA80mEroB5PeKHLNUDU6c//LGCXF+CaSXMd4heaSVDch2rWAiJCmlPpcFQ2IhDdpnQk06TfDqcNA0U8kiJZtstRqtWxdRwt//mynr8DDkKVOFddv4zok+qL6iILm6kK0/Ba3z6BR7XUGk8C1IkzlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731855; c=relaxed/simple;
	bh=oMIv46PoKYfj168AbrRszBoAC+0/ZAhzJBP63RQywU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwmpnXtVFqsBElrmZ7GM4eXTnnV6JZi39Od+FApqBRkU44CPuVFyt/kSf6m8NEhgNM5QN91EEawxtQt2clHZEW9vHKcyPjThzE+zLC81hHtUcPJiHKUjXxb0ZUjr9Wfb7kGVOUwLfA+RmqgC9kT3NoY5nOyCCg2bE8TEotYNyEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9ySuY2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9ySuY2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A5AC4CEF1;
	Fri, 21 Nov 2025 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731855;
	bh=oMIv46PoKYfj168AbrRszBoAC+0/ZAhzJBP63RQywU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9ySuY2LqIykxgOsRsLNLDuxYE2njoZVno331Wp6XFml4FmfLCMoTHld/19JiroeL
	 GmVo8aUouItt5tXJM1pSf/3w0iLvdtDEj29JRsWOOHvIblWlGxUIDFdMRnbG+MRfVz
	 hE1N771/j6bRkxlb5EyC4Sv5m/Bk+UD3Y3pEEU3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 104/185] HID: playstation: Fix memory leak in dualshock4_get_calibration_data()
Date: Fri, 21 Nov 2025 14:12:11 +0100
Message-ID: <20251121130147.626558855@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 8513c154f8ad7097653dd9bf43d6155e5aad4ab3 ]

The memory allocated for buf is not freed in the error paths when
ps_get_report() fails. Free buf before jumping to transfer_failed label

Fixes: 947992c7fa9e ("HID: playstation: DS4: Fix calibration workaround for clone devices")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-playstation.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-playstation.c b/drivers/hid/hid-playstation.c
index 1468fb11e39df..657e9ae1be1ee 100644
--- a/drivers/hid/hid-playstation.c
+++ b/drivers/hid/hid-playstation.c
@@ -1807,6 +1807,7 @@ static int dualshock4_get_calibration_data(struct dualshock4 *ds4)
 
 				hid_warn(hdev, "Failed to retrieve DualShock4 calibration info: %d\n", ret);
 				ret = -EILSEQ;
+				kfree(buf);
 				goto transfer_failed;
 			} else {
 				break;
@@ -1824,6 +1825,7 @@ static int dualshock4_get_calibration_data(struct dualshock4 *ds4)
 
 		if (ret) {
 			hid_warn(hdev, "Failed to retrieve DualShock4 calibration info: %d\n", ret);
+			kfree(buf);
 			goto transfer_failed;
 		}
 	}
-- 
2.51.0



