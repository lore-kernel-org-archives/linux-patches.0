Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A012F12AE;
	Tue, 16 Jun 2026 17:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631957; cv=none; b=I87VDKF5diTPk8twDFJx2YKmgTXXFfaHMy3XLcBwQC7er4TIlImWSCLUs0XwnH5T3eS5nK2y/ys1zS7r6zCYCrZmqp84jVI8brLWYpbB2vlpBKqZWkze7snp3tAqsR3xmdDGVp9zSqK5Hswc/Ur9fEvyAS04dIjeeCkQJynGuTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631957; c=relaxed/simple;
	bh=YwDEemPl8bxUXFemVpH+By8+AyEeauPzQIDQbts3lkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vB/OTJqd1sXeD2zi0fn7gtMUUTvv52t98Uq6CUIL9FssCb4PwVCp8xxTFi7AhiTYtVrPTqn/Dhh+VN8daR9ObxMkGN9rfBz0ag/dxR3+4gi3FEYm9DA979OD5PIzeC+J1EkUh8WaH+pqCrBVdCZrofkATWwOrId2dG+ocnJiD3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0+/HAeD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0+/HAeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5D91F000E9;
	Tue, 16 Jun 2026 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631956;
	bh=h8ja8ZuW3sRqkpqQ4V4nJVEGlc+xTSdk82NEtGgs8pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0+/HAeDJzqcojW42UQDVs6Jh33RmaSAg86J6/WaDmpej+D5aaKpFsEQ7LZrAAlAN
	 cb5NvqcVGl9KoLl97lm87AJBZkKkD3iIuCMppI5713B6yKdB4bNkR8B32FiUtpuhHx
	 MYVx7T7+Srf+F2/cPIzaEd42SP1dSVP4Fq5yl3kA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.1 319/522] thunderbolt: Limit XDomain response copy to actual frame size
Date: Tue, 16 Jun 2026 20:27:46 +0530
Message-ID: <20260616145140.773405890@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -122,7 +122,9 @@ static bool tb_xdomain_match(const struc
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


