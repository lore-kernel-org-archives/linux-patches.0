Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050059;
	b=Y5WL4ya6Xw3bo6Ni87DgIKJvPuqQeEK2AOSQwcAccgWZlvtFj3Rvc1tsBE+843t2QEGX
	 XFE0M6BUvcevKR6Xre971nkyBH0yIhfc2aFJhooDXu9qmKiQCJmYRz+9lHHj9lg57bsv9
	 rlXT7qXp5vduM7uXLIsiRRqEoKoNiUlRt4ayFzXDMq5XNR6hyoC2W/EAJZHCY+dEX4YHy
	 bi+D1R6VCJUr7CjwyIjiTONczsJo67fY3Vbjnpvq+h+Tg1vty5oCEEMQouQ0L50KED4h3
	 PdAz1a9y2spejCsu5K0abeo/s3BS/5Ah3LuGeAfVIB/5npe8GbXsiBsTSLIMWaMq21A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VLT0JVV1YsTff1ZGbWBWNiXMbYZXsEO+5o2kZLNwcTo=;
	b=jvCfggkpnEEZukKiYGJQS6njFnhj1E1Jg6oLu9IZN02US4SgYOvx1Ivk96HU4kjMPNDc
	 eNLoRg6aEW+GRBsyYYy4c8cCvJw3BqTZ4amUc1UabnLosFU6HQSgYQNOxTGziV5njiPI5
	 cG2uZSq8dINMEDFEBPF1KS0VqVdRNWTIsqahPoT45URTidj6jiSKGbt0Mzx+hSplj5WJD
	 CEBFBmAmpJdKaxn2GbGL33dU3CF7LmigPqoIz5RfL2YLX/j+Zmh945HNr7e9UFPPP6HTV
	 wuB9e0XPa0a1qOwrffPtgcMZs6YnjNFapkD/xRm0ryfjh1zIP5nJ1iXCpx2c8s77wkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mdg1gjf4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5E4606A325;
	Thu, 19 Nov 2026 01:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mdg1gjf4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FD91F000C4;
	Thu, 19 Nov 2026 01:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050058;
	bh=VLT0JVV1YsTff1ZGbWBWNiXMbYZXsEO+5o2kZLNwcTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mdg1gjf4VkqjdD8E2ez2voTTPSeG6bHZ/3LkM0aZWpTEafzq/VCnRu6zQcyme89aC
	 0ulojrAvfEe7KYFfPUO4VGRlQztPXACTm/Yx7eZK6I3z9Vv9fUKFLEkcN7cyRHz+pp
	 c5QlXOyZ+CHO4MdiZ5Q+cuQtZ98phODoYf2ICAl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2572/2857] blk-iocost: charge zone appends as writes
Date: Wed, 18 Nov 2026 16:00:06 +0100
Message-ID: <20261118150334.098892583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit febdbf5682fa7e8f325b07a2c115e7632c4252bd ]

Zone append is a primary write operation for zoned devices; zoned xfs
and btrfs use it for data writes.  It is priced at zero, so the zone
append portion of zoned workloads runs outside the controller: a
1%-weight cgroup issued 16000 appends at zero cost on a zoned null_blk.

Treat REQ_OP_ZONE_APPEND the same as REQ_OP_WRITE so it goes through
the existing seq/rand classification and charging.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260922043856.2020116-3-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 1b6cb8d8bf8c6..10c7cbea15932 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2526,6 +2526,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_RRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
-- 
2.53.0



