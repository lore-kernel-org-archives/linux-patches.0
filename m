Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78F9358373;
	Thu, 30 Jul 2026 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426596; cv=none; b=ms6nl7G7thRMV5sSvaeamyrB+nTGqB4JgM62XzmpUo1O+gkXUUjocgzAciHz5l70RqDz1rHdkBPWqNM71RUDN0xQgbGO8TSZccR1AWxISJYzelvQIFhLt3ozGdv/mkynXfHd8HdqBvuktOgsBtf84qHaXR0af+EUxLR+JoyTrdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426596; c=relaxed/simple;
	bh=5lxG2qhj1ZlPrOvURI4Gh0CI/9Mx/+dhkYqeQIbsjis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwAYj89L/dBXx8G6Cf1RYzFJJfaX0KX/gsxZRVYgvIKVMUtijxDPBu5GsvM4eZ/17W/DUYnuZyWbTuwyA+C/f75YGBD2frV5+t/N3EIqMeWfFvNtdwgmwd0sywSuJzfv9EFvkL4D3E2YTIxF0G6nKGEvYXKifWf6HmSmW6H+ZZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6iBA5R/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6iBA5R/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7971F000E9;
	Thu, 30 Jul 2026 15:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426595;
	bh=VG6brWz0ZLGrLHsVcvpNHoSKGEhPng1c24uYVd0bIHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6iBA5R/1x7EkpLzjhVL6Pvx9ZVlhHthNqJ2OQ0TRajJWvVrPbU4+MYLe9x46WeQl
	 2/vD799AxhSqg3lJN8aHEX3GckY6J0+q2U8blIIyLlMPsRfTG0zkdGpbEawlgPIGpM
	 eKLVQqHZv1Uvb5oAVAQ9V6II6lVeuDYkzi/zxf0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 6.12 420/602] rbd: Reset positive result codes to zero in object map update path
Date: Thu, 30 Jul 2026 16:13:32 +0200
Message-ID: <20260730141444.790878173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>

commit a6c4250b81bd30beae94e1b7a4b26fa1193ad2e4 upstream.

In a reply message to an RBD request, a positive result code indicates
a data payload, which is not allowed for writes. While
rbd_osd_req_callback() already resets a positive result code for writes
to zero, rbd_object_map_callback() does not. This allows a corrupted
reply to an object map update to trigger the rbd_assert(*result < 0) in
__rbd_obj_handle_request(). This happens, because
rbd_object_map_callback() calls rbd_obj_handle_request() ->
__rbd_obj_handle_request() and passes this positive result code. From
__rbd_obj_handle_request(), rbd_obj_advance_write() is called, which
leaves the positive result code unchanged and returns true. Therefore,
the if(done && *result) branch is executed in __rbd_obj_handle_request()
and the assertion triggers.

This patch fixes the issue by adjusting the logic in the
rbd_object_map_callback() path. A positive result code for an object map
update is now reset to zero (similar to rbd_osd_req_callback()), and the
message is subsequently handled the same way as if the result code was
zero from the beginning. Additionally, a WARN_ON_ONCE() is added for
this case.

Cc: stable@vger.kernel.org
Fixes: 22e8bd51bb04 ("rbd: support for object-map and fast-diff")
Signed-off-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1957,10 +1957,15 @@ static int rbd_object_map_update_finish(
 	bool has_current_state;
 	void *p;
 
-	if (osd_req->r_result)
+	if (osd_req->r_result < 0)
 		return osd_req->r_result;
 
 	/*
+	 * Writes aren't allowed to return a data payload.
+	 */
+	WARN_ON_ONCE(osd_req->r_result > 0);
+
+	/*
 	 * Nothing to do for a snapshot object map.
 	 */
 	if (osd_req->r_num_ops == 1)


