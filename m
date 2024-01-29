Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7615A48D;
	Mon, 29 Jan 2024 17:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548128; cv=none; b=YOLMBo3OC/SuD30IoG0usGOrmUmrXEPlytFaQUih9UP4WtQ5pOYvyO+etFh4c+srIZNiG5aeQDfV48vteZFk/bxNP2WdpJaddW4GlwmfSDzxKisvFT0LnUxY/qTSQJndolDQCf2gjrLS7nq7Jtf2Zds2TD0uTe6elvU6Ak+PVeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548128; c=relaxed/simple;
	bh=kJ/W6XWY64Ng0EMP+F9FlVB4A8754ZF0XVMUzAOaCOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4QPqrQKilcITYod5YSqL87nEWgztrT5ddJduyjSRS3JSQ8wVWVC6n40Ke+hlqmfVc13/yVOawUFIm0lES6hdmYXz0/dQkDF2apzsWqDgY3WhQkUz53d3ng0Rpiobn95wftFvGJ7vrkxnsN0WvO2KKUHhgNMrMZ8h2E+UabM0BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5KZlUOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5KZlUOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FC1C43601;
	Mon, 29 Jan 2024 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548128;
	bh=kJ/W6XWY64Ng0EMP+F9FlVB4A8754ZF0XVMUzAOaCOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5KZlUOqA1EQjlUHqWjk030U1T4tUwnU82ty9h0yrVHw6n7dcHZEfnSgKtZAULd+l
	 jNYO1D0b0Fk/NL+4W7cds8yVXzYwaRbYequYdgrnHLf+MPcE7XpLp6iit/Ukn1Pg4a
	 fwVCFfx9XR7yTzcuwNW890roYzt+t5d9mDtPwEh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 157/346] idpf: distinguish vports by the dev_port attribute
Date: Mon, 29 Jan 2024 09:03:08 -0800
Message-ID: <20240129170021.029359026@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 359724fa3ab79fbe9f42c6263cddc2afae32eef3 ]

idpf registers multiple netdevs (virtual ports) for one PCI function,
but it does not provide a way for userspace to distinguish them with
sysfs attributes. Per Documentation/ABI/testing/sysfs-class-net, it is
a bug not to set dev_port for independent ports on the same PCI bus,
device and function.

Without dev_port set, systemd-udevd's default naming policy attempts
to assign the same name ("ens2f0") to all four idpf netdevs on my test
system and obviously fails, leaving three of them with the initial
eth<N> name.

With this patch, systemd-udevd is able to assign unique names to the
netdevs (e.g. "ens2f0", "ens2f0d1", "ens2f0d2", "ens2f0d3").

The Intel-provided out-of-tree idpf driver already sets dev_port. In
this patch I chose to do it in the same place in the idpf_cfg_netdev
function.

Fixes: 0fe45467a104 ("idpf: add create vport and netdev configuration")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 19809b0ddcd9..0241e498cc20 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -783,6 +783,8 @@ static int idpf_cfg_netdev(struct idpf_vport *vport)
 	/* setup watchdog timeout value to be 5 second */
 	netdev->watchdog_timeo = 5 * HZ;
 
+	netdev->dev_port = idx;
+
 	/* configure default MTU size */
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = vport->max_mtu;
-- 
2.43.0



