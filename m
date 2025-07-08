Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02D61548C;
	Tue,  8 Jul 2025 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992572; cv=none; b=qGYvuzRmvzgDguxzGwAtzlIWWbpjnIByDxct0ei+WXPj8q40FeP25zl/4+CDGmbdjc45tACtU7M6PdfjlHFpC+iaTJUBi19j+BhR3S+gZoRQGDPz1hMYemQ8p9gEwOgm60n+2+AhDGd5rnBtIPvlA4U3kBnDJqSOGSBzrAgLwz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992572; c=relaxed/simple;
	bh=RSxZ+ZFeYE+ZSD/c3zPqYdWxzC6KUuf5klcbqzeiHik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpaPeVsL191uhHS1VvXZ6wNnX5GHZxyOkSxZ3ZF4mtzQ600HJ1EbTV/Xi6SpRtWNOCvLCYi0lF7JUTNR3q7NaWIpd6UnGXPkcPHN6uPNXKIgmOL6emF/5m5NAXJpOUzofBwGCtEyyAumjuOQm6WHz7t4nCdT3k6B0CKMMtAMJNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElWMExXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElWMExXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FFEC4CEED;
	Tue,  8 Jul 2025 16:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992572;
	bh=RSxZ+ZFeYE+ZSD/c3zPqYdWxzC6KUuf5klcbqzeiHik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElWMExXAmkAFtPVBTpVfiGEKzlSHOGkSfiqFUpVJescuZ1h4Y7ZFWq1t9Yu8nFxxU
	 HWQl2/pz3gYTs57k4DM5pP7K6abDtOEnuTodJtippC65CEsxybK3nezi9FH6qCo04h
	 Vj58igwD0pHu7F1+BIJ+fPGgtonN9UxCtSDr/zmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongliang Yang <hongliang.yang@cixtech.com>,
	Fugang Duan <fugang.duan@cixtech.com>,
	Peter Chen <peter.chen@cixtech.com>
Subject: [PATCH 6.6 115/132] usb: cdnsp: do not disable slot for disabled slot
Date: Tue,  8 Jul 2025 18:23:46 +0200
Message-ID: <20250708162233.928833204@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@cixtech.com>

commit 7e2c421ef88e9da9c39e01496b7f5b0b354b42bc upstream.

It doesn't need to do it, and the related command event returns
'Slot Not Enabled Error' status.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@kernel.org>
Suggested-by: Hongliang Yang <hongliang.yang@cixtech.com>
Reviewed-by: Fugang Duan <fugang.duan@cixtech.com>
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://lore.kernel.org/r/20250619013413.35817-1-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -772,7 +772,9 @@ static int cdnsp_update_port_id(struct c
 	}
 
 	if (port_id != old_port) {
-		cdnsp_disable_slot(pdev);
+		if (pdev->slot_id)
+			cdnsp_disable_slot(pdev);
+
 		pdev->active_port = port;
 		cdnsp_enable_slot(pdev);
 	}


