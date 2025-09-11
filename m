Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF10341654
	for <patches@lists.linux.dev>; Thu, 11 Sep 2025 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.215.233.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757601320; cv=none; b=RXhjxaLfx/ciT5UnT2zxdNePFl42Dmnn8RxrrghKLl0bNEArBuQXOzHvVZC714jwiksPMSLsPumA00Ejn8x11Ey4GqLMwvGcfUz1rzlSlMAseaAw/kP3k8WEqpQLZLGintvFNHBm4a/UKeyNvoDq9tXQiT1NfJc8oxvHG7oPdNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757601320; c=relaxed/simple;
	bh=kmYFrSrgA3Mi3vNNhajjAozYHq9FQcgYPKIpWyrFOCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDQ1k1V//WvSB0kBstZ49eKpuMrVXbneTme0Pcs5Paab4/E94e0H5WQJchTtAmPkYH5/Zs+MdjJV8fhh97v0y8bVw8WXYNfDbSpDz3hbtNBjANtI3Np9MkxQKAy9U1P+TgSr/wZVd+TxF/nb1ikGxcgsQTmD2Lprvd/hZ4QcF+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com; spf=pass smtp.mailfrom=janestreet.com; dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b=hMiKKHTU; arc=none smtp.client-ip=64.215.233.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=janestreet.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=janestreet.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=janestreet.com header.i=@janestreet.com header.b="hMiKKHTU"
From: Jun Eeo <jeeo@janestreet.com>
To: gregkh@linuxfoundation.org
Cc: hch@lst.de,
 	martin.petersen@oracle.com,
 	patches@lists.linux.dev,
 	riel@surriel.com,
 	sashal@kernel.org,
 	stable@vger.kernel.org,
 	tsi@tuyoix.net
Subject: [PATCH 6.1 035/198] scsi: core: Use GFP_NOIO to avoid circular locking dependency
Date: Thu, 11 Sep 2025 15:35:17 +0100
Message-ID: <20250911143517.525874-1-jeeo@janestreet.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20250325122157.561309561@linuxfoundation.org>
References: <20250325122157.561309561@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1757601318;
  bh=eWpEObUv7ZzoAMXx5rDV1+ptboZBCyE3RAjeDS6i/BE=;
  h=From:To:Cc:Subject:Date:In-Reply-To:References;
  b=hMiKKHTUiptikMYL5HNX+bhOxcp1qrG3BgxfeyBXfsoVEWsFmDJXDvhlHCwMgIa5X
  gda/VgZDvm1UesRHvFhzcTj17kGm5BQ4c2UXNc+vuniJ+FEAh6h+XV3pOb0NRpjxp8
  LFgOns++QdedjO0viBfo8zCQyvTxRubh5S5QvZpClMpPNYioLqRZMoYn6qjnp11YtM
  4jiE32MCktU1HgGQOgtv6F3mGZqfurUZuMly5uSe4Vyqct/7CHyPJTOE25TcjEVCUg
  kBAYa4EQHfueL9Qw67DqeVt8Jh+ZqgUEx9GXl8m7njktDmAh7c5Ef5PJ8B+nAkMGmk
  pdM8XVmqOGgNw==

Hi -

With this patch, we've been seeing a small number of machines in our
fleet boot up but are not able to register a SCSI device:

[    6.290992] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured

It usually goes away upon another reboot. I don't have a reliable
reproducer except for rebooting some servers repeatedly on 6.1.132.

I added a couple of printks around the various cases where scsi_alloc_sdev
fails, as there are 3 allocation sites, and also pulled in f7d77dfc91
("mm/percpu.c: print error message too if atomic alloc failed"),
and isolated it to a failed percpcu allocation:

[    5.431189] percpu: allocation failed, size=4 align=4 atomic=1, atomic alloc failed, no space left
[    5.440383] sbitmap_init_node: init_alloc_hint failed.
[    5.440383] scsi_realloc_sdev_budget_map: sbitmap_init_node failed with -12

Which kind of makes sense, as __alloc_percpu_gfp says:

> If @gfp doesn't contain %GFP_KERNEL, the allocation doesn't block
> and can be called from any context but is a lot more likely to fail.

Reverting this patch in our environment made the initial SCSI scan
reliably work, and we no longer see issues with the SCSI drive
disappearing.
