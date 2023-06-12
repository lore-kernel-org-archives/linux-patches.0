Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F58134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ADFC433EF;
	Mon, 12 Jun 2023 10:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566615;
	bh=ziMtz1pAnYxoysMRaKDMUrZT/VlQfLWwJq40/h5TI1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xNFP5SpWUz+M6bb3lEnlpUPayEEDadeGbWL58SHSEg9F9MhSOkiGsXPjWAK9SZZBr
	 xUzxzAu7RFJOlSE8lgXizS/rw/nS4lcr0T8ITy27wNZ+GHQlJ+x/3c7Dcz6OXK9tZN
	 BiTpOTvTLA6HEmNQjsPErr8fF9IiccVitcpscPUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 6.1 092/132] rbd: move RBD_OBJ_FLAG_COPYUP_ENABLED flag setting
Date: Mon, 12 Jun 2023 12:27:06 +0200
Message-ID: <20230612101714.432516593@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Dryomov <idryomov@gmail.com>

commit 09fe05c57b5aaf23e2c35036c98ea9f282b19a77 upstream.

Move RBD_OBJ_FLAG_COPYUP_ENABLED flag setting into the object request
state machine to allow for the snapshot context to be captured in the
image request state machine rather than in rbd_queue_workfn().

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1334,14 +1334,28 @@ static bool rbd_obj_is_tail(struct rbd_o
 /*
  * Must be called after rbd_obj_calc_img_extents().
  */
-static bool rbd_obj_copyup_enabled(struct rbd_obj_request *obj_req)
+static void rbd_obj_set_copyup_enabled(struct rbd_obj_request *obj_req)
 {
-	if (!obj_req->num_img_extents ||
-	    (rbd_obj_is_entire(obj_req) &&
-	     !obj_req->img_request->snapc->num_snaps))
-		return false;
+	if (obj_req->img_request->op_type == OBJ_OP_DISCARD) {
+		dout("%s %p objno %llu discard\n", __func__, obj_req,
+		     obj_req->ex.oe_objno);
+		return;
+	}
 
-	return true;
+	if (!obj_req->num_img_extents) {
+		dout("%s %p objno %llu not overlapping\n", __func__, obj_req,
+		     obj_req->ex.oe_objno);
+		return;
+	}
+
+	if (rbd_obj_is_entire(obj_req) &&
+	    !obj_req->img_request->snapc->num_snaps) {
+		dout("%s %p objno %llu entire\n", __func__, obj_req,
+		     obj_req->ex.oe_objno);
+		return;
+	}
+
+	obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
 }
 
 static u64 rbd_obj_img_extents_bytes(struct rbd_obj_request *obj_req)
@@ -2233,9 +2247,6 @@ static int rbd_obj_init_write(struct rbd
 	if (ret)
 		return ret;
 
-	if (rbd_obj_copyup_enabled(obj_req))
-		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
-
 	obj_req->write_state = RBD_OBJ_WRITE_START;
 	return 0;
 }
@@ -2341,8 +2352,6 @@ static int rbd_obj_init_zeroout(struct r
 	if (ret)
 		return ret;
 
-	if (rbd_obj_copyup_enabled(obj_req))
-		obj_req->flags |= RBD_OBJ_FLAG_COPYUP_ENABLED;
 	if (!obj_req->num_img_extents) {
 		obj_req->flags |= RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT;
 		if (rbd_obj_is_entire(obj_req))
@@ -3287,6 +3296,7 @@ again:
 	case RBD_OBJ_WRITE_START:
 		rbd_assert(!*result);
 
+		rbd_obj_set_copyup_enabled(obj_req);
 		if (rbd_obj_write_is_noop(obj_req))
 			return true;
 


