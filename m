Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591043;
	b=KcHTHnOd3NAUCwfiUvi8AY8+2Wln0lFRFTJkgBItn/IMv+HuFCpEezgXA1nHqdW9a5wO
	 kSzgXG0GjrHCgktaSRVp/h5dYRRpfWKWfVdobzIWPymBZSB+tmeH79f65wxmKkUNFjQiu
	 xy7dtH0LtOEKs8z6XOUb4CfVEGw7HuZbYvrqUsiwH146HOlzVzcpEQcGrBuhBSjwg6KIY
	 C7Xi62XPnD9S9zlQe2vU6RAnSINm2YrbMWIAmo3Pf3hN+Bs49gXPbAn9+vjH37qdKN6sh
	 bmuE2euiBhXG6zzauZ8MlLonY41NsVIChoXGlzZO9JAVVHmrUHo8sm/TZiyIkAKJljA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Au37OKhv9ukuL0KAy15m7Y/DZ7alpX9+hVXm9oaxaw4=;
	b=KRCeAEHFukylwNysfx9AAo6BjhpC8rPl5h0ykBGdVxsobzPFDRgX0GyHAuKEU/Tf35co
	 t2v+9heznUC7suSeSGMfZYfCjOd5UKas6cPU+W6R3iEmhU0zGqcomzK/56K3y+oyrFQGV
	 AhOglvLRkOPFHhs2s/X6GOJ0WwzOXotpSip5sftWjlOwxOAeZ3ZbU/gvdfWYBmEeh7LAW
	 FyTZNVKcW+jttYzsn2k/6o4d9CmAIzNF+fGaNEE9WKt+pW7x7waSnvPWUKkfyqmKmVhS1
	 ubXLufOGoIiUE5L8tc6oUY29PsNIjwJ2p17a/wOHjgOgnPuYPs4/2py9wqi76mxMEaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLtJOP+P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44087606A8A4;
	Fri, 13 Nov 2026 17:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jLtJOP+P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E483C1F000C4;
	Fri, 13 Nov 2026 17:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591043;
	bh=Au37OKhv9ukuL0KAy15m7Y/DZ7alpX9+hVXm9oaxaw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLtJOP+P7hdCkNFxH6qXT8xwQMi3Dj+ynDgUvAsD2Dl7ncMtT7CQU/V4HQ/vEcXPQ
	 H6HtQnpeZIE3Bq6QXVm3S1Xn9iMYqRMPQaTdZJK6b7Jkh8nAnEXIqB9+f1b4NeFrB8
	 1lvt2dhfCLg3iKqTvuF+75oJVThv2M/8+IXbrKHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 208/670] scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store
Date: Fri, 13 Nov 2026 10:46:12 -0500
Message-ID: <20261113153818.988471778@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 717931267bda0..6b9adab3d11ee 100644
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



