Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAF0BE46;
	Tue,  8 Jul 2025 16:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993659; cv=none; b=IubPMv7/JEr4BSVH5McfqNBAoo1ES1yvkI4CVTv3q3BG97I0CWypJOKsPDw6BXo71qCY5xX9VCdTKdjI3uLDM/vgX6u3/n3DefWX5inwVXt83lSP3K01j3zbPEnlzk17Y7saQHzQFVzyd9qebFP7k62E2tpg7y11Cs+FJvUJNs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993659; c=relaxed/simple;
	bh=1gvlkFzzNKqd8bOdstp6iwfobqSFci5JQUTfKR40q5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozbVGgVn5ycG4v8QMs0Po8oJfVq2scd74Rr0oouJbXn7426+6FynVQ8tuB5Vs43JCdUTW63FVP8YQpy5p85BVD1zkdD2M8SHDg3u9PFmcY5Tf+c3VB7Vj+Uug7JxP6sA61V0KsQzOZkxip4UEl5ItuV66rxe2l5vRZ19nIJ59Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obEhDEym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obEhDEym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E759AC4CEED;
	Tue,  8 Jul 2025 16:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993659;
	bh=1gvlkFzzNKqd8bOdstp6iwfobqSFci5JQUTfKR40q5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obEhDEymMfCr4tKHjtE4pTVDWWmFMtJUCIgmk5Zm6SmS4wiqmgVNju+zq8tUtY0ET
	 5f8N2y0AgbaO0k5LW8wLsnfvGdfcySO/u+P3uClW0yG1Bj/iDCaxL5jvfisDlQNZK/
	 9M0uPnTH7WLarb/5hMixlb5p5Euu7FdDXnMxuP/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hongliang Yang <hongliang.yang@cixtech.com>,
	Fugang Duan <fugang.duan@cixtech.com>,
	Peter Chen <peter.chen@cixtech.com>
Subject: [PATCH 6.15 150/178] usb: cdnsp: do not disable slot for disabled slot
Date: Tue,  8 Jul 2025 18:23:07 +0200
Message-ID: <20250708162240.431790597@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


