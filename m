Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275D4344D9D;
	Wed, 30 Sep 2026 18:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794610; cv=none; b=CKe92K/i9cu7g8E0cUrp/uoCENOqOTDpq0lT4Cl56UF+PyQTQcd1FgYoPgi8u/TbqlfuriHGv7E4hCfVBw01mOrCFWhS/yFM+gYeLyMxqX7eAAD8LBiWWVCFKjCwaQyj5AVg+9U4ZxmsmvOIEmMoNqZ65OYVmPeiH0gyMHIcGBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794610; c=relaxed/simple;
	bh=t5w9217qzwSPBrNSZd0cl1EDjj946x8q9P2MsHqHCNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu+iVP6soMHmuhOc08kRZqP7asqMtqxJiFAIQFxH2csF6Qz3U77TeWYeDt3NJAZKdTnueIzSdgLiAVOE4v9dn0fKPw/1n4E1sVifBY0WJt7CArSOuc0Bseq4i9OFXn4nLRpeEA/FCE/JEDGHWg0wOcfT9OdL/iFW2pg2H4eu260=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YG4ix6mW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YG4ix6mW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8243E1F000FF;
	Wed, 30 Sep 2026 18:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794609;
	bh=ODXw/zU33b3GclSFP1rzXBR/A1QObQKgH2PBropuZIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YG4ix6mWARGgO4g9QlSiOKeViQuz3of0txtZI9ckcfSgVNW25fbdyHLRPRfjJZZ8e
	 U0/bawcBgUc3xhRVWxNw4boKz92Brji7V/bkhK4nqN4X0rHZRdPys/8WiaRG67JOhP
	 YXMZuNcrKkxc3eRlii0jz+aBPZNgvIL4ED+c1vyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0269/1193] fbdev: pm2fb: unwind WC setup on probe failure
Date: Wed, 30 Sep 2026 17:15:53 +0200
Message-ID: <20260930152440.145806277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 16eb19f0c90af03bda6ba66586d7bb0e9cf85b43 ]

Add arch_phys_wc_del() on error path to keep the
write-combining setup balanced when later probe
steps fail.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pm2fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
index 5a79a12efd8e3..f6f4296bab76d 100644
--- a/drivers/video/fbdev/pm2fb.c
+++ b/drivers/video/fbdev/pm2fb.c
@@ -1709,6 +1709,7 @@ static int pm2fb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  err_exit_both:
 	kfree(info->pixmap.addr);
  err_exit_pixmap:
+	arch_phys_wc_del(default_par->wc_cookie);
 	iounmap(info->screen_base);
 	release_mem_region(pm2fb_fix.smem_start, pm2fb_fix.smem_len);
  err_exit_mmio:
-- 
2.53.0



