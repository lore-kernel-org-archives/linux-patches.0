Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671AA476068;
	Fri,  7 Aug 2026 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116976; cv=none; b=QE4Fc1cJfxiKWFVYBtLAvFYlqV3krwMoHn7lQshfTpS9ZEChRubFh51pCpdtZrEXcZ3yhR0xJiqQQmbFY3tIWlq5EsozR+/u4JteNP+HeuwtUhQQeruROrbQG0SvzvPiG8mJmVu2HPJX/6I4B8R1DZgE8U+T1FBKZVv5fgVHMu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116976; c=relaxed/simple;
	bh=d1wZjCz3j6Cwyx/q5BL2ZDctOxnCnT84WPrjmW4f13A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4scbxt6CUllU+mOEHLPKi9R1hrAeHHrfXH68Aqjf1DL5Z/6KygRJcizWN0teyoVk18kXMBEUA/Yttf/DsRUYfZPi///l9Kuyv1nb0kT7iMGGiqXCO/RrHZ0Ujh8wryf6Op8z01pYKEVTEGaQHil6UdXx7tLT0tV93V4S2dmkTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTNpxjEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTNpxjEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A861F000E9;
	Fri,  7 Aug 2026 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116974;
	bh=aRwc4QiTNdTrhpOPMlD6oNLqv/LGt5I1hWXzhNVBCNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTNpxjEroxfZVoiaqsu120+SwP+u4TNIgBVovv9N5nrv427ULVoj4RkZjrbNAnJuR
	 gOfeN5BCM/fkoHQSlqTOEqoUPwfmhBAepQkHqV5lRFrekSTSJlC+Ojj97odtAwMBYC
	 dNVPR67DUHQgTmK6ItLIoarEMdD5Fju29W149DEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Block <bblock@linux.ibm.com>,
	M Nikhil <nikh1092@linux.ibm.com>,
	Chinmaya Kajagar <chinmayk@linux.ibm.com>,
	Nihar Panda <niharp@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 154/438] scsi: zfcp: Fix memory leak during adapter release by destroying gid_pn_req
Date: Fri,  7 Aug 2026 16:35:50 +0200
Message-ID: <20260807143431.319732246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Block <bblock@linux.ibm.com>

[ Upstream commit b601fa590e667bd9643feed8c869b6b3e418480d ]

When releasing an adapter we don't free the mempool 'gid_pn_req' that is
allocated during the enqueue. This leaks memory:

  unreferenced object 0xd8d29297de700 (size 256):
    comm "(udev-worker)", pid 2105, jiffies 4294945794
    hex dump (first 32 bytes):
      00 00 00 00 de ad 4e ad ff ff ff ff 00 00 00 00  ......N.........
      ff ff ff ff ff ff ff ff 00 0d c4 5f 67 9d 99 e0  ..........._g...
    backtrace (crc 4a5b5da2):
      [<000dc45f64da418c>] kmemleak_alloc+0x6c/0xa0
      [<000dc45f62b430aa>] __kmalloc_cache_node_noprof+0x36a/0x4d0
      [<000dc45f629a535a>] mempool_create_node_noprof+0xaa/0x150
      [<000dc45ee2c065e6>] zfcp_allocate_low_mem_buffers+0x96/0x370 [zfcp]
      [<000dc45ee2c070f8>] zfcp_adapter_enqueue+0x598/0xd40 [zfcp]
      [<000dc45ee2c08eb0>] zfcp_ccw_set_online+0x160/0x210 [zfcp]
      [<000dc45f643d4762>] ccw_device_set_online+0x232/0xd80
      [<000dc45f643d53d4>] online_store_recog_and_online+0x124/0x390
      [<000dc45f643d8238>] online_store+0x298/0x5b0
      [<000dc45f62eb0a04>] kernfs_fop_write_iter+0x2c4/0x480
      [<000dc45f62c81150>] new_sync_write+0x370/0x4b0
      [<000dc45f62c87abe>] vfs_write+0x43e/0x5b0
      [<000dc45f62c87ff4>] ksys_write+0x114/0x1f0
      [<000dc45f621c4a16>] do_syscall+0x2f6/0x430
      [<000dc45f64d9d5d8>] __do_syscall+0xc8/0x1c0
      [<000dc45f64dc2224>] system_call+0x74/0xa0

Fix this by destroying the mempool during the adapter's release.

Fixes: 799b76d09aee ("[SCSI] zfcp: Decouple gid_pn requests from erp")
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Tested-by: M Nikhil <nikh1092@linux.ibm.com>
Acked-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
Link: https://patch.msgid.link/20260720072736.3381816-2-niharp@linux.ibm.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/scsi/zfcp_aux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 8ff7db7921b5a..fea573e00f9df 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -253,6 +253,7 @@ static int zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
 static void zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
 {
 	mempool_destroy(adapter->pool.erp_req);
+	mempool_destroy(adapter->pool.gid_pn_req);
 	mempool_destroy(adapter->pool.scsi_req);
 	mempool_destroy(adapter->pool.scsi_abort);
 	mempool_destroy(adapter->pool.qtcb_pool);
-- 
2.53.0



