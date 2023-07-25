Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A2014263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6854AC433C7;
	Tue, 25 Jul 2023 10:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282608;
	bh=QtUzT5Tbn8JOfBZ9L6FnCLO6tZ6AeyvF3B+5gddClRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRqk3Z/McK9D18sXZXN0iQm9kmUtTImoJQu1SukH3yLMGBdU9lJ5puIcKInSwcn1J
	 LToipFFcXAdcyX3vT4yyYGg5pBAsUzzOapCgQqDTCOOpBeA469VfAS47u+z/xLISz/
	 NpTA3pYmL6USNITBkpj31EmVYcKRMthyr4N1gfjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 161/227] ASoC: SOF: ipc3-dtrace: uninitialized data in dfsentry_trace_filter_write()
Date: Tue, 25 Jul 2023 12:45:28 +0200
Message-ID: <20230725104521.603208789@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 469e2f28c2cbee2430058c1c9bb6d1675d7195fb ]

This doesn't check how many bytes the simple_write_to_buffer() writes to
the buffer.  The only thing that we know is that the first byte is
initialized and the last byte of the buffer is set to NUL.  However
the middle bytes could be uninitialized.

There is no need to use simple_write_to_buffer().  This code does not
support partial writes but instead passes "pos = 0" as the starting
offset regardless of what the user passed as "*ppos".  Just use the
copy_from_user() function and initialize the whole buffer.

Fixes: 671e0b90051e ("ASoC: SOF: Clone the trace code to ipc3-dtrace as fw_tracing implementation")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/74148292-ce4d-4e01-a1a7-921e6767da14@moroto.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-dtrace.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/soc/sof/ipc3-dtrace.c b/sound/soc/sof/ipc3-dtrace.c
index 1d3bca2d28dd6..35da85a45a9ae 100644
--- a/sound/soc/sof/ipc3-dtrace.c
+++ b/sound/soc/sof/ipc3-dtrace.c
@@ -186,7 +186,6 @@ static ssize_t dfsentry_trace_filter_write(struct file *file, const char __user
 	struct snd_sof_dfsentry *dfse = file->private_data;
 	struct sof_ipc_trace_filter_elem *elems = NULL;
 	struct snd_sof_dev *sdev = dfse->sdev;
-	loff_t pos = 0;
 	int num_elems;
 	char *string;
 	int ret;
@@ -201,11 +200,11 @@ static ssize_t dfsentry_trace_filter_write(struct file *file, const char __user
 	if (!string)
 		return -ENOMEM;
 
-	/* assert null termination */
-	string[count] = 0;
-	ret = simple_write_to_buffer(string, count, &pos, from, count);
-	if (ret < 0)
+	if (copy_from_user(string, from, count)) {
+		ret = -EFAULT;
 		goto error;
+	}
+	string[count] = '\0';
 
 	ret = trace_filter_parse(sdev, string, &num_elems, &elems);
 	if (ret < 0)
-- 
2.39.2



