Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B453B379C32;
	Tue, 21 Jul 2026 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658453; cv=none; b=rcxRypSLQmdBN4pwt5VZ/oQybEDZEeR5gMZdCgSfRIlcbwRZNAxrsOs7Z2C/AvxsIwMNaoS30q+mdKImMY7rNhaw7pPU0nf3Sa/oGt9cKBl/zYLQPY8bkKM7h+RD7RCOdUjmbCr0TOi1H49seb7DnY86PRHYrgbQ7vM9Fv7URDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658453; c=relaxed/simple;
	bh=TVJU6yWkgB/vEUFvQ+sg6o4evE6fiiJ3KQddal5ZT9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+nP0QkC11SjiOPqG79isuu/YSSQD3XD++ULl5zoF4ahmJWLbcW0YgU2bXMdJpDlEIvrnsGj03+HCKwnF8yAZx9lfhOjMfplTCt/XUHcTBvwrDxgofLDbIueTcZ3Tc+j9RaCSrRamUu+Ee8/K8CHxk7JxKEc0vSASXHX7jICxaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+GZrhYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+GZrhYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C3B1F000E9;
	Tue, 21 Jul 2026 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658452;
	bh=Dr7GLCDA1ennc+nddGnNmpmO/Dz90o14n1101qSvErQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+GZrhYEjWW+r9XiHdlbEgrJm2tJoCqvjmPdItJZZ2pqsDR/meM9q8EafgxA46REh
	 +BhqjftBUppqnw74g/jUxj+b4dfs/vG2d7LP+PjgkbtvRlNW4FtK8nDL7ZKMMpAR7r
	 4ro5R9c/e8aFsUtT0mdmh14WPoJ+SI/n6p5Uh2/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1148/1611] fbdev: efifb: fix memory leak in efifb_probe()
Date: Tue, 21 Jul 2026 17:21:04 +0200
Message-ID: <20260721152541.240700668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 9b6eaf101656958397a6012bf43f6e2e42c9e5cb upstream.

Since commit 73ce73c30ba9 ("fbdev: Transfer video= option strings to
caller; clarify ownership") the string returned from fb_get_options()
is expected to be freed by the caller, but the string is not freed in
efifb_probe(). Fix that by freeing the option string after setup.

Fixes: 73ce73c30ba9 ("fbdev: Transfer video= option strings to caller; clarify ownership")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/efifb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -375,6 +375,7 @@ static int efifb_probe(struct platform_d
 	if (fb_get_options("efifb", &option))
 		return -ENODEV;
 	efifb_setup(si, option);
+	kfree(option);
 
 	/* We don't get linelength from UGA Draw Protocol, only from
 	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not


