Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7417D3DE456;
	Mon,  4 May 2026 14:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904622; cv=none; b=uFzyS6iaAT9renPjmrzy7bjDyPod5xfAuEJVHo4UnvDU5VrqA+bQCUIHzgPfUQ+iZ/UOs6m02f56+Ssn1HC319Cwa2/IIVhYLoAk6T28RhCXWbh/MFzKlTxOTb5L8gTzV5KRLZR4HvJbv6wCTCuW8huexvU0Ho0/mwEk9kZr7P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904622; c=relaxed/simple;
	bh=AbQgoQH/2PcIFtf8Cqlt4qo8buUAsha4ado2AwiqF6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMX1I8708bciqB9vrCf6aaxZ0YM+Bh/c/4eYaQnkf8Y5HLSUq704Z17/RBlpV4x/5W/pIZWSRivZ6ZoEguvaIRICqhnyUgpqfjSK7oJCgc14JGYVmC8etRFHeEt3hc26Ci8jep0jOXicsK69WKhIYNuBgUiTg2FYyje1ccCuwFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKfc+uST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKfc+uST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092B7C2BCB8;
	Mon,  4 May 2026 14:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904622;
	bh=AbQgoQH/2PcIFtf8Cqlt4qo8buUAsha4ado2AwiqF6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKfc+uST56/U1wL9CCPpjNmfcIIyKh6Na5wNl4zzofGgPuQVgkTkzUL5Zk8kbOo8F
	 MnAoF9Lfg2ulN7JJlxKp6RXoA8Sbbmy8IL2CyxWtcVr/6AbmNxoBafNErqwrSvtBjb
	 Mc4UfDfvghc/FoZeVUw6h3EXM+7EkNT4pAzqRG+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 111/215] tpm: Fix auth session leak in tpm2_get_random() error path
Date: Mon,  4 May 2026 15:52:10 +0200
Message-ID: <20260504135134.203878245@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gunnar Kudrjavets <gunnarku@amazon.com>

commit 666c1a2ca603d8314231200bf8bbb3a81bd64c6b upstream.

When tpm_buf_fill_hmac_session() fails inside the do-while loop in
tpm2_get_random(), the function returns directly after destroying the
buffer, without ending the auth session via tpm2_end_auth_session().

This leaks the TPM auth session resource. All other error paths within
the loop correctly reach the 'out' label which calls both
tpm_buf_destroy() and tpm2_end_auth_session().

Fix this by replacing the early return with a goto to the existing 'out'
label, which already handles both cleanup operations. The redundant
tpm_buf_destroy() call is removed since 'out' takes care of it.

Cc: stable@vger.kernel.org # v6.19+
Fixes: 6e9722e9a7bf ("tpm2-sessions: Fix out of range indexing in name_size")
Signed-off-by: Gunnar Kudrjavets <gunnarku@amazon.com>
Reviewed-by: Justinien Bouron <jbouron@amazon.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm2-cmd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -338,10 +338,8 @@ int tpm2_get_random(struct tpm_chip *chi
 						NULL, 0);
 		tpm_buf_append_u16(&buf, num_bytes);
 		err = tpm_buf_fill_hmac_session(chip, &buf);
-		if (err) {
-			tpm_buf_destroy(&buf);
-			return err;
-		}
+		if (err)
+			goto out;
 
 		err = tpm_transmit_cmd(chip, &buf,
 				       offsetof(struct tpm2_get_random_out,


