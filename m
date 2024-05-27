Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449DF168C4;
	Mon, 27 May 2024 19:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837375; cv=none; b=JrwltbWsiUJebtedUsXLz7L4nj16M3+VELrZx+uXajDcOx0HIuXFpuEMVsJEBvr0BMSiQ0OyBhH8hh8uv2eY8I6Dh9W21tWvTsvkUBw0RdWmfrD3KXNsxyc6VECPFx5A5ksPNKjYS7ahm/QpIi1R7M0kIIMfrFk0UBbnu2o8Cps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837375; c=relaxed/simple;
	bh=ZZzQY6Nd9VWISDrRvARb/ueGZ32CSbD2uL6ZI2tPGRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jk6T2g6erG0oXEHECcEYBnafex2oByncqDttXRhzDb96Ln+28ffLPXeDe+14oZzLu4nvpp30XsK2pwVFDz6nbUXig9cxF1OcgfbauzSLQQFYVTkZaFKHFIVfOSBLQmikN+LWG0vWRExLETUQGYk9yzq8wcV97yQT9m0aw6G4dmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTaA0kvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTaA0kvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA65C2BBFC;
	Mon, 27 May 2024 19:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837375;
	bh=ZZzQY6Nd9VWISDrRvARb/ueGZ32CSbD2uL6ZI2tPGRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTaA0kvTsPWaVM4byy8P3JwNM8Px7Gmn7BL/tr7ArPH1cVRSXPSAzx1LQW2w/jFhe
	 Dni9qMmWgzMeWXrmBxK8AlD9Y/4h4vaqUqdtt3ge2qk1aTatRsR/Ud46CBe4LxRitc
	 taoSwlUsPkIbpszrfpe1w+Tr032w+0G2FVCg9ADI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Du <xudu@redhat.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 417/427] idpf: dont skip over ethtool tcp-data-split setting
Date: Mon, 27 May 2024 20:57:44 +0200
Message-ID: <20240527185635.616882105@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 67708158e732bf03d076fba1e3d4453fbf8292a2 ]

Disabling tcp-data-split on idpf silently fails:
  # ethtool -G $NETDEV tcp-data-split off
  # ethtool -g $NETDEV | grep 'TCP data split'
  TCP data split:        on

But it works if you also change 'tx' or 'rx':
  # ethtool -G $NETDEV tcp-data-split off tx 256
  # ethtool -g $NETDEV | grep 'TCP data split'
  TCP data split:        off

The bug is in idpf_set_ringparam, where it takes a shortcut out if the
TX and RX sizes are not changing. Fix it by checking also if the
tcp-data-split setting remains unchanged. Only then can the soft reset
be skipped.

Fixes: 9b1aa3ef2328 ("idpf: add get/set for Ethtool's header split ringparam")
Reported-by: Xu Du <xudu@redhat.com>
Closes: https://issues.redhat.com/browse/RHEL-36182
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://lore.kernel.org/r/20240515092414.158079-1-mschmidt@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
index 986d429d11755..6972d728431cb 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ethtool.c
@@ -376,7 +376,8 @@ static int idpf_set_ringparam(struct net_device *netdev,
 			    new_tx_count);
 
 	if (new_tx_count == vport->txq_desc_count &&
-	    new_rx_count == vport->rxq_desc_count)
+	    new_rx_count == vport->rxq_desc_count &&
+	    kring->tcp_data_split == idpf_vport_get_hsplit(vport))
 		goto unlock_mutex;
 
 	if (!idpf_vport_set_hsplit(vport, kring->tcp_data_split)) {
-- 
2.43.0



