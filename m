Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2555320C488;
	Tue, 29 Apr 2025 18:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950166; cv=none; b=rb/0pIciRIaMjLIhUWUyqYBfXja+nFKyib4Iw7l+fRd6LLUv8YboRDBwLQz9I300hRntu7lxFuhNSD2hXVXDZ09DUy2d1hrxnsGbCfD3bDn0fq7qYDFtGo9/TIQ62y2lIOtO3ObTeV+dNTiGwY8DLSzr3kK3WritF2yBpfETsWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950166; c=relaxed/simple;
	bh=yJ5n/y/SQWjkTiAmmex0ZZ/+bFhWwelf4QgI62N13f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEeDpBZac4uNt9Ni1p2vS/+tsJsz2NoItyqQuJfRX1u7xKgsjMx8NMuFArnk9+LdgAFN8/AdURajERzs8l3wuIFGdwQGLM9bHAftFML2F3zKA1ZmFtxk9yn5T7OEU0ay7OlFSnFFr3zYeT7WYj+LQOqpbYgqcWYUaMBB6sByKlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSv7+8Bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSv7+8Bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9807AC4CEE9;
	Tue, 29 Apr 2025 18:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950166;
	bh=yJ5n/y/SQWjkTiAmmex0ZZ/+bFhWwelf4QgI62N13f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSv7+8Bt69sHhmcZ0dVCk/rcltPhLZn4bDJgm+40SVe1ZHseT5pAip6/33eCGtKCd
	 /GO+kgBKZnkouZaezzKY5o3vG1U0k4EEtzY+xC+64FgTXiK9LbYKOfh0BIMd6meZgf
	 KhVPT/xAM7xjfypzMqrmLdUZpqMHxVarM+P0skGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Sami Tolvanen <samitolvanen@google.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	kdevops <kdevops@lists.linux.dev>
Subject: [PATCH 6.6 001/204] module: sign with sha512 instead of sha1 by default
Date: Tue, 29 Apr 2025 18:41:29 +0200
Message-ID: <20250429161059.459611074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/module/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/module/Kconfig
+++ b/kernel/module/Kconfig
@@ -229,6 +229,7 @@ comment "Do not forget to sign required
 choice
 	prompt "Which hash algorithm should modules be signed with?"
 	depends on MODULE_SIG || IMA_APPRAISE_MODSIG
+	default MODULE_SIG_SHA512
 	help
 	  This determines which sort of hashing algorithm will be used during
 	  signature generation.  This algorithm _must_ be built into the kernel


