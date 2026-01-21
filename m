Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40D5347BD1;
	Wed, 21 Jan 2026 18:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020134; cv=none; b=mnnZTLjacLywRMdKc0HHHRLOaFt5M2OzBBDrs/XTfMPBACmRPREfr1CzgKsdOD2cOzwjg+1CVJz1YbZH+VfbdrymrP3LC4HqyKefhNec2qSoFGAxyBudXOeQO74+KtXH2ewEHhtzgT3uv2j4FtJ9grHW5NcfJ+IrX0iAc1z359w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020134; c=relaxed/simple;
	bh=5fmsp6KdDL3o761PfePujnPB9eUCKcqo86iPvgvLLSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agkdVTTo177VwUAPg59qa5Q0r+Wbsl8lhDAMiMcMC1dGiaIrUfLom2O37+5ihknRp0/HBRRtvcNamX/1a4t9oiruiRfuIEZEhFDpC449LbT1nC8fws+EXxACa4UhEosmw/uGUO2vo1PaP1RpiFJsJpQmHgQUBuI7DyEN4VjXeQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXTme+/V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXTme+/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4070DC16AAE;
	Wed, 21 Jan 2026 18:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020134;
	bh=5fmsp6KdDL3o761PfePujnPB9eUCKcqo86iPvgvLLSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hXTme+/VIhQ53CU56pvnuwcZOJbVcftEm2A6UbEzi5kKOTFh+2aFGuXAWMQWlMpe0
	 a3p7X6z8p7Cklm3vQu2pNDSXCWvb4IDBvnJt3cbocNXTgmRQnI8N8qy2DAgmPFf032
	 eWHAittV6c4G/suXya9XPjPlo1jWRcXTXLao+WvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/198] block: zero non-PI portion of auto integrity buffer
Date: Wed, 21 Jan 2026 19:14:24 +0100
Message-ID: <20260121181419.850222431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit ca22c566b89164f6e670af56ecc45f47ef3df819 ]

The auto-generated integrity buffer for writes needs to be fully
initialized before being passed to the underlying block device,
otherwise the uninitialized memory can be read back by userspace or
anyone with physical access to the storage device. If protection
information is generated, that portion of the integrity buffer is
already initialized. The integrity data is also zeroed if PI generation
is disabled via sysfs or the PI tuple size is 0. However, this misses
the case where PI is generated and the PI tuple size is nonzero, but the
metadata size is larger than the PI tuple. In this case, the remainder
("opaque") of the metadata is left uninitialized.
Generalize the BLK_INTEGRITY_CSUM_NONE check to cover any case when the
metadata is larger than just the PI tuple.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: c546d6f43833 ("block: only zero non-PI metadata tuples in bio_integrity_prep")
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity-auto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
index 687952f63bbbf..b8b7587be9679 100644
--- a/block/bio-integrity-auto.c
+++ b/block/bio-integrity-auto.c
@@ -142,7 +142,7 @@ bool bio_integrity_prep(struct bio *bio)
 				return true;
 			set_flags = false;
 			gfp |= __GFP_ZERO;
-		} else if (bi->csum_type == BLK_INTEGRITY_CSUM_NONE)
+		} else if (bi->metadata_size > bi->pi_tuple_size)
 			gfp |= __GFP_ZERO;
 		break;
 	default:
-- 
2.51.0



