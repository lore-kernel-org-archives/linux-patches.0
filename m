Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585495;
	b=hmPw6Km8MMhrRL7Hp8FfWh1eLPAjRDLZ/kuJAW9qn/ln9td2LPnuEIMRFLdRYlpjN7eu
	 /ESWKzrCbCkcPZmyPb7wJvHR/bH8PXv9jBcdf+QOqdcTJfDfK9pq/TvKlQ77iT1SoAAEe
	 yrdJcvHQlz6lj1TivKyz5tUQI/yuWy78xBG80//0rY56bnQBFfIxHZZv7WRgztzDJeIA4
	 wIMOkq9p0G/nfMcc9QhW+f18rv08yAzqbhbJTny/3WbyBQ9FA7qF3+SvnDOGvkqba+XU/
	 U7272jq9axEnNDem6XXO2P+OXaWmeiImSa+vBbgHtJRiQz0ca0jxt+S8tHmfoYuY6iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kHTjmX/wMp2dRHD6NwvyJ7wurzxt4OiFneLI8tL5svY=;
	b=fuL0R+sB+YEbvqO6kdr2fK9Yaqz2+dm6bolNh59Aklefd/Ph0lTRCDlQH79sOUCFdOKv
	 o+k7VI4KSwX74QmAKbDlqzcebCg/W3jnoJv1sGswcYugvb116iXKFBbVpP149BvPAoU9Z
	 /oAhumZ/8+ZN0bse7Qw7+aMvnF2xjtmBVS5n9VtqwsE75KapUZJeKujh4CW4EH/JUYEcn
	 SldQwM26ZTjfbV3mzVDoWUGw2P+vy25+SjZqPGL6o1O7DLglJ6RVK7nvu3wDg215jUv+6
	 rIc0UkaQl8KHpwG6urZ1GA0bje6Sj4qldosnT4VCQG5oTAF4IZ3Bu8F49YcRnj0w/vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SVOQ7new;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB06606AE07;
	Fri, 13 Nov 2026 15:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SVOQ7new
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB061F000C5;
	Fri, 13 Nov 2026 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585495;
	bh=kHTjmX/wMp2dRHD6NwvyJ7wurzxt4OiFneLI8tL5svY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVOQ7newmKNd8VeWroUdYyi8l5+mGKy2TGJJTJFRpTcJlpup0Rg0IxgdNsny6jiaJ
	 G4y9KUZjITL2wtjfvGzJ8d83bo23how5FB8XYss7OxVwPrDc8ww7IB9PVLyUgiHZGS
	 qPwoWwPJ7P28LZmlNc+yUUVW+NvJcYE/twdio5uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 102/507] scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store
Date: Fri, 13 Nov 2026 10:46:46 -0500
Message-ID: <20261113153757.781966567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit b8d0bb6a8ba0d3878940a914a19336844101867b ]

tcmu_set_data_pages_per_blk() only validates the upper bound of the value
parsed from data_pages_per_blk=. Zero passes that check and is then used as
the divisor when computing udev->max_blocks:

  divide error: 0000 [#1] SMP
  ...
  tcmu_set_data_pages_per_blk
  tcmu_configure_device

Reject non-positive values, as the neighbouring max_data_area_mb and
cmd_ring_size setters already do.

Fixes: 08976cb548d6 ("scsi: target: tcmu: Make data_pages_per_blk changeable via configfs")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Cc: stable@vger.kernel.org
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Link: https://patch.msgid.link/20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index edc2afd5f4ee2..839d5b2e72506 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2524,6 +2524,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
 		return ret;
 	}
 
+	if (val <= 0) {
+		pr_err("Invalid data_pages_per_blk %d.\n", val);
+		return -EINVAL;
+	}
+
 	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
 		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
 		       val, udev->data_area_mb,
-- 
2.53.0



