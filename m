Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440931420BE;
	Tue, 23 Apr 2024 21:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908695; cv=none; b=nhRbyiPlKo1LzQHjN/6rVh0cg4sFBsomvVYvGpCOQa3ts8nJCsZpfoMFQLn/3WqKDHTCWrgjuNB2kVmTpfEpgoxFw+uNW0Y8GCJDln3vPbyeYuT9EcmcJYzSNLiH7Lhe0J+3L7MgLeOXuzAYfl0NP5xf1rj4q5sK0BGcdpDyC7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908695; c=relaxed/simple;
	bh=A43twmQEzg4L8zn/5Rrv5uvp/jads3y7OZST9BOR6vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIzIx9yIDXoI3sQNjXulEQya8M+Ty792XAHc4TZkNbLh7S3wERLb2scxOw6vwkX2nWPqsNliCMEFsWSK28XAlUxrGkWpVJx9RjMncR77Mkwx4OR+BafrmU3DZPqkdiYQ263jbspSSHpZajGNqdhKoDtFjfTP5c1vLAwcbAE1Is0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z43HQfp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z43HQfp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165F2C4AF07;
	Tue, 23 Apr 2024 21:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908695;
	bh=A43twmQEzg4L8zn/5Rrv5uvp/jads3y7OZST9BOR6vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z43HQfp2q2Uy6l657n/O5sr3c6YW5F34Kht6S9FDkBBNPlq7/ABSqBFZ9YYN9a1d3
	 Nghceo8NX5lfZtPJdFOL0t1ByDTbrBmJdceS7o777Gk7dxrDH3IFz60etA+ne+LIh3
	 tUQRrpSAnIWjzbBj68BcVVcz1vXEqMwEzFIBt7m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/141] ice: tc: allow zero flags in parsing tc flower
Date: Tue, 23 Apr 2024 14:38:32 -0700
Message-ID: <20240423213854.692113030@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 73278715725a8347032acf233082ca4eb31e6a56 ]

The check for flags is done to not pass empty lookups to adding switch
rule functions. Since metadata is always added to lookups there is no
need to check against the flag.

It is also fixing the problem with such rule:
$ tc filter add dev gtp_dev ingress protocol ip prio 0 flower \
	enc_dst_port 2123 action drop
Switch block in case of GTP can't parse the destination port, because it
should always be set to GTP specific value. The same with ethertype. The
result is that there is no other matching criteria than GTP tunnel. In
this case flags is 0, rule can't be added only because of defensive
check against flags.

Fixes: 9a225f81f540 ("ice: Support GTP-U and GTP-C offload in switchdev")
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_tc_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
index 652ef09eeb305..ec6628aacc13b 100644
--- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
@@ -663,7 +663,7 @@ ice_eswitch_add_tc_fltr(struct ice_vsi *vsi, struct ice_tc_flower_fltr *fltr)
 	int ret;
 	int i;
 
-	if (!flags || (flags & ICE_TC_FLWR_FIELD_ENC_SRC_L4_PORT)) {
+	if (flags & ICE_TC_FLWR_FIELD_ENC_SRC_L4_PORT) {
 		NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported encap field(s)");
 		return -EOPNOTSUPP;
 	}
-- 
2.43.0



