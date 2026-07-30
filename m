Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5257E3B6366;
	Thu, 30 Jul 2026 14:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423115; cv=none; b=ZJ8a97wjoqyoUlqyOprQhXe3kDDFSputPh61SdFWrHf7hVnE1VR1Qwqc0mTPzW5Ev2U9ir3ZqP+QwazrdDBbckIBlzKQ6XlOq0zM5HWs4tLrPv0Pd+gHID6zZxNL2tHpDAwg2hdpBbW9FG5Q08BKI/gUr7txwCa0a+ppazSV4M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423115; c=relaxed/simple;
	bh=MkHy9jL9TOhYX5JbU04SMnZCuTls1gpOR8iKUjrXTeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPb68SxcQFgdCFuBNjkEz0tMAiOtnlMukrbzVB7IPV6C69UN3pshjb0Yuahcawdx5vUJSaauxgrt3S+oRpeZXqW8j33fhYObD2rcsf2IhRqG2QidNHfWSJ683h6Qjm850NPxEtScZBnPeJPWfN3hEbja/mst1FIVABMu28AWyNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1gWwHCzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1gWwHCzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE701F000E9;
	Thu, 30 Jul 2026 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423114;
	bh=U2HTBFz3RvfnijWCfX5DRywbqRtJbJ9jfWa12Qx4Tf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1gWwHCzYahO5/DzGrAvXxlKKWGJUNnzw+ow2rMsxc9y69eSYpcde+wK/q0k5DGFLs
	 aoiFdiTHtnJ4OCF+yzvGlUTugixwhW67FGpvmshbtFYNX+892+IIEofBOoRbABNmGI
	 hH3oFtnZk+B5M1ZW9qtobYit3KbRBEpHtmzMIZ1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 7.1 671/744] rbd: Reset positive result codes to zero in object map update path
Date: Thu, 30 Jul 2026 16:15:44 +0200
Message-ID: <20260730141458.525418974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


