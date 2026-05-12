Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F043955D8;
	Tue, 12 May 2026 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608654; cv=none; b=AVOZHjI3UD1PI5wn3IVNX4t4f+cSJOqottkCgSU1xUl4Oza+/Qm0LvQraxPJSiyKowT0r/IieMvOnNfTNk2+8zSs9qlUd0g02KQHr/BtMY8Rp/f9JDdlx59qB9clAGkx+1FBNo5ryYp2Lv23wCvKpb1Ji1xS+Rkzrx45J+JMob0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608654; c=relaxed/simple;
	bh=UN+SveIXLMR6LhExgriLLazNONcIpg2855ZWaiqKaDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYz4CuBOyNcqZqAtEHY/hiEy9Fdgnupj56byGjdoZtzJUEVwMa1D6MzfdqY8v2t5J0qRr2BJTYiTPCDIPS9vGw46GPcnPpr7OKB3qf/D0em48wHyHbJ7PwVgsld/79YcUxU+BMdLvGuxZJxBmzcRreFeVjBD4cEBzwoUPJzaNC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1zrQBs+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1zrQBs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5898CC2BCB0;
	Tue, 12 May 2026 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608654;
	bh=UN+SveIXLMR6LhExgriLLazNONcIpg2855ZWaiqKaDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1zrQBs+Nw2pcWfFknJKA0WdCysNLFIx8PvIXbbzNu+yW7hR5WdVGKMu9bBLb9qPe
	 gDMaOIsz/LXDwASR4ORa6s198dalUYGLvB47+cTvnrwRIiehef8cBvbIAa64b/lCh5
	 ih7P5Ea5StI0NUmg93UrDFArtvS4iE5hA2NjY76s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Yiming Qian <yimingqian591@gmail.com>
Subject: [PATCH 6.18 161/270] lib/crypto: mpi: Fix integer underflow in mpi_read_raw_from_sgl()
Date: Tue, 12 May 2026 19:39:22 +0200
Message-ID: <20260512173941.835734295@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

commit 8c2f1288250a90a4b5cabed5d888d7e3aeed4035 upstream.

Yiming reports an integer underflow in mpi_read_raw_from_sgl() when
subtracting "lzeros" from the unsigned "nbytes".

For this to happen, the scatterlist "sgl" needs to occupy more bytes
than the "nbytes" parameter and the first "nbytes + 1" bytes of the
scatterlist must be zero.  Under these conditions, the while loop
iterating over the scatterlist will count more zeroes than "nbytes",
subtract the number of zeroes from "nbytes" and cause the underflow.

When commit 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers") originally
introduced the bug, it couldn't be triggered because all callers of
mpi_read_raw_from_sgl() passed a scatterlist whose length was equal to
"nbytes".

However since commit 63ba4d67594a ("KEYS: asymmetric: Use new crypto
interface without scatterlists"), the underflow can now actually be
triggered.  When invoking a KEYCTL_PKEY_ENCRYPT system call with a
larger "out_len" than "in_len" and filling the "in" buffer with zeroes,
crypto_akcipher_sync_prep() will create an all-zero scatterlist used for
both the "src" and "dst" member of struct akcipher_request and thereby
fulfil the conditions to trigger the bug:

  sys_keyctl()
    keyctl_pkey_e_d_s()
      asymmetric_key_eds_op()
        software_key_eds_op()
          crypto_akcipher_sync_encrypt()
            crypto_akcipher_sync_prep()
              crypto_akcipher_encrypt()
                rsa_enc()
                  mpi_read_raw_from_sgl()

To the user this will be visible as a DoS as the kernel spins forever,
causing soft lockup splats as a side effect.

Fix it.

Reported-by: Yiming Qian <yimingqian591@gmail.com> # off-list
Fixes: 2d4d1eea540b ("lib/mpi: Add mpi sgl helpers")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.4+
Reviewed-by: Ignat Korchagin <ignat@linux.win>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/59eca92ff4f87e2081777f1423a0efaaadcfdb39.1776003111.git.lukas@wunner.de
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/mpi/mpicoder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crypto/mpi/mpicoder.c
+++ b/lib/crypto/mpi/mpicoder.c
@@ -347,7 +347,7 @@ MPI mpi_read_raw_from_sgl(struct scatter
 	lzeros = 0;
 	len = 0;
 	while (nbytes > 0) {
-		while (len && !*buff) {
+		while (len && !*buff && lzeros < nbytes) {
 			lzeros++;
 			len--;
 			buff++;


