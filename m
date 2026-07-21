Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5F743B48C;
	Tue, 21 Jul 2026 22:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674180; cv=none; b=D+8Dn3xqnEr7LRNkacgmlVWau6zspmHFTHz4dDHnicd+Kmfo8TpSnE8492w/Px1LHrNqRU7xkJTq1/JTKNx52LEChdWsQx0y3AoVwU2u+erkyqk0JBS5ztSrE5NeKneLbvkUMHoFI9e9Yw4+ftX4O+M2aPVYqUfZdlPtwjget/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674180; c=relaxed/simple;
	bh=ihbb5C7Qpe2acl0ssg2AzhjRqCmrCTQjMxLJdhF7dqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUMv9jz1CtpZbv+QmIIhyK4JlNHFupuP1AlS6btcOZpUt92uTrdT1O5YNqWK3jeJgSNMl1KbmSSN63TFbTXVJG7tNayRwl8HqMmOobmfIP3Bp9UAcO8EU2b9v3AMa6+LxKGnYmnThMFtxB8RvASm4+S78QZTajbzIFLZn0ILqFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duVVA8+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duVVA8+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058A21F000E9;
	Tue, 21 Jul 2026 22:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674178;
	bh=kqLXBq7WxFadRYmyrxjChsVu7EHZ4KhWTujNIJg0GjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duVVA8+zp4q8lkclQ2TuUqfZikVzSbB9+Gn29MRvdeu6BpCeQiAwcMji0cG//XwIP
	 lO7vQ20yJvNymupj2EPP08a+fORYSggeXffthT5PEYrxGhMvytVobAG7/3lw+9koki
	 soF3pVGXDnVmftmQHCFN0xQnNTStefz8EgCjIwn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 442/699] fbdev: nvidia: fix potential memory leak in nvidiafb_probe()
Date: Tue, 21 Jul 2026 17:23:21 +0200
Message-ID: <20260721152405.670275870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


