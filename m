Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9930F46EC7B;
	Tue, 21 Jul 2026 19:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663510; cv=none; b=nRmjH+i06ph4Py9Z3W6ql4zIDwQL1Mf2SjszHBBQIWJGb/ql1zzX4ndonWc+Ge+rGzX1OUVmxXSw5eMBSIoLAk4YvAPE9prQnoNkXRwqV2DiaV7NcWUN1sUr7uqFVTb7dtwDCtr5fIvhW7v0ZgDDPB/cVrVl76jkfgyj4bmSTNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663510; c=relaxed/simple;
	bh=7XUFs5GMSOd5K7S34W7OAq2Ue9SDDAewSxGZHrGUlyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMhe8ZVhmhkZzwnw8lCFa6LgQOFKVZeLlZavgBVHYf1IEuhEO6rD+uNqzCMNOqWsgnAHNN3s6E5K52xiMWkBN/EUn7UETmdI2Ytk/wlWAggqm1nAca9sORmF4PtjCn+fqKs1VBp4sK2UiDIP+N8U630CJeRVSkCPzQRKKcwnj14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHcOjxAn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHcOjxAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C11F000E9;
	Tue, 21 Jul 2026 19:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663509;
	bh=Faa8RG5/NejMEJeH/cEV8LseB1lJ9J12F8inATPiAzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHcOjxAnjw296CE7CEJg2m2YDwtpxBo14eDg5H4dwKdvqWcM8dZBEYB94FBkfSXyC
	 48JXdIqvz92EJHXvKAFns7sr1GY5B13c3Y1OeGuO0nRreETTI2eV6cnYMfDIqKAJZd
	 yWDznUKNduoGoKf8j7J+0JOuIDFWWZU5dz+jivvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0850/1276] fbdev: nvidia: fix potential memory leak in nvidiafb_probe()
Date: Tue, 21 Jul 2026 17:21:33 +0200
Message-ID: <20260721152505.073813040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 85f5e38c162bdf9dbbe197275d416402712f3707 upstream.

In nvidiafb_probe(), the memory allocated for modelist in
nvidia_set_fbinfo() is not freed in the subsequent error paths.
Fix that by calling fb_destroy_modelist().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/nvidia/nvidia.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -1420,6 +1420,7 @@ static int nvidiafb_probe(struct pci_dev
 
 err_out_iounmap_fb:
 	iounmap(info->screen_base);
+	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);


