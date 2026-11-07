Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063779;
	b=iUtSKoDZ9aUkn53sSKISzanXeK956k7Ajcsp69C24yiBDyvtIsJBd4EApAIHTuojdEmW
	 p7pc1zKsxM+FnAP3wbpjKhtp8+ARVIIMWF9krWkIEClKAMuX3MyPXPy89KZ04kPHtbuYO
	 6QlTnJ98vffgxt9z9sRls4u144AEhTlqHfrfOCXdjPX9mNJ+kdvn+nfQ9dIyp9Lgp2+FI
	 O78gaQb6zYIqpfurKLJ4950WNY89EYjqbpVeg06WiEwZx0PSQM0r2vNtx1NFmA2Vr084H
	 aEBcZ1dl0yQ5/g1WcpKCR4uxP/BHQFaMo4rFoPUhukQML+Ow7iXDFk5QSG7UUIQ7MvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IkHutLKurvgZq2m7kdSLSQkKL34x1/iC09nKoxJUoBE=;
	b=dMsdPO0Jhzx0NP8jJHDfvthSvVWw636tJiRfudNbyuk68xFDFUjX0ac2cZuNxSFXthKv
	 D0a66N0QRBbe1am90gD24ispkA3trHPhs0R6o2EHiPQZbzLdGVuW0smNScUCxr3xn18j/
	 qJPrTx35CHIwKD/pEnfEWe4nLAKonU/wB9RigU/zZB9qQAocG7Hj/Yv8fKRTINSvB7ReP
	 rLvtC+PBp+1bSNGXUyL4T/nRCFsVmm8z9X5m5bWG6efQ8k0OspGT/+3jzA5QxABeB8mHD
	 JTnuNyLmpVasxBZZ46lRql0kpj+QGggx1UX/niAmmOAWU5tQ+sZ/+wI/phrjdAxCJjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQdeWD4f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D6260A262E;
	Sat,  7 Nov 2026 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DQdeWD4f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8470D1F008A3;
	Sat,  7 Nov 2026 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063778;
	bh=IkHutLKurvgZq2m7kdSLSQkKL34x1/iC09nKoxJUoBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DQdeWD4fl+HiKe7jPN3T5PaCFaNIGpQOcam3PKmGjINgjVh9jqNMtxWdU7cS50MTH
	 PCLsnei9382oYOUOXp3p/oqCNeUah4XwWPNAFxZwue8dXGwQC+LxlMRE86kITUya6P
	 aHHWdkotOVw0EMrWNSlW+qlRFMihPdF/JkQYlHsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 868/869] apparmor: fix uninitialized variable warning in aa_inherit_files
Date: Sat,  7 Nov 2026 08:59:10 -0500
Message-ID: <20261107134922.241196097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit ed35bbe7d06e6505401eff3f3c7a36bd1f167a17 ]

Fix the following warning

All warnings (new ones prefixed by >>):

>> security/apparmor/file.c:737:53: warning: variable 'file' is uninitialized when used here [-Wuninitialized]
     737 |                 int error = aa_file_perm(OP_INHERIT, cred, label, file,
         |                                                                   ^~~~
   security/apparmor/file.c:724:36: note: initialize the variable 'file' to silence this warning
     724 |         struct file *devnull = NULL, *file;
         |                                           ^
         |                                            = NULL
   1 warning generated.

vim +/file +737 security/apparmor/file.c

   719
   720	/* based on selinux's flush_unauthorized_files */
   721	void aa_inherit_files(const struct cred *cred, struct files_struct *files)
   722	{
   723		struct aa_label *label = aa_get_newest_cred_label(cred);
   724		struct file *devnull = NULL, *file;
   725		bool devnull_tried = false;
   726		unsigned int n = 0;
   727
   728		revalidate_tty(cred, label);
   729
   730		/*
   731		 * Revalidate access to inherited open files. Each file is
   732		 * revalidated holding only a reference to it, with no locks
   733		 * held, as revalidation may sleep (e.g. unix socket mediation
   734		 * dropping path refs, or allocating path buffers).
   735		 */
   736		while ((n = iterate_fd(files, n, get_next_file, &file)) != 0) {
 > 737			int error = aa_file_perm(OP_INHERIT, cred, label, file,

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610292346.ehqNujiE-lkp@intel.com/
Fixes: a913281f60015 ("apparmor: don't revalidate inherited files under files->file_lock")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 3176e5623d3d4..f8f9320e266a4 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -706,7 +706,7 @@ static int get_next_file(const void *p, struct file *file, unsigned int fd)
 void aa_inherit_files(const struct cred *cred, struct files_struct *files)
 {
 	struct aa_label *label = aa_get_newest_cred_label(cred);
-	struct file *devnull = NULL, *file;
+	struct file *devnull = NULL, *file = NULL;
 	bool devnull_tried = false;
 	unsigned int n = 0;
 
-- 
2.53.0



