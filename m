Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9FE3D8918;
	Wed,  8 Apr 2026 18:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673212; cv=none; b=UWq8v14lrPmVjiRGYEufB0JDE/vrHsLut1IF+Hl+tsuss5HPDKmq+Zs06C1pLtPuOZK/iJuSba64RQoxmWXSfy0zJIZVHJX4BFbcV0dnEOnlmU9z/9ctmF/4KqploGdoIHKSpqB3nNp3JI2cKp6fTviTbhCdWoh9e6rfoUkMXz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673212; c=relaxed/simple;
	bh=g4WAoIJYHtiWTOCCA3cFeId76Pep8+GIDz3YtnJiR4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbUkKJOtD31DIzxNwKwcfCKdxkhwhSBxE9REWXKVMT5IoVXpE4D8VRta/rd1bbAj8lTEfeElv5woK5fv+LD/r6I/lEXTkeTsambmHHhVF3sSNEcwYYTAitGeL1000fPExFKB3nv0s8lTWEUu1qJoFFpuhTPW7Mck9/vQT3LUvbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzVjVJwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzVjVJwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DDFC19421;
	Wed,  8 Apr 2026 18:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673212;
	bh=g4WAoIJYHtiWTOCCA3cFeId76Pep8+GIDz3YtnJiR4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzVjVJwzdITeVYEahxTKsqMOVIGnrYdHnE0IlgcAeiXNlj7yTnRREEuY7TTrjR2Bt
	 BynSf07zcg6S/wqG290llo3z3sbOM3+Ccro3WnGcuT+eZeEd53p1cGVpPFbMllDTzz
	 fJGECZltjjpYJ62LLRk8HIGnG77rBdA0F0LfVDTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.18 143/277] Bluetooth: SMP: force responder MITM requirements before building the pairing response
Date: Wed,  8 Apr 2026 20:02:08 +0200
Message-ID: <20260408175939.213369864@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
@@ -1823,7 +1823,7 @@ static u8 smp_cmd_pairing_req(struct l2c
 	if (sec_level > conn->hcon->pending_sec_level)
 		conn->hcon->pending_sec_level = sec_level;
 
-	/* If we need MITM check that it can be achieved */
+	/* If we need MITM check that it can be achieved. */
 	if (conn->hcon->pending_sec_level >= BT_SECURITY_HIGH) {
 		u8 method;
 
@@ -1831,6 +1831,10 @@ static u8 smp_cmd_pairing_req(struct l2c
 					 req->io_capability);
 		if (method == JUST_WORKS || method == JUST_CFM)
 			return SMP_AUTH_REQUIREMENTS;
+
+		/* Force MITM bit if it isn't set by the initiator. */
+		auth |= SMP_AUTH_MITM;
+		rsp.auth_req |= SMP_AUTH_MITM;
 	}
 
 	key_size = min(req->max_key_size, rsp.max_key_size);


