Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D377C4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4E4C4339B;
	Wed, 15 Mar 2023 12:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884057;
	bh=LfnVXaZHJarVpu2QSBKIG9RKXVGF8e3mBnm3yQ86NWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YSMTEZNNcBgB6gXr3k+nErsB+r1KGJJ4bqeoqR+J3BhwLbJ4cinTkMZlx/I2G+mx
	 mDCPqZDGYI/K8scTfqMyphyteYJ4e+WqJVwtfPd3Wh1+n/feyfiuaU9FhbPfrxlX4Z
	 565p0DIPP9eSXl4Qj3ujvztNK3FgNmqmO6U/uyvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrien Moulin <amoulin@corp.free.fr>,
	Tariq Toukan <tariqt@nvidia.com>,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 090/141] net: tls: fix device-offloaded sendpage straddling records
Date: Wed, 15 Mar 2023 13:13:13 +0100
Message-Id: <20230315115742.724338706@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit e539a105f947b9db470fec39fe91d85fe737a432 ]

Adrien reports that incorrect data is transmitted when a single
page straddles multiple records. We would transmit the same
data in all iterations of the loop.

Reported-by: Adrien Moulin <amoulin@corp.free.fr>
Link: https://lore.kernel.org/all/61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr
Fixes: c1318b39c7d3 ("tls: Add opt-in zerocopy mode of sendfile()")
Tested-by: Adrien Moulin <amoulin@corp.free.fr>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20230304192610.3818098-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 6c593788dc250..a7cc4f9faac28 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -508,6 +508,8 @@ static int tls_push_data(struct sock *sk,
 			zc_pfrag.offset = iter_offset.offset;
 			zc_pfrag.size = copy;
 			tls_append_frag(record, &zc_pfrag, copy);
+
+			iter_offset.offset += copy;
 		} else if (copy) {
 			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
 
-- 
2.39.2



