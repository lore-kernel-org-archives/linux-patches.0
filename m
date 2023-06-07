Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4A719BC9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBCFC433EF;
	Wed,  7 Jun 2023 20:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170341;
	bh=XbtT5uO7a6nqUL47UckCoROPRq0YKLC6Il5Lx32n8Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjoxmSsyjs6S9puhWe60EhTMRSpEVCeOpSHBndAiUjBcORPUIwdmwa2FHjCKltaM2
	 VDxDUKBRddeUvRW+4ZnhoRLWlhQr+x37kzRSwwvWErHtpy3+Dku66aGcMVgfao8u8g
	 fuSBebG5Aj0s+oUTvqORWpYwO71wiLGw4FN8+sFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/225] net/sched: flower: fix possible OOB write in fl_set_geneve_opt()
Date: Wed,  7 Jun 2023 22:14:00 +0200
Message-ID: <20230607200915.890261866@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 4d56304e5827c8cc8cc18c75343d283af7c4825c ]

If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
size is 252 bytes(key->enc_opts.len = 252) then
key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
bypasses the next bounds check and results in an out-of-bounds.

Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Link: https://lore.kernel.org/r/20230531102805.27090-1-hbh25y@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 25bc57ee6ea10..3de72e7c1075a 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1147,6 +1147,9 @@ static int fl_set_geneve_opt(const struct nlattr *nla, struct fl_flow_key *key,
 	if (option_len > sizeof(struct geneve_opt))
 		data_len = option_len - sizeof(struct geneve_opt);
 
+	if (key->enc_opts.len > FLOW_DIS_TUN_OPTS_MAX - 4)
+		return -ERANGE;
+
 	opt = (struct geneve_opt *)&key->enc_opts.data[key->enc_opts.len];
 	memset(opt, 0xff, option_len);
 	opt->length = data_len / 4;
-- 
2.39.2



