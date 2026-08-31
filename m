Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D994B5CD1;
	Mon, 31 Aug 2026 13:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184412; cv=none; b=lAlJZREj0Z5ORMK8GDBSUfsZgkqHI6r0g8mjVwbgcM8oRkM67mGOwQdmievUfIO+hueXzeoe5n2q3IRR0qZrY2nNr9d4mc4ycdgffh5p9p6UjMhYOeMzCau3dsvJsWGdL3AMzTeXkxprdEZSD7q1gPbBhIcglspDegi7viYvCsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184412; c=relaxed/simple;
	bh=HYUqtF2h9UuLA5vyFtGnnMcJbf3ZZorC7k5YYt5z6Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXDxJgFeJCaYyG1kXoWn19pi40U5YJuW8yJRAR4wS22Ng40LZ/T+tkSwiuwzY8s8a6xAh7e089quULPdsKMPvBBAeoWCsjuxh6+5ZE5vIjrZ4J4gzu5aZHS908NWLEaryWk9OdtwxBKmCRdbJndPlYEUbuJvlrzOdGOlU3Z9gLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V63IZsGh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V63IZsGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF45A1F000E9;
	Mon, 31 Aug 2026 13:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184411;
	bh=t/zguG8Ea+Ze8spTVg1H93Gw7vc5OK0TUdF+5C7N+Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V63IZsGhJYVVMxrpN+T1NtPHckjEov5OlzfGcJD9TtNbn/BuiI2mkFtKwjG4zR5i8
	 OycTIg3qz6Rgj+CXZWEtplT3jhZobTlH+X4zsOMn8z9kwCmPyYuZLe0bjBAXPLV/Wr
	 yl/zfubLw/O/lMR7j99gtI7liTRe0a/tV0/V2pkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 6.12 97/99] USB: c67x00: fix use-after-free in c67x00_add_iso_urb()
Date: Mon, 31 Aug 2026 15:35:06 +0200
Message-ID: <20260831133404.529217283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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


