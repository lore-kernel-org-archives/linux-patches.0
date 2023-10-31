Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2547208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOzFLRvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6ABEC433C8;
	Tue, 31 Oct 2023 17:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774656;
	bh=Jn/fscTC40WucxoDOG6mkkxJ7fZ3oQ/3NaXDbI8D2JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOzFLRvOw/FOUWTrzpVyk+K80EyU5+12NFpmt3QtuMp6bsHPyWLukxPNKadNGFzDO
	 +tpy2PdIgpYnSE2CoKQC6Z+0sMtHVVBkUcXqOsyXk1n1UO6fIbDggXtCFRU66HiCYJ
	 auqO/IeMj6iG0I+LHB5+RZ2WyC3QZ7W6LC1aQI38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.5 098/112] misc: fastrpc: Unmap only if buffer is unmapped from DSP
Date: Tue, 31 Oct 2023 18:01:39 +0100
Message-ID: <20231031165904.376411753@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit 509143385db364c67556a914bef6c9a42fd2c74c upstream.

For unmapping any buffer from kernel, it should first be unmapped
from DSP. In case unmap from DSP request fails, the map should not
be removed from kernel as it might lead to SMMU faults and other
memory issues.

Fixes: 5c1b97c7d7b7 ("misc: fastrpc: add support for FASTRPC_IOCTL_MEM_MAP/UNMAP")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231013122007.174464-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1980,11 +1980,13 @@ static int fastrpc_req_mem_unmap_impl(st
 	sc = FASTRPC_SCALARS(FASTRPC_RMID_INIT_MEM_UNMAP, 1, 0);
 	err = fastrpc_internal_invoke(fl, true, FASTRPC_INIT_HANDLE, sc,
 				      &args[0]);
-	fastrpc_map_put(map);
-	if (err)
+	if (err) {
 		dev_err(dev, "unmmap\tpt fd = %d, 0x%09llx error\n",  map->fd, map->raddr);
+		return err;
+	}
+	fastrpc_map_put(map);
 
-	return err;
+	return 0;
 }
 
 static int fastrpc_req_mem_unmap(struct fastrpc_user *fl, char __user *argp)


