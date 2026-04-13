Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8351D5AD4;
	Mon, 13 Apr 2026 16:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098241; cv=none; b=W4h6CtCyVz9ABoF3SSxK5yCI/eSaoiwZPVNeWzIIkAUHNuEqsqMer60SNqyiMBDJDvfW+YJw3q66rJB/l5WAuPQjkNaaL8KZBTv0Ig0R9nXd7gascU/zrkZK+bsnR6pgEceHFwf/+pmZjVEBE+qv9wzNqcT5zhCQN8ZQUip7kYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098241; c=relaxed/simple;
	bh=xvmcs1Txz4RpMbNQyV7P94z68BA9wtWAf7vhQ8gL3oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGOH0gw/2EWTRKh/ArojrQr0ZiZOMc4hqH7Taifob6licTDQ2OsQcmm4XxFw7qc+ka0onWJWXgG4qBomODf9MuCvxCIAiXRWdpkojQMZPsY8bEOHLBs2QcuGyAwJywS/7Aw/FpgBZR3ZInnxW5ZXbdJvZDgd4F9y8sBepzf/IUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emnxR7zd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emnxR7zd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C855CC2BCAF;
	Mon, 13 Apr 2026 16:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098241;
	bh=xvmcs1Txz4RpMbNQyV7P94z68BA9wtWAf7vhQ8gL3oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emnxR7zd5rubCCa9JNGu3jZXxsufMypf6u7X3ftLIl2Eg2rAYQ/yAyiCT3PsPr2f+
	 OmYB2vMcSI+jdxV6jXBYYRunY8kO1BsMCIKm3UweBOv6gRUoYCRkOUi8beORsRAlr4
	 z7KmYAPzsPiY5auYGfPPs9v2iNpKsmGcRVOUWDtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 449/570] Bluetooth: SMP: force responder MITM requirements before building the pairing response
Date: Mon, 13 Apr 2026 17:59:40 +0200
Message-ID: <20260413155847.287826426@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
@@ -1817,7 +1817,7 @@ static u8 smp_cmd_pairing_req(struct l2c
 	if (sec_level > conn->hcon->pending_sec_level)
 		conn->hcon->pending_sec_level = sec_level;
 
-	/* If we need MITM check that it can be achieved */
+	/* If we need MITM check that it can be achieved. */
 	if (conn->hcon->pending_sec_level >= BT_SECURITY_HIGH) {
 		u8 method;
 
@@ -1825,6 +1825,10 @@ static u8 smp_cmd_pairing_req(struct l2c
 					 req->io_capability);
 		if (method == JUST_WORKS || method == JUST_CFM)
 			return SMP_AUTH_REQUIREMENTS;
+
+		/* Force MITM bit if it isn't set by the initiator. */
+		auth |= SMP_AUTH_MITM;
+		rsp.auth_req |= SMP_AUTH_MITM;
 	}
 
 	key_size = min(req->max_key_size, rsp.max_key_size);


