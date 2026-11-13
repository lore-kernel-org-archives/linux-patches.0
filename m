Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590227;
	b=m7jyufpgckBV8Xtgod3Jv5d3wV/YQihxpAPy5bq025dDM1My8EvjhZwMKszKL5brnZXk
	 i/cpapy6AtIq8QgXKW0XwnRWyEtMJKq6ZPDHFKg5UiRgXozZACFzMFNPPp8eg3b0mvy60
	 xkxUJRhwu7p/FQkjAycSGSazDK+tENKs7MmfN3yXmXpx7No2mq0PqAmPE9xHk8WMf293G
	 tYlR3MYqY9PRUOQPyI/nphV2rC98qB9VqduNfGTp2YmHrxn6jZSnBHQUVEAoqlmjDQb+b
	 dhDlGotwQIHtT1ZJfz1C0OVNC8PQjONSkRQTGtpzROjBETS214TvimZNEDYVOydoGQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SjoI5NJviODIpaBC6iXyQnbTJlLx8WqXh8ixWRXiB60=;
	b=L1Bz/s/4iQk69AFBXirUHm/QkwnXCmyBVfJ9eDVhj/05TQ8ocgiwBWvoMNJu9iN7dPKN
	 EabXz8cH2kritOtzClwX0zZGjgs2pN5uTyKz1EIQf43bOFiEyt1grR3Bu43tzi3+eNX/Y
	 9g2FDN1k7pJQQiTpbXa88o+5NGTRV2PCtwMKfi/dcwQhRhq8TpnzQLHRKwrMaq0+lcOZy
	 +gbsPTOq8ykP9I/zcyrBVMEILxWxx5b10CjLjRnLPgJ1kGiHyvBPsd2yI2K0bmvmDfuKq
	 2FrsG2zib7lsA+fmHqJNyx1Dn/2HavaaMD+SscAnULW1lcT9Q+uh2dPPOmPAtYnGpBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsdpeZRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BE1606C0AC;
	Fri, 13 Nov 2026 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NsdpeZRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C581F000C4;
	Fri, 13 Nov 2026 17:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590226;
	bh=SjoI5NJviODIpaBC6iXyQnbTJlLx8WqXh8ixWRXiB60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsdpeZRGdFJXetwbz4RnXrg34HHftTYZgOQEf4f7S6LHD15LmArKmR7ko28Nqhn4u
	 Z+yx5mN4MIQ7Av/e+WZBA4Znm+FwlQV0JbhsJAuoUuwMIozAHEiPAWKu8BzX8RrB3b
	 UYf+f0h9Vo4NRQLDZItYN4odfik101lz0MAk77o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 225/686] scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store
Date: Fri, 13 Nov 2026 10:45:58 -0500
Message-ID: <20261113153828.648248062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3fd9636127758..72878700b1a6c 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2514,6 +2514,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
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



