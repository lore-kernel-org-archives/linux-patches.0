Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231B33D5667;
	Mon,  4 May 2026 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904034; cv=none; b=jt/G4+xz+r2Ul4BkZY7tZjR69HR9OF3yB8XM5EDmh5+aRPdemmrai52qJsqn2Z4r/KAokGD/36vPQz6czke/zPu0ahU8vcfruupc/8c5IfT3n+6nYP2IFhPsRSTaoTaK1BLsHzJAk59zbSmfzWg1BEP3WI+pfsycyf8pMm0Iwn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904034; c=relaxed/simple;
	bh=XIZYbP36/gvuOaxBUJgPeas7wqOnlGe2h8srBKIr+jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfKvnkiQQddIkPUgtG+EfkIP7p51azsz3CZYEcOTDJ9MKJXKl/GEKPK8JA/3WlOMnB1vQL67oJ56oEmYTbfdvYdtiyd0OD3a5K2EI2NXHIw1PwnbVG+EfNwBoe9qeP5uwRXd/9EQtq6zclxobObPWR1lnSgogEQdkVJFfPdAyWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRgV0Swz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRgV0Swz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E779C2BCF4;
	Mon,  4 May 2026 14:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904033;
	bh=XIZYbP36/gvuOaxBUJgPeas7wqOnlGe2h8srBKIr+jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRgV0SwzblkxtXFTG3srMEwsNXem02NIvavk88+UsMSjXFHT4eeFWJKDmDQLbGPLv
	 JdzXF5RlfMxe+U257X2HTEDHSpzQQg598l7Y4LlnMe3KBfdZ7rk6QVdKShcz9e5kRc
	 8MuIT8WhWQvwacTl4GH/S0oZbGE1Tq7E7t+3We7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gunnar Kudrjavets <gunnarku@amazon.com>,
	Justinien Bouron <jbouron@amazon.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.18 156/275] tpm: Fix auth session leak in tpm2_get_random() error path
Date: Mon,  4 May 2026 15:51:36 +0200
Message-ID: <20260504135148.753058002@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -275,10 +275,8 @@ int tpm2_get_random(struct tpm_chip *chi
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


