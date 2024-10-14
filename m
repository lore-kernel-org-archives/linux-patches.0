Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B1420322;
	Mon, 14 Oct 2024 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916427; cv=none; b=BfrtdXcU+/7kaqrUtZFr3bUoodY+gQYzyuQFeiXTbuNcDBI8RD8ZQqeHfN/gAkXgic/diYFG/7HBpqVlQxQL6sK/0EGrV/30pAE43VORByrSKUnT7qby/W16yY0/tVFtCA4wm+jtlzw7QZRgvgoV0BQrDLTUzj7tRXv6MT7oQ5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916427; c=relaxed/simple;
	bh=BrVuhQVgYazvbVa0YD+aTvXS6NQy/QlImy8+7PWNbEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWCVxA5/LePBhOz5A7q4q/UA0sSHYyEbUKBptet1lo4LIqaxEKLIlCyhP4T/RZbIX+/NJsCBdSU2Dk/bBukjVn74DbSWXnjudsGWg5ok9ymRtNB7HtAkGQNEYtS1PwhV/zptyL7rj9PNdilQ6EtEPQMSPSPtMLUaW3W+HJt83Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaGOMyBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaGOMyBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C525C4CEC3;
	Mon, 14 Oct 2024 14:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916427;
	bh=BrVuhQVgYazvbVa0YD+aTvXS6NQy/QlImy8+7PWNbEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaGOMyBKA8sxgiMwX0OQBAGYWRiOhA3T5N6NvjuIBNITnOp6MPJbumbcKqo27lRkJ
	 JL6v4GWInmQZY/JPsT5dEeCGc64HB9Oqw9JCJmAQMN2YR92x7XVqVIFTrEyvRJGHyy
	 T9fQTBn+xHl7MHj8MrFz/MjHsAIzyB4aa2K8DnTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 180/214] drm/xe/ct: fix xa_store() error checking
Date: Mon, 14 Oct 2024 16:20:43 +0200
Message-ID: <20241014141052.004825098@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit e863781abe4fe430406dd075ca0cab99165b4e63 upstream.

Looks like we are meant to use xa_err() to extract the error encoded in
the ptr.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Badal Nilawar <badal.nilawar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241001084346.98516-6-matthew.auld@intel.com
(cherry picked from commit 1aa4b7864707886fa40d959483591f3d3937fa28)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_ct.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -658,16 +658,12 @@ static int __guc_ct_send_locked(struct x
 		num_g2h = 1;
 
 		if (g2h_fence_needs_alloc(g2h_fence)) {
-			void *ptr;
-
 			g2h_fence->seqno = next_ct_seqno(ct, true);
-			ptr = xa_store(&ct->fence_lookup,
-				       g2h_fence->seqno,
-				       g2h_fence, GFP_ATOMIC);
-			if (IS_ERR(ptr)) {
-				ret = PTR_ERR(ptr);
+			ret = xa_err(xa_store(&ct->fence_lookup,
+					      g2h_fence->seqno, g2h_fence,
+					      GFP_ATOMIC));
+			if (ret)
 				goto out;
-			}
 		}
 
 		seqno = g2h_fence->seqno;
@@ -870,14 +866,11 @@ retry:
 retry_same_fence:
 	ret = guc_ct_send(ct, action, len, 0, 0, &g2h_fence);
 	if (unlikely(ret == -ENOMEM)) {
-		void *ptr;
-
 		/* Retry allocation /w GFP_KERNEL */
-		ptr = xa_store(&ct->fence_lookup,
-			       g2h_fence.seqno,
-			       &g2h_fence, GFP_KERNEL);
-		if (IS_ERR(ptr))
-			return PTR_ERR(ptr);
+		ret = xa_err(xa_store(&ct->fence_lookup, g2h_fence.seqno,
+				      &g2h_fence, GFP_KERNEL));
+		if (ret)
+			return ret;
 
 		goto retry_same_fence;
 	} else if (unlikely(ret)) {


