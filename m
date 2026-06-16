Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3589044E021;
	Tue, 16 Jun 2026 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624377; cv=none; b=pVXJprCnC33CmTeHnzvRHS8jVguQlVqH+JXX7BG/bbuOW54wqbRraxOIhUvTsJfE845ep+OhkPed/VeXLm90zPk+sANEzGwfhP3qvEHLoxkAZg5trlZTQYQaYIf2ychCqtRdB7Ex0xCH2Ng3KvfGkB2Jax0RAIW7qmmEQiyKrjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624377; c=relaxed/simple;
	bh=lYG1rJakGM/CvZ8bxq5+dW9QdDY+xvA6l25DYLPxYTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSLtrGl4h7IxDQ+mdPRlXsKxFEQsWbrlmkYTX0VsBOHw7GfTC/RA4wPBEuFF+KDQuaJpa8oyMeTKa/V8RuDNAQQFg1CTC5YdQ+I6fe2QdGf29gNThYk235Cek9YVRn7ug8a3PRvewHvj9Zw2pd6Ddim3R54rBLuyGoQ11Uh37qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uPVaPAg0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uPVaPAg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439AC1F00A3D;
	Tue, 16 Jun 2026 15:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624376;
	bh=mqjfzTjR+v3CjsurCoG/TcStz1cCkpwqtspLAOc7LBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uPVaPAg0oTOiH+UCwioTm82bVabbDBWagYRqg1QluIT6jhkWBTW9wtz5sxpmcbhaW
	 toeaKdXUf4BkB2n8nJsPah5Qo5/79RHKy6FMa4rrvnF/JGSdZfhsV33kYcFeSgtpHO
	 zBBKqM9mHvbNt8MnV/yiCd6+jpP+D0eN/3UZxcCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7.0 324/378] thunderbolt: Limit XDomain response copy to actual frame size
Date: Tue, 16 Jun 2026 20:29:15 +0530
Message-ID: <20260616145127.284767671@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


