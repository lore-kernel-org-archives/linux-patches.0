Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651B91774C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF93C433C8;
	Wed,  9 Aug 2023 11:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579478;
	bh=0B4w8yT672LEU41zZFrzrUkp6So9MY7mja83t2lJo28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTRlKeW3joA5D9QQ+v7ju1jdwX2cDyhudbMi2Ws4LYzdRKcAIZWy8cv5232lFM/51
	 2z2R6U6kjv7igkN4JdbTjxXzt9pMgD4Kq/D4RsAH+rJdW5k6CowkxLcxJQ0jMAL8ep
	 LovWEEnZ/GZbWxUTgHwmErHhooOrkUXF1RUacA9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Russ Weight <russell.h.weight@intel.com>,
	Tianfei Zhang <tianfei.zhang@intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Colin Ian King <colin.i.king@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kselftest@vger.kernel.org,
	Dan Carpenter <error27@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 4.14 203/204] test_firmware: fix a memory leak with reqs buffer
Date: Wed,  9 Aug 2023 12:42:21 +0200
Message-ID: <20230809103649.301827663@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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

commit be37bed754ed90b2655382f93f9724b3c1aae847 upstream.

Dan Carpenter spotted that test_fw_config->reqs will be leaked if
trigger_batched_requests_store() is called two or more times.
The same appears with trigger_batched_requests_async_store().

This bug wasn't trigger by the tests, but observed by Dan's visual
inspection of the code.

The recommended workaround was to return -EBUSY if test_fw_config->reqs
is already allocated.

Fixes: 7feebfa487b92 ("test_firmware: add support for request_firmware_into_buf")
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russ Weight <russell.h.weight@intel.com>
Cc: Tianfei Zhang <tianfei.zhang@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Colin Ian King <colin.i.king@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kselftest@vger.kernel.org
Cc: stable@vger.kernel.org # v5.4
Suggested-by: Dan Carpenter <error27@gmail.com>
Suggested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20230509084746.48259-2-mirsad.todorovac@alu.unizg.hr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_firmware.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -621,6 +621,11 @@ static ssize_t trigger_batched_requests_
 
 	mutex_lock(&test_fw_mutex);
 
+        if (test_fw_config->reqs) {
+                rc = -EBUSY;
+                goto out_bail;
+        }
+
 	test_fw_config->reqs = vzalloc(sizeof(struct test_batched_req) *
 				       test_fw_config->num_requests * 2);
 	if (!test_fw_config->reqs) {
@@ -723,6 +728,11 @@ ssize_t trigger_batched_requests_async_s
 
 	mutex_lock(&test_fw_mutex);
 
+        if (test_fw_config->reqs) {
+                rc = -EBUSY;
+                goto out_bail;
+        }
+
 	test_fw_config->reqs = vzalloc(sizeof(struct test_batched_req) *
 				       test_fw_config->num_requests * 2);
 	if (!test_fw_config->reqs) {


