Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474E64E7802;
	Tue, 13 Oct 2026 12:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895166; cv=none; b=V3Ctdpe2LDqWmsRfZzDVFOGr0SvvqbiuHSuFLuPpvYP2KD2QcV5/dHfKy6xSIiftfu/bxYXrK00pCtQCd6OyI980ETVCV8I5b6QdHx1wKnRkzxdd6X9ANFnDmO2kM5mkZ6mHFsfimYNn5vBQZi9lMqhnv4qymPKV+ZosPJnTa9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895166; c=relaxed/simple;
	bh=WQ/JW93EWFHxkAyZDcwKHcEv1D0jcHZ3lY2RhdJEJ4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/L4W1XPoVbxFE1Gw/rVN0vqtgkc/ZnAUTHpaPa49o2Ry9HbXbyVqGx4CyShUR+ZtqVbB78sQJfO1zblqRHcis8kuIRcSZWgPJoqD2OCTJU3wEyiiqj8DSkOVWGrANuL5YixZ+yGU8cjJ3B6fXrJFWwAUDpSQQMgdegxrOlQIwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCZqSsm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCZqSsm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D211F000FF;
	Tue, 13 Oct 2026 12:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895164;
	bh=QODDaA9/vhRvQmhSLv3H1t7DIqKuzXEAdf+zoK0AQF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCZqSsm0My0cq3vsguAJ7LglnPs5m5ODSMYGDD3xUGFsedAJD9wajTBecSl0oa1p6
	 T8QPC6g+V51bmy79NTV3OHmYGrttctspcF5/xDXnPI06jLOdyKhsQ3eNmB4JrB5sbC
	 RUidJc9pwyyKYtq5FSX4x7Ek8/0Lv57+fHnU2SPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 139/497] usb: ohci-da8xx: disable controller wakeup on cleanup
Date: Tue, 13 Oct 2026 13:35:06 +0200
Message-ID: <20261013112911.188663494@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 901197dd4c7dcffbf97426487d4c047555c98554 upstream.

The OHCI core marks controllers with RemoteWakeupConnected as
wakeup-capable. Probe enables wakeup, but neither removal nor a later
notifier registration failure disables it, leaving the wakeup source
attached.

Disable controller wakeup after removing the HCD on both paths.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: a6eeeb9f45b5 ("USB: Update USB default wakeup settings")
Cc: stable <stable@kernel.org>
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260915012011.61874-2-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-da8xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/ohci-da8xx.c
+++ b/drivers/usb/host/ohci-da8xx.c
@@ -464,6 +464,7 @@ static int ohci_da8xx_probe(struct platf
 
 err_remove_hcd:
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 err:
 	usb_put_hcd(hcd);
 	return error;
@@ -474,6 +475,7 @@ static void ohci_da8xx_remove(struct pla
 	struct usb_hcd	*hcd = platform_get_drvdata(pdev);
 
 	usb_remove_hcd(hcd);
+	device_wakeup_disable(hcd->self.controller);
 	usb_put_hcd(hcd);
 }
 


