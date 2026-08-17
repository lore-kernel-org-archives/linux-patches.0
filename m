Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34C43ABD9F;
	Mon, 17 Aug 2026 14:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977126; cv=none; b=Z0olmdJ6AJbasIHD+bpiEO63tThbefSTxt06opDiyUB6rSOx6g/0AnK9KDYlPZ+y9SlrKk9IUCHZgOmKjdMo7K8otE7G3AN54q+IgOJCl/hz6SQU4M0+K9JVJsERZEUGuCRvSim++JH5/lQnpGtHOP+z0bcZj7vpVRiPZoAY8MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977126; c=relaxed/simple;
	bh=5dxbOn1q4Nuf6QD50ln7/ZdTdaa/shi9rafdlfUfYmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ef/16HPAVj0nJE4f8DHsvXA/2YPWx2dU441XEIz2NfgY0vQTJxY5tSwjH1I9Zw2wa833FU9P5keLr9PWsiRRfkeb5Gyq26SDO3sS5Oz73QqlyQlf64R+gN3JogmDXYrIHGTISatcNdgj1DiauR6md7s/OchwgSfYraVQd/YS15Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBsfxijr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBsfxijr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ED11F000E9;
	Mon, 17 Aug 2026 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977125;
	bh=tDC7C0RbcRnSGW7+nIySQfydcTHYHR6UC4OpckrdSUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBsfxijrDjs0BWqknDWAFOjCPd29aRWnYTs7nj1Ba8eOg9v9WGgfqzrZWxt2bExcq
	 msIpnVjohXgPgLQeV4PYkOPX+aDtG8vH8Ppz7JI/ymqWZglybis9ADC5j3ZVAWJ2CN
	 INHacRrt45M0tZhFDBAPtq64qg9bC+Wbrb3ZEOfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>,
	Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.15 220/456] rbd: Reset positive result codes to zero in object map update path
Date: Mon, 17 Aug 2026 15:30:10 +0200
Message-ID: <20260817132548.787219499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1958,10 +1958,15 @@ static int rbd_object_map_update_finish(
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


