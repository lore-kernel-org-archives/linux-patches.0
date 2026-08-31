Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D065E4A2E1B;
	Mon, 31 Aug 2026 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185290; cv=none; b=A/MPl50M3YnZ/qJEavJDHHG3i4dULgbGdAy3xeBOa1e7uDeEavaOxAW4BFubPgoF97jmbtXqGwMV6GM9dOH3Xpi2XmEmW0ufEh9IdNX1e/t2MGRYpRZvlbZAY489Js2B8/P4BIpZ2d+clBmDYEZ9LZuZpraQ3ypw+DG/YK7v74w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185290; c=relaxed/simple;
	bh=eA6zRH8O1RYINvbG6w8h4fSsT48R1wIAyzTczS4qxXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIV6yeJJbLLOe0B/9pXODc62sH5TxBPHjUrecdBNjLQZX6RojzOxBtVvVImNgEJfaofM2Ny1gxwAoKMO5oW1kn/3F7uvZcYm3pnoqa5AVqeQQ4ZN3m6kzy6IClA4rdn1Fd1ih8ZM/2nQeWLyw8sFAKfTs0r28T50sVmBe7TfZlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxhkUkRX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxhkUkRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352B61F00A3D;
	Mon, 31 Aug 2026 14:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185288;
	bh=bnin/Z9C00Uc8pUorwza9IObV+uQjyyu4OraZYA6mSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oxhkUkRXTDxKvr20p/vv5epUwg7eSoPq4T1rTr24Ql/dsGQbvubg5sthaDtgnezt6
	 DTG64qjPr5SZBYJhGjNn5c8fDazkP1UltqVSGwe86bxXt9j89gcU6MZFX3m1oUfIQx
	 LE5KY3PO0fVvBMiPJ9meV0bRKpnt/yKOBaX0qLvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 5.10 42/43] USB: c67x00: fix use-after-free in c67x00_add_iso_urb()
Date: Mon, 31 Aug 2026 15:35:50 +0200
Message-ID: <20260831133400.739290391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


