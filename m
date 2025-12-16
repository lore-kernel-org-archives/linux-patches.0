Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9676E346E51;
	Tue, 16 Dec 2025 11:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885546; cv=none; b=Ig3Kds9ndvW6NytjDQAwlyxQ4+Pt8EgF81OTAeNvgeU/aHZDBOKOFGqH1Frn8egPnQEqY+Mof4rVZScuDiwq3EX/rZLyx2ZQz5Ij/WMVSQPqZs9XY2c6JamAbfG12RJw9muWiAtTWC4kxl9n4KeNELAWABdstoMP+BB5Wwdcbpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885546; c=relaxed/simple;
	bh=TCYNtepyOjaT7l576oFP9Q9oVaGwI40rnJbSQnPHCOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANkrtWbGw38O521MNh88H/acrHDmCLYMG3dS1PEZkuZGeSf+ZGNyJXv4kenRBmhqHOh8RuzDh5Sa247NUgvv7R84rquiMF4I2hLNMvK3BbgG3C4Ke99xvh6mViW/h2T0fsAwgWJyHeRoXhB3iNOCB3FS8kitTtqh4GzP27qxj0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKT0m+wJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKT0m+wJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD6BC4CEF1;
	Tue, 16 Dec 2025 11:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885546;
	bh=TCYNtepyOjaT7l576oFP9Q9oVaGwI40rnJbSQnPHCOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKT0m+wJ6J7sN9pfX20wjBpG44xj8VT/wx2xfmCv0pUPpVBNi/XaOChrOopxazjdP
	 DgkkjNrLWYq31dbOQpVr72iX1ViRY2gjEQohmm9/DYD3WniwCWABDkGOceFx+b6cwn
	 BdXV9/qJBEiyPcvlLtZBOfaMIMWnqcjndwBTqQuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 137/507] wifi: ath12k: fix potential memory leak in ath12k_wow_arp_ns_offload()
Date: Tue, 16 Dec 2025 12:09:38 +0100
Message-ID: <20251216111350.492518047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit be5febd51c478bc8e24ad3480435f2754a403b14 ]

When the call to ath12k_wmi_arp_ns_offload() fails, the temporary memory
allocation for offload is not freed before returning. Fix that by
freeing offload in the error path.

Fixes: 1666108c74c4 ("wifi: ath12k: support ARP and NS offload")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251028170457.134608-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wow.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/wow.c b/drivers/net/wireless/ath/ath12k/wow.c
index dce9bd0bcaefb..e8481626f1940 100644
--- a/drivers/net/wireless/ath/ath12k/wow.c
+++ b/drivers/net/wireless/ath/ath12k/wow.c
@@ -758,6 +758,7 @@ static int ath12k_wow_arp_ns_offload(struct ath12k *ar, bool enable)
 		if (ret) {
 			ath12k_warn(ar->ab, "failed to set arp ns offload vdev %i: enable %d, ret %d\n",
 				    arvif->vdev_id, enable, ret);
+			kfree(offload);
 			return ret;
 		}
 	}
-- 
2.51.0



