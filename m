Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04BA248BA0;
	Wed, 15 Jan 2025 10:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937736; cv=none; b=eR5se/fciqboVornCShDDYILP4cur0Ufers0NtffK638fL1lrbAxnXQFRJQvSixuOYQeKMKwWKqKgj8+4sHpAPua8oAd2+RMnP427F7EX8wg5MYL/c1uWP+EZ21idX9gYL4CYsBtxGxYy3x0hYDM9ai00CAWU8pZPjVd9GzJM/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937736; c=relaxed/simple;
	bh=jQocUdsV1f6sk2LYIaeNKTi6lDknX43Co4af8B2nVt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m6nuTKJ1fmyexjdwE/Wc/xiu02KISVuQScfV65AcdML8EWGW3ALkF4GGGo9/ohV0G3hZJorF7QDKV9hXcbrb8bTDiSspFOwjQ/vozs4NXQi4suXI3L6PPSMcmEp/sIj6oSk3CvX9rdY77ilpOlYv8E2nZ19oIAlcasYn7dhbu3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uj1tKBLz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uj1tKBLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F54AC4CEE2;
	Wed, 15 Jan 2025 10:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937736;
	bh=jQocUdsV1f6sk2LYIaeNKTi6lDknX43Co4af8B2nVt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uj1tKBLz74EVJcRfnz1H2RZr/vGR3kOBCKyulzsOVTuGVYOvSSMjgO5p2vN3fHuFA
	 4AyN+dFstXwS7AHgD3fR4zE1yZySVpiWTPglU4VY0o2TnDtZARe54jfsg8cehLuHe2
	 xYJREbDktpaBo2x7/TbgYwScOvioT0IUFH5dHcDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <quic_prashk@quicinc.com>
Subject: [PATCH 6.1 67/92] usb: gadget: f_uac2: Fix incorrect setting of bNumEndpoints
Date: Wed, 15 Jan 2025 11:37:25 +0100
Message-ID: <20250115103550.229025697@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 057bd54dfcf68b1f67e6dfc32a47a72e12198495 upstream.

Currently afunc_bind sets std_ac_if_desc.bNumEndpoints to 1 if
controls (mute/volume) are enabled. During next afunc_bind call,
bNumEndpoints would be unchanged and incorrectly set to 1 even
if the controls aren't enabled.

Fix this by resetting the value of bNumEndpoints to 0 on every
afunc_bind call.

Fixes: eaf6cbe09920 ("usb: gadget: f_uac2: add volume and mute support")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Link: https://lore.kernel.org/r/20241211115915.159864-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -1176,6 +1176,7 @@ afunc_bind(struct usb_configuration *cfg
 		uac2->as_in_alt = 0;
 	}
 
+	std_ac_if_desc.bNumEndpoints = 0;
 	if (FUOUT_EN(uac2_opts) || FUIN_EN(uac2_opts)) {
 		uac2->int_ep = usb_ep_autoconfig(gadget, &fs_ep_int_desc);
 		if (!uac2->int_ep) {


