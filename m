Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DD324A06A;
	Tue, 29 Apr 2025 16:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945424; cv=none; b=gRoYPpJOOR7v8A4F/UyJ6vRt4ZeVzCdJpMPadu/uWjJvSMF/7/rdft7jxE1G4475wxnCDyVoGMEl1CtxPrF+ydXq0JvKCjVl5hpm/OXoLTFUbZ6FWmvG4cXK2RCsLFMsJwnV0/q+IHPtt8cvcBdtA+M1KAc3P9ywoiItgfoGWtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945424; c=relaxed/simple;
	bh=CMvyS22X/4+ehGRJgPbhA61Xk605VJy0scmzXYBsgCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akEytDJxTDge/kKG0VnaWZfEl67fhFKXwKMiUYnEhbewUGOZ5I7BnoPLwv3WQgMATDTkmrJ/4sGFZCb0xGY5mTRO3Muta2jgaQWps/b5kDVqK1B3QKBLLGHkKN8kQmK/B1IxeYo+UVzAFQmOsmyClx9avK8y5xK0CPpwT3nT2/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pGSle1zZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGSle1zZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96261C4CEEA;
	Tue, 29 Apr 2025 16:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945424;
	bh=CMvyS22X/4+ehGRJgPbhA61Xk605VJy0scmzXYBsgCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGSle1zZ6lggb0raqiVvkravZp9hb2v5Wn9+a+liCldCguGePEU/U65qcyaJucXCN
	 M6WUZp0aWwbJV0Qj5mowb3+VnkKO4Ew42IW2iVtx0cfDAqSXBiR9+yXJBXm2ibi9w0
	 yOtJA0Dh8psbdHI3dEB9xdmVNmdYp7pfMt5qMZRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Sami Tolvanen <samitolvanen@google.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	kdevops <kdevops@lists.linux.dev>
Subject: [PATCH 5.4 107/179] module: sign with sha512 instead of sha1 by default
Date: Tue, 29 Apr 2025 18:40:48 +0200
Message-ID: <20250429161053.731336325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Leemhuis <linux@leemhuis.info>

commit f3b93547b91ad849b58eb5ab2dd070950ad7beb3 upstream.

Switch away from using sha1 for module signing by default and use the
more modern sha512 instead, which is what among others Arch, Fedora,
RHEL, and Ubuntu are currently using for their kernels.

Sha1 has not been considered secure against well-funded opponents since
2005[1]; since 2011 the NIST and other organizations furthermore
recommended its replacement[2]. This is why OpenSSL on RHEL9, Fedora
Linux 41+[3], and likely some other current and future distributions
reject the creation of sha1 signatures, which leads to a build error of
allmodconfig configurations:

  80A20474797F0000:error:03000098:digital envelope routines:do_sigver_init:invalid digest:crypto/evp/m_sigver.c:342:
  make[4]: *** [.../certs/Makefile:53: certs/signing_key.pem] Error 1
  make[4]: *** Deleting file 'certs/signing_key.pem'
  make[4]: *** Waiting for unfinished jobs....
  make[3]: *** [.../scripts/Makefile.build:478: certs] Error 2
  make[2]: *** [.../Makefile:1936: .] Error 2
  make[1]: *** [.../Makefile:224: __sub-make] Error 2
  make[1]: Leaving directory '...'
  make: *** [Makefile:224: __sub-make] Error 2

This change makes allmodconfig work again and sets a default that is
more appropriate for current and future users, too.

Link: https://www.schneier.com/blog/archives/2005/02/cryptanalysis_o.html [1]
Link: https://csrc.nist.gov/projects/hash-functions [2]
Link: https://fedoraproject.org/wiki/Changes/OpenSSLDistrustsha1SigVer [3]
Signed-off-by: Thorsten Leemhuis <linux@leemhuis.info>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: kdevops <kdevops@lists.linux.dev> [0]
Link: https://github.com/linux-kdevops/linux-modules-kpd/actions/runs/11420092929/job/31775404330 [0]
Link: https://lore.kernel.org/r/52ee32c0c92afc4d3263cea1f8a1cdc809728aff.1729088288.git.linux@leemhuis.info
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2077,6 +2077,7 @@ comment "Do not forget to sign required
 choice
 	prompt "Which hash algorithm should modules be signed with?"
 	depends on MODULE_SIG
+	default MODULE_SIG_SHA512
 	help
 	  This determines which sort of hashing algorithm will be used during
 	  signature generation.  This algorithm _must_ be built into the kernel


