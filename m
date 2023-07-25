Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40B21F165
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7829BC433C8;
	Tue, 25 Jul 2023 11:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284996;
	bh=hrMI2h1c06JO3SNxITp5DiYl+L6M7s9Z5kRILGvh2qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKo0zUrmi4HFTeqRzQb3leVxS91Onm2MfTmyauUm3VLsX31DHnZLrGHxoPFYM3Etn
	 MGRyALOATZe3hubZZbwvknni2ffbgnW/1xeS5D3bjzRMr3sontw9l4K2F3qTPwKVma
	 66TwdAwapUprMCaekT6HYKBLEQklT/HCQK0m9t+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 046/313] wifi: ray_cs: Utilize strnlen() in parse_addr()
Date: Tue, 25 Jul 2023 12:43:19 +0200
Message-ID: <20230725104523.056347346@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9e8e9187673cb24324f9165dd47b2b28f60b0b10 ]

Instead of doing simple operations and using an additional variable on stack,
utilize strnlen() and reuse len variable.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220603164414.48436-1-andriy.shevchenko@linux.intel.com
Stable-dep-of: 4f8d66a9fb2e ("wifi: ray_cs: Fix an error handling path in ray_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ray_cs.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 3836d6ac53049..29dd303a7beae 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -1641,31 +1641,29 @@ static void authenticate_timeout(struct timer_list *t)
 /*===========================================================================*/
 static int parse_addr(char *in_str, UCHAR *out)
 {
+	int i, k;
 	int len;
-	int i, j, k;
 	int status;
 
 	if (in_str == NULL)
 		return 0;
-	if ((len = strlen(in_str)) < 2)
+	len = strnlen(in_str, ADDRLEN * 2 + 1) - 1;
+	if (len < 1)
 		return 0;
 	memset(out, 0, ADDRLEN);
 
 	status = 1;
-	j = len - 1;
-	if (j > 12)
-		j = 12;
 	i = 5;
 
-	while (j > 0) {
-		if ((k = hex_to_bin(in_str[j--])) != -1)
+	while (len > 0) {
+		if ((k = hex_to_bin(in_str[len--])) != -1)
 			out[i] = k;
 		else
 			return 0;
 
-		if (j == 0)
+		if (len == 0)
 			break;
-		if ((k = hex_to_bin(in_str[j--])) != -1)
+		if ((k = hex_to_bin(in_str[len--])) != -1)
 			out[i] += k << 4;
 		else
 			return 0;
-- 
2.39.2



