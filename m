Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D956200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADF6C433C8;
	Fri, 21 Jul 2023 19:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966313;
	bh=w/y9tb2lQ1ew5uriU0ahHKP/27LdKVIXQ95/qAgOcB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rY6gJr5vOJ47TaD13rFENXzLfgbsMU962paGHoK39mL1JWVmnJl4mm/+vPz4J0uMv
	 Svsw2kSnnRav3ydvWzjId/OYc+HJ4fL78JwR0pfc1XGj9tuARd4v9pDU+NlDgAf5eY
	 vzZzZTJi4pxKIrfqk7VDwi+d7Crwt9u2nYrHP4pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Kees Cook <keescook@chromium.org>,
	"Luis R. Rodriguez" <mcgrof@ruslug.rutgers.edu>,
	Scott Branden <sbranden@broadcom.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Brian Norris <briannorris@chromium.org>,
	Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 300/532] test_firmware: return ENOMEM instead of ENOSPC on failed memory allocation
Date: Fri, 21 Jul 2023 18:03:24 +0200
Message-ID: <20230721160630.668952292@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>

[ Upstream commit 7dae593cd226a0bca61201cf85ceb9335cf63682 ]

In a couple of situations like

	name = kstrndup(buf, count, GFP_KERNEL);
	if (!name)
		return -ENOSPC;

the error is not actually "No space left on device", but "Out of memory".

It is semantically correct to return -ENOMEM in all failed kstrndup()
and kzalloc() cases in this driver, as it is not a problem with disk
space, but with kernel memory allocator failing allocation.

The semantically correct should be:

        name = kstrndup(buf, count, GFP_KERNEL);
        if (!name)
                return -ENOMEM;

Cc: Dan Carpenter <error27@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Luis R. Rodriguez" <mcgrof@ruslug.rutgers.edu>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Brian Norris <briannorris@chromium.org>
Fixes: c92316bf8e948 ("test_firmware: add batched firmware tests")
Fixes: 0a8adf584759c ("test: add firmware_class loader test")
Fixes: 548193cba2a7d ("test_firmware: add support for firmware_request_platform")
Fixes: eb910947c82f9 ("test: firmware_class: add asynchronous request trigger")
Fixes: 061132d2b9c95 ("test_firmware: add test custom fallback trigger")
Fixes: 7feebfa487b92 ("test_firmware: add support for request_firmware_into_buf")
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Message-ID: <20230606070808.9300-1-mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_firmware.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/test_firmware.c b/lib/test_firmware.c
index 2a4078946a3fd..b64f87f4f2284 100644
--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -183,7 +183,7 @@ static int __kstrncpy(char **dst, const char *name, size_t count, gfp_t gfp)
 {
 	*dst = kstrndup(name, count, gfp);
 	if (!*dst)
-		return -ENOSPC;
+		return -ENOMEM;
 	return count;
 }
 
@@ -606,7 +606,7 @@ static ssize_t trigger_request_store(struct device *dev,
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s'\n", name);
 
@@ -654,7 +654,7 @@ static ssize_t trigger_request_platform_store(struct device *dev,
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("inserting test platform fw '%s'\n", name);
 	efi_embedded_fw.name = name;
@@ -707,7 +707,7 @@ static ssize_t trigger_async_request_store(struct device *dev,
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s'\n", name);
 
@@ -752,7 +752,7 @@ static ssize_t trigger_custom_fallback_store(struct device *dev,
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s' using custom fallback mechanism\n", name);
 
@@ -803,7 +803,7 @@ static int test_fw_run_batch_request(void *data)
 
 		test_buf = kzalloc(TEST_FIRMWARE_BUF_SIZE, GFP_KERNEL);
 		if (!test_buf)
-			return -ENOSPC;
+			return -ENOMEM;
 
 		if (test_fw_config->partial)
 			req->rc = request_partial_firmware_into_buf
-- 
2.39.2



