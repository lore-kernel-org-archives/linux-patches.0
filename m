Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABC13ACF11;
	Wed,  8 Apr 2026 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672626; cv=none; b=DyBGHHTWxrGcSnvpbvLURJeG/xcuVQqt7zi9rLbP+eC2pp9M5xwXYE8qeWkuBMOvkG3Sb6ll3B8JJhU2x15xQ8zxL8BmW9oTH3ihAfll5FwOkzUaXEbia9aFRLiWzGctcoxQik2YRU2shlP0lb+nosXt5kOYWAEWnjaPexSjrLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672626; c=relaxed/simple;
	bh=iWj+UO9YYmov4AOkGNJpEcYje+ThLoySEVCj5ie2sVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SW6LLiLle/61o1hoeER5U2mz9m57+ym0U+Y8qJhF5jE9QVcMC9NaPBTtQEihGwVD/jmTeL8FKK2mW4lQIzIvmmKdN5xVUwjJf61DcD9u8tY6v3+qhhRlUIz7E56ez+ZfQfyn1yzHnudd/Ma2vGMlbe6mDdkqLkPfHfwgJBv2yrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4JmPh8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4JmPh8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CBCC19421;
	Wed,  8 Apr 2026 18:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672626;
	bh=iWj+UO9YYmov4AOkGNJpEcYje+ThLoySEVCj5ie2sVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X4JmPh8khpu0LxxTzxCw8777LbCyb8pBcDUeu/O5nsPrVJ/vX/NPQPnNHNnCsPSI7
	 7tjnzZbMw025UmmZNnddNcNwbpONHHkGPeDI3ODvAvFqLBuiGffoOoWhu3AxfnzQGm
	 Dc5wdNglCJIsoUqBcVfO7jFZjaGAauSm0PUkY+Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 080/160] Bluetooth: SMP: force responder MITM requirements before building the pairing response
Date: Wed,  8 Apr 2026 20:02:47 +0200
Message-ID: <20260408175916.180983634@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Oleh Konko <security@1seal.org>

commit d05111bfe37bfd8bd4d2dfe6675d6bdeef43f7c7 upstream.

smp_cmd_pairing_req() currently builds the pairing response from the
initiator auth_req before enforcing the local BT_SECURITY_HIGH
requirement. If the initiator omits SMP_AUTH_MITM, the response can
also omit it even though the local side still requires MITM.

tk_request() then sees an auth value without SMP_AUTH_MITM and may
select JUST_CFM, making method selection inconsistent with the pairing
policy the responder already enforces.

When the local side requires HIGH security, first verify that MITM can
be achieved from the IO capabilities and then force SMP_AUTH_MITM in the
response in both rsp.auth_req and auth. This keeps the responder auth bits
and later method selection aligned.

Fixes: 2b64d153a0cc ("Bluetooth: Add MITM mechanism to LE-SMP")
Cc: stable@vger.kernel.org
Suggested-by: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Signed-off-by: Oleh Konko <security@1seal.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/smp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1824,7 +1824,7 @@ static u8 smp_cmd_pairing_req(struct l2c
 	if (sec_level > conn->hcon->pending_sec_level)
 		conn->hcon->pending_sec_level = sec_level;
 
-	/* If we need MITM check that it can be achieved */
+	/* If we need MITM check that it can be achieved. */
 	if (conn->hcon->pending_sec_level >= BT_SECURITY_HIGH) {
 		u8 method;
 
@@ -1832,6 +1832,10 @@ static u8 smp_cmd_pairing_req(struct l2c
 					 req->io_capability);
 		if (method == JUST_WORKS || method == JUST_CFM)
 			return SMP_AUTH_REQUIREMENTS;
+
+		/* Force MITM bit if it isn't set by the initiator. */
+		auth |= SMP_AUTH_MITM;
+		rsp.auth_req |= SMP_AUTH_MITM;
 	}
 
 	key_size = min(req->max_key_size, rsp.max_key_size);


