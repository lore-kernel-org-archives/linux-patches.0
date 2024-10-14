Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3BD1A76A5;
	Mon, 14 Oct 2024 14:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916413; cv=none; b=P17pA+5kfY6OkoHUqJvlGLgnyxXQ/MoaOYuo80cwmwWxfWiTe27l+bkrGYodPByNWrb8YusoV2m2mbBQMow/x87iPK0m0b8eA6u+O4vCCF0ClQNZfsemEtGC0A1BAQ6NDzLblkLsWyFY36OiJFYm9bhd6Yu982RKuB/QjGsR5Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916413; c=relaxed/simple;
	bh=WK8u8ts0Rp2VgU2LffSO02cLHmwNmrJY8oQwtahDhQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mINuuRqY6Q+Pkqipw+z/CuheFkEohEQxbg2+7oaQUyE0PR4/2WI5vUWnw+untRZ/bsvbaL7WZKUacfDAv7YvOnQf1tSLUGWoiIBCqcj2SRpwn9zfYnuGPUMRy1Cnax1qvjWmLt9zAo7zk6weBS2KbZM39TrF0iaFiiZqmzmxfiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uo8RpNNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uo8RpNNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7025C4CEC3;
	Mon, 14 Oct 2024 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916413;
	bh=WK8u8ts0Rp2VgU2LffSO02cLHmwNmrJY8oQwtahDhQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uo8RpNNUhdYBAdOm/CGoQMepd903JXtkBAQx9+yDmHosQmCLWmUrN5UWKnDd5x3Mj
	 2g5nkT6DB6nYIMhMtULwyxeKe1JLBMooNPKf/rbpV61SAA+p3UW9mm8ZPSxQSXH6Ut
	 pUl2yq8HfH8n31KoyT0+93uRDDNtm2h9pTQL+xBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 177/214] drm/xe/guc_submit: fix xa_store() error checking
Date: Mon, 14 Oct 2024 16:20:40 +0200
Message-ID: <20241014141051.886212537@linuxfoundation.org>
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

commit 42465603a31089a89b5fe25966ecedb841eeaa0f upstream.

Looks like we are meant to use xa_err() to extract the error encoded in
the ptr.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Badal Nilawar <badal.nilawar@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241001084346.98516-7-matthew.auld@intel.com
(cherry picked from commit f040327238b1a8311598c40ac94464e77fff368c)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_guc_submit.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -393,7 +393,6 @@ static void __release_guc_id(struct xe_g
 static int alloc_guc_id(struct xe_guc *guc, struct xe_exec_queue *q)
 {
 	int ret;
-	void *ptr;
 	int i;
 
 	/*
@@ -413,12 +412,10 @@ static int alloc_guc_id(struct xe_guc *g
 	q->guc->id = ret;
 
 	for (i = 0; i < q->width; ++i) {
-		ptr = xa_store(&guc->submission_state.exec_queue_lookup,
-			       q->guc->id + i, q, GFP_NOWAIT);
-		if (IS_ERR(ptr)) {
-			ret = PTR_ERR(ptr);
+		ret = xa_err(xa_store(&guc->submission_state.exec_queue_lookup,
+				      q->guc->id + i, q, GFP_NOWAIT));
+		if (ret)
 			goto err_release;
-		}
 	}
 
 	return 0;


