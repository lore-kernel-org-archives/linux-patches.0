Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ACB22B8DF;
	Tue, 21 Jul 2026 18:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658477; cv=none; b=X7dcR1AS3olGDSmSQqCmKPEdez0qikY3uihT/4yIjIv3UODgfiVqwSmtnDPL/ZZpqxk0FtKCP7AF+yPbQpBMha8koGAOZMdxpWbwfnRucyLSZ1C6GqDHK8fyWjFJBAjTBwIJk2zDVIYYhqvh9DqGPEO7VFmcQJafYMwxP/gSv4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658477; c=relaxed/simple;
	bh=lSJ6Raur5OGARrCtsJwoUk2M21nUnGL9wBEMPo2c85s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swsu6KAUb/1h/eHQtG30bvCsM4dcocUdAyqPpgx2/SjjzWqHywZHA1AhJ2plE4VxjVp+OzTQDMQOCpq5GYlaBu+h9b1C+DwjstS3bBxZQieh7UfAIGpaaZlMhzSZ9483pUPD0KjOWR2txFYZ17iU9ByppRgAtz0KitffnksbsfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXF/Fvng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXF/Fvng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9111F00A3A;
	Tue, 21 Jul 2026 18:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658476;
	bh=iF90AQU0vzIaKcnCxYwe3yB4qfyQBd9IRpgvidRPPwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXF/FvngtgnmhTcQmsEf2O4aWVpeW4IXur9QkvWcWibEmXTF6eeYtFjAh7tXRjq6O
	 AiFiEngFdPDULKVI9c49a+k5fEk+jLqsHTclxwOmFyQPvy5RbzlxyAMCphvAOqXyU8
	 7UldkcCk6YUmR/zmurL1sB/Nj+hHPplN1KFd7aWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1156/1611] fbdev: nvidia: fix potential memory leak in nvidiafb_probe()
Date: Tue, 21 Jul 2026 17:21:12 +0200
Message-ID: <20260721152541.424008595@linuxfoundation.org>
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
@@ -1421,6 +1421,7 @@ static int nvidiafb_probe(struct pci_dev
 
 err_out_iounmap_fb:
 	iounmap(info->screen_base);
+	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);


