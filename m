Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1275C45BD4B;
	Tue, 16 Jun 2026 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626153; cv=none; b=AeUpYDsTej1EGJZfZuz4hWZdPaBjtQvBENahflqAlI7tVQTSNzK/0HQmngz0ThlrKO+btaWXHQ4fAa6xCutpZvKO0KBDZ10deZq3waLJ+9zauXl1pZ46vZZYsuXeziEZq17P961HY5R3BbBJQW17kzKJFf+Rdh1dZIgI9R+7SZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626153; c=relaxed/simple;
	bh=nLtpxnrhWa9Gu0BsFEEfFJVBaNbXvcxcp1z7zRScJyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+BzO69kfmKZIiO8S0+SikHPdD9kWk1VD48yjHDB3Emk2yp9tnfJ7f8KxVjXfWYZLWbI2KA6ERjvBaSxU81pRSOnDtK+E0cFh1HkWs4oL5snL0jwEj4lsivjokMLhRFoMYrFHxXIhGIjVYa36qefe1Heff8Qg3Fkm9bKoM7kE4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0anyc05S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0anyc05S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2210D1F000E9;
	Tue, 16 Jun 2026 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626152;
	bh=NmjJ0su5Rk2vqGf/oKo0lW0ITpeMFQ+txXfk10kytcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0anyc05Se3wtCejLw+tzRLyJMmVNji3w5QHxrCrU3Gg7cPkWyG62fPzeB+9Ikghny
	 rSqFG+0/Q1KdpJImzUPOcbSOuAazF2F2vYIBkvT06j9+bXR/KQAGoz5Hnt6wCydN6A
	 H7/qxYRmym9kCb7Pk9nTr+ZkvYUDd4Uqh5htrZIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.18 273/325] thunderbolt: Limit XDomain response copy to actual frame size
Date: Tue, 16 Jun 2026 20:31:09 +0530
Message-ID: <20260616145112.300901008@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


