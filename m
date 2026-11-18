Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037626;
	b=ZFMPXpEWZP3EubTmyw0UsjGGnhFCmLwDBtpoUfUslXpd0FISfmjRYSuDpf7ZKO/kaTYB
	 atUMU9o9bGwWXsnP7jtlhCGzNaNE75vxAGazHtdwSodMoVePJY5wTqb8Zx9KSAqZ3p9Ay
	 AByQ7N6BSWDYkzmA8jwFwvKetnCRfaVgEl+feoUq4VKyeoRE6RLLQNH30uJ5eMWwwwM3M
	 koj8T35SdkMeHSJqMQ5qTXe9Sc2abFEK6L3CouQzy/QkYCxUygkcO1Ul1o2wPfPcn/kdG
	 Wzs7TpmUQlHHf8m4cNP++rmrYag/4zjBayzrE8KqfQC4jPLKP23kRPbq981pU0918sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bUPKtRow+39VERf4h0TH9CQJNTlygKzXeat9P+avA4I=;
	b=l9mPm0cHI9ktjCg5dyh+cHofb3O67+yvGv4+eqi1W3nptyOe4X6jnDeTbhy7AsRCzBTk
	 FLbs4YG9lsWnAVHpDWji3xVeUXNZQodxuCwKgSfpcum+8KZ0lce3JrrVWckJmswAGpZHx
	 Hn0FuX0bQbYbzz7zWX+efKZjp38uMamC+FzIpnPzj74oslHcRtvUuqcZOTd6EbLLZ1wEh
	 iVAeB2YE3GNd0BWCrqnI0UrKkVWYR1axW0xTpkqrn4ztSDQGmNchb62POuD5mAOms9xH6
	 a8zkqcIfCJ3fewy/GkTFw0q87Slg3Z55tEtETVF95Xuxi8PWCBaBufoGoIM9Oz23eEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geGLxfDE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14077606A325;
	Wed, 18 Nov 2026 21:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=geGLxfDE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698C61F000C4;
	Wed, 18 Nov 2026 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037625;
	bh=bUPKtRow+39VERf4h0TH9CQJNTlygKzXeat9P+avA4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=geGLxfDEeGdXCY9M81jSeHehNdy8pCLcSa7kFK+mi65VNoKoqC8bfctRyTHcSsRVk
	 KYoUCiRzM6ZW4PAQAydBq6AI+cMZ6mxwkh7vCyAgriFvLeWg/bdEda3pK1eHW3TB/A
	 WDnww7F7KPpBuukMKAS7Isnd5ftXhLOeEYWPPxcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1426/3318] scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store
Date: Wed, 18 Nov 2026 15:34:08 +0100
Message-ID: <20261118150403.504531711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2e100b76914a0..6e896e905fd6a 100644
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



