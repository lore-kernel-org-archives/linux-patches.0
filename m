Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D00818E77F;
	Tue, 10 Sep 2024 09:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961585; cv=none; b=M5VsG/fyN7J+jQw1xEVgqwvtwMSwnIHvjNLHM3FNHCCs/tmec+zb927cUYY16VFUXnAHc5Xpk+4ISZPqnx56sRxQsnCxJFaSTQinq2hwvzErBmFtPrgR5NQNqJmBHdG9nWs+Y2s2nuluqFZhnwjipgNV7YAR0TRgXkKYg6+U8Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961585; c=relaxed/simple;
	bh=qKa1Ei56f0OHXxshoXvOg/r6X6zTe26QCoIG+vhjwd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqXG3hyxjQOVUM3MHcbDUiTQIk3he03hI+FyphHAnRypdsZoAPjkXVFFMvHuvGKp3a6D7N+tBHPCJR5eZ3qxmBehOOnMzBqr7ihHoMK84hGvtpbBxT7Bibtal5FfTcp+uXXHbaNCS0KIX0TDNpWzzUrnYowjKpbiQaSEIXKVD0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLT/9E2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLT/9E2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61CCC4CEC6;
	Tue, 10 Sep 2024 09:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961585;
	bh=qKa1Ei56f0OHXxshoXvOg/r6X6zTe26QCoIG+vhjwd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLT/9E2xegqP7fB4UBBx8f89d+F2p3pGugelAXxTGjK3pWzFV/G6rgvm7I1NlyuFw
	 F9pUVTJP3s1bPLtsZ3WnT8Lk0PfROEWCQiGvPuq+2e127jXzJz7pSVZjcLLzrJYZAl
	 jYFmvbJoHP9xHNvQQUpYEkI1LTfhNxfjoPIwP2w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shantanu Goel <sgoel01@yahoo.com>,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 120/375] usb: uas: set host status byte on data completion error
Date: Tue, 10 Sep 2024 11:28:37 +0200
Message-ID: <20240910092626.467061678@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shantanu Goel <sgoel01@yahoo.com>

[ Upstream commit 9d32685a251a754f1823d287df233716aa23bcb9 ]

Set the host status byte when a data completion error is encountered
otherwise the upper layer may end up using the invalid zero'ed data.
The following output was observed from scsi/sd.c prior to this fix.

[   11.872824] sd 0:0:0:1: [sdf] tag#9 data cmplt err -75 uas-tag 1 inflight:
[   11.872826] sd 0:0:0:1: [sdf] tag#9 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
[   11.872830] sd 0:0:0:1: [sdf] Sector size 0 reported, assuming 512.

Signed-off-by: Shantanu Goel <sgoel01@yahoo.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/87msnx4ec6.fsf@yahoo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/storage/uas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index b610a2de4ae5..a04b4cb1382d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -423,6 +423,7 @@ static void uas_data_cmplt(struct urb *urb)
 			uas_log_cmd_state(cmnd, "data cmplt err", status);
 		/* error: no data transfered */
 		scsi_set_resid(cmnd, sdb->length);
+		set_host_byte(cmnd, DID_ERROR);
 	} else {
 		scsi_set_resid(cmnd, sdb->length - urb->actual_length);
 	}
-- 
2.43.0



