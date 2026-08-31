Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70FE43E484;
	Mon, 31 Aug 2026 13:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184675; cv=none; b=FQAKAVt7AK7UEIwNeSR0v1HQaHOsROq/5Q785hFQaHFXJpTjdHZniZYL9GGkspsANJ652y6hK0nX2v0PYhLAr6bPk/Ocs2mPhlMi97VFwF1AmgPFl0EfUA8nuXtxv13qTJLQG3eNECXL9ww4/pQbmWwZ4s/6H5bww+d2KKfB7jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184675; c=relaxed/simple;
	bh=IKf2WBDbZ1yVe+owVt7QUSbhK2pkhrQlgJ+nBhY+Me8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fy8WjBiR9LMelfkvyg8999++fCFyZrUYB6zwyF+b17zzfl1RHETDPN0LKHqehgmktp5UKSrDA7FULh+CpBfYwVLYIp2UHMfQxKXsF0tU2QpU5kkx/G5h9qWH3TXgLoCb/tq7oVvUd0OJiqHoHP3obWhCaH4fCnBCW13XCdjcK2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I7NzDZoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7NzDZoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF341F00A3E;
	Mon, 31 Aug 2026 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184674;
	bh=ZA3jrEckKRFdtPErHOc8Tb0sNZtLZdrctLP17BsWa0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7NzDZoHJWFmmb5kSNtR2aFv8IcP1zFiHOJNgLbrL2zdP+5HdiTffX+QIkpmewt0R
	 7EpAvKnthsQvJ7z1fTQdiGSFnfU5LSkJa8iU+WrCiV7Wk27sjPah9EzpufysPNKO21
	 eEiK2pfpdWY5imeU4cs42i2V9grls7yetO/DWkjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.6 90/91] USB: c67x00: fix use-after-free in c67x00_add_iso_urb()
Date: Mon, 31 Aug 2026 15:35:18 +0200
Message-ID: <20260831133404.105395637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit b1e24de475bf2d66fffc9103f3444b783527d55a upstream.

When TD creation fails for the last packet of an isochronous URB,
c67x00_add_iso_urb() gives the URB back before updating the endpoint
scheduling state.

c67x00_giveback_urb() frees the URB private data, and the completion
callback may release the final URB reference. The following accesses to
urbp->ep_data, urb->interval, and urbp->cnt can therefore use freed
memory.

Update next_frame and cnt before giving back the failed final packet,
making the giveback the last operation that uses the URB and its private
data.

Fixes: e9b29ffc519b ("USB: add Cypress c67x00 OTG controller HCD driver")
Cc: stable@vger.kernel.org
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Link: https://patch.msgid.link/20260806013502.322067-1-shuangpeng.kernel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/c67x00/c67x00-sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -761,13 +761,13 @@ static int c67x00_add_iso_urb(struct c67
 				ret);
 			urb->iso_frame_desc[urbp->cnt].actual_length = 0;
 			urb->iso_frame_desc[urbp->cnt].status = ret;
-			if (urbp->cnt + 1 == urb->number_of_packets)
-				c67x00_giveback_urb(c67x00, urb, 0);
 		}
 
 		urbp->ep_data->next_frame =
 		    frame_add(urbp->ep_data->next_frame, urb->interval);
 		urbp->cnt++;
+		if (ret && urbp->cnt == urb->number_of_packets)
+			c67x00_giveback_urb(c67x00, urb, 0);
 	}
 	return 0;
 }


