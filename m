Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0514743D4E8;
	Tue, 16 Jun 2026 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629819; cv=none; b=Hmfn0Sm2BOqG6G570rGzZX3BT7t/1GIQLcQ1h7Cw/6LItbo9yZwCQp5H0vvU70Um7gGI9UjgC00P1zhJodmPlntAGe29oJH3HVdABHiiwry4AgA7NhXDDncY81f/WhcZHghOePk2Kf6JPDnavs4L7PkyPiY4NfmACnULZCByibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629819; c=relaxed/simple;
	bh=H1CCogWOj+cP0SAJxAehgR6V7jdlxJaCaBH2y0fNLAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMWfHjc93eJ493P79qI2sVMlSeefPpc0CvrraAeUlHORPoEjuk/0mr/EH+82skFIkQAHoyRohK78eVgat5Q2gBxjpWiK77Y4rNIAhhoIH96CfVRITN4FcQE6v+12D03NtiY9fQEIih/2X/7i/AJUURB7Q6qxurpi2xuQ7MN7t5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4olAaV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4olAaV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB29D1F000E9;
	Tue, 16 Jun 2026 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629818;
	bh=52UKn4v6Gp757eeZaCU1Z33c1YHioWjqwu3WFLoI1fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4olAaV8bntLGjqLLleFcHUL//koBoCy5qhe1DDq2QFa3Ehz6JaDav1srN3Jzrj4K
	 osQ3WyWiXJ4MMqM+KVQwEfDrmos4YGexJfNZfTBgVLLgsHgC6QimH5HxmuOE/tdThd
	 77EH4HsSz+1x4q6c7pjzOgTGovbAAMPsoZvuPbZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.6 358/452] thunderbolt: Limit XDomain response copy to actual frame size
Date: Tue, 16 Jun 2026 20:29:45 +0530
Message-ID: <20260616145135.941769328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 4db2bd2ed4785dbadaeeab9f4e346b21ac5fb8eb upstream.

tb_xdomain_copy() copies req->response_size bytes from the received
packet buffer regardless of the actual frame size.  When a short
response arrives, this reads past the valid frame data in the DMA
pool buffer into stale contents from previous transactions.

Use the minimum of frame size and expected response size for the
copy length.

Fixes: cdae7c07e3e3 ("thunderbolt: Add support for XDomain properties")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -123,7 +123,9 @@ static bool tb_xdomain_match(const struc
 static bool tb_xdomain_copy(struct tb_cfg_request *req,
 			    const struct ctl_pkg *pkg)
 {
-	memcpy(req->response, pkg->buffer, req->response_size);
+	size_t len = min_t(size_t, pkg->frame.size, req->response_size);
+
+	memcpy(req->response, pkg->buffer, len);
 	req->result.err = 0;
 	return true;
 }


