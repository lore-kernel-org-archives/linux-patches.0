Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B583324502C;
	Tue, 29 Apr 2025 17:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947084; cv=none; b=pHPi3NhDCJ6u/0vbjcbHRUXiXluCH7dfmDJ+v/rBSgQ7zpm5QXTtpjfLO9fQJ/XMLAJXzXpZtJCW03FBDPtGIZeuCr7NcT7KhHhcBaH88GmPyBFRyXbILfeQDqTUP351yKw3PTqZw/rmUGB67Kz2IgUesL5O1V5P0jcPDCCGYrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947084; c=relaxed/simple;
	bh=HSCZ/H+bPVLrHF59HFzhu/VkcRk6Bm40Oz1M97klHb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk2wZ3yX2zjTQ/79dA1h+e3dYFKueJye60/lrwn2v+AtMusIpxRcfvizgEIsMiVHSvnBjKR/cE9NtheVGb6hnQuwU9ZgnXujVN2K18J7xEx1B0dPMUTH9svGx9L3VDAWiZwR2zAIl8AHABnT8nc/0dq9Nu1FP/dyupy0igZVs8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cA6OmAkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cA6OmAkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D9DC4CEE3;
	Tue, 29 Apr 2025 17:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947084;
	bh=HSCZ/H+bPVLrHF59HFzhu/VkcRk6Bm40Oz1M97klHb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cA6OmAklX+W5r0qTNOVNNpBqI7fkXwzsQc/xo4eqrx8CGPBoeA4PwoIAchlVT0DSz
	 IKAnSyttW5Du1kqjpAHxkjblsex/aVipDThMmhXmhn9hyWHgr5z/15F9rUGu18PWGU
	 4vqmeVh5G1+k1IvBHAiQnfTeCM1oXJnztMNNdahg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Sami Tolvanen <samitolvanen@google.com>,
	Petr Pavlu <petr.pavlu@suse.com>,
	kdevops <kdevops@lists.linux.dev>
Subject: [PATCH 5.10 137/286] module: sign with sha512 instead of sha1 by default
Date: Tue, 29 Apr 2025 18:40:41 +0200
Message-ID: <20250429161113.507439341@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2211,6 +2211,7 @@ comment "Do not forget to sign required
 choice
 	prompt "Which hash algorithm should modules be signed with?"
 	depends on MODULE_SIG
+	default MODULE_SIG_SHA512
 	help
 	  This determines which sort of hashing algorithm will be used during
 	  signature generation.  This algorithm _must_ be built into the kernel


