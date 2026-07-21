Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335C545A2AB;
	Tue, 21 Jul 2026 22:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672297; cv=none; b=M3j3zaydLfxSfJgdL52O99bAKMey2qFKqJm8xaiQ/b0CkM4zFrWxKSmYrEq+EQkzE12D1GtJwZd4P3eAKWbLUwEzwtuNLa7NVUuuRXTdfxbM4VwFwCcXLRhObZh8vDwcVx/zUEujuljKEbpSH03/uI3y3uv+P2480/cFwQ6RZik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672297; c=relaxed/simple;
	bh=5TsuizMcrLYUyhLHuKqmCd14320hoJHMDOAP5ufx3F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzTxw4AAyFVOFaVmCgznjAZav6yjrQko784+7O0b5xsmw9wdvoaMJDT0buLvGqOYK6O7xhCtl6K2MEK1iQDZSfLhIe5SNHzn3mKRuQiVGgGrhoxhdpfk5Cp10PLbYAR1NPP7pUFIYIFgLu7D/eOYaWBJM1D5FXr1JZ7+cKywxS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdBx/awI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdBx/awI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0B01F00A3A;
	Tue, 21 Jul 2026 22:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672296;
	bh=01XcxNFeUdFD0eFjgWRSwbGYCeFJYqKx2Tn0DbI2QSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xdBx/awIQNa/qWmE3l0Xos+Xpqv2axMH3Mi1LwXhlQinoJ35u/4vgbyqEwhOgeNTf
	 o7tOAE3TsRZGeffUDayV2h+Lpnf9meI4gWwLendaQzPud4mIzkMYSba/dGN6qLyyts
	 ajtsC4HnKN9+aTrZyZdysQ4Fh8wZxENPfkh3WRsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 570/843] fbdev: nvidia: fix potential memory leak in nvidiafb_probe()
Date: Tue, 21 Jul 2026 17:23:25 +0200
Message-ID: <20260721152418.868803985@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1409,6 +1409,7 @@ static int nvidiafb_probe(struct pci_dev
 
 err_out_iounmap_fb:
 	iounmap(info->screen_base);
+	fb_destroy_modelist(&info->modelist);
 err_out_free_base1:
 	fb_destroy_modedb(info->monspecs.modedb);
 	nvidia_delete_i2c_busses(par);


