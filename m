Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C1A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EDDC433D2;
	Wed, 28 Dec 2022 15:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241111;
	bh=O4CxeNPEV5eLv/DcTRzwBruZmVuTTM/YybLnINaUCys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ybitUfwM7AZVQyQ+bWl7uYw8lLpEWN9EKvJZEbaQNYr4zZOB8eVdKFvvN31HDCZBr
	 jKQJDx2NmGbGcGq1/FeidQrV0HoBRwFZyTgM9suSQi9G3mrN3wf7LjmQJSCb7HhDA5
	 xaUi2eyz8/D5D8AurIXJ5vGQTLxbqa6H+M8pPOTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0206/1146] libbpf: Fix memory leak in parse_usdt_arg()
Date: Wed, 28 Dec 2022 15:29:05 +0100
Message-Id: <20221228144335.743297154@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 0dc9254e03704c75f2ebc9cbef2ce4de83fba603 ]

In the arm64 version of parse_usdt_arg(), when sscanf returns 2, reg_name
is allocated but not freed. Fix it.

Fixes: 0f8619929c57 ("libbpf: Usdt aarch64 arg parsing support")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-3-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/usdt.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/usdt.c b/tools/lib/bpf/usdt.c
index e83b497c2245..49f3c3b7f609 100644
--- a/tools/lib/bpf/usdt.c
+++ b/tools/lib/bpf/usdt.c
@@ -1348,25 +1348,23 @@ static int calc_pt_regs_off(const char *reg_name)
 
 static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec *arg)
 {
-	char *reg_name = NULL;
+	char reg_name[16];
 	int arg_sz, len, reg_off;
 	long off;
 
-	if (sscanf(arg_str, " %d @ \[ %m[a-z0-9], %ld ] %n", &arg_sz, &reg_name, &off, &len) == 3) {
+	if (sscanf(arg_str, " %d @ \[ %15[a-z0-9], %ld ] %n", &arg_sz, reg_name, &off, &len) == 3) {
 		/* Memory dereference case, e.g., -4@[sp, 96] */
 		arg->arg_type = USDT_ARG_REG_DEREF;
 		arg->val_off = off;
 		reg_off = calc_pt_regs_off(reg_name);
-		free(reg_name);
 		if (reg_off < 0)
 			return reg_off;
 		arg->reg_off = reg_off;
-	} else if (sscanf(arg_str, " %d @ \[ %m[a-z0-9] ] %n", &arg_sz, &reg_name, &len) == 2) {
+	} else if (sscanf(arg_str, " %d @ \[ %15[a-z0-9] ] %n", &arg_sz, reg_name, &len) == 2) {
 		/* Memory dereference case, e.g., -4@[sp] */
 		arg->arg_type = USDT_ARG_REG_DEREF;
 		arg->val_off = 0;
 		reg_off = calc_pt_regs_off(reg_name);
-		free(reg_name);
 		if (reg_off < 0)
 			return reg_off;
 		arg->reg_off = reg_off;
@@ -1375,12 +1373,11 @@ static int parse_usdt_arg(const char *arg_str, int arg_num, struct usdt_arg_spec
 		arg->arg_type = USDT_ARG_CONST;
 		arg->val_off = off;
 		arg->reg_off = 0;
-	} else if (sscanf(arg_str, " %d @ %m[a-z0-9] %n", &arg_sz, &reg_name, &len) == 2) {
+	} else if (sscanf(arg_str, " %d @ %15[a-z0-9] %n", &arg_sz, reg_name, &len) == 2) {
 		/* Register read case, e.g., -8@x4 */
 		arg->arg_type = USDT_ARG_REG;
 		arg->val_off = 0;
 		reg_off = calc_pt_regs_off(reg_name);
-		free(reg_name);
 		if (reg_off < 0)
 			return reg_off;
 		arg->reg_off = reg_off;
-- 
2.35.1



