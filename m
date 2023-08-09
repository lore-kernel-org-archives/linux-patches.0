Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173BB17758
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F06FC433C7;
	Wed,  9 Aug 2023 11:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580748;
	bh=2NNlylEC0BWVn2vs3V1jDT7IIw/qOx5fTmyv3HTzgG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5vizpljRvKt4/MeN5+pLjmpOjlo2qLQ5JEIujbw/DFYYDftp2gfPld0NpBaZYq8z
	 qGCbbYxILErj29tZDJv92jBbW8tiaPuhTPvU0yw/eU9uuqBsNRnUk8mkkd5dPvil5l
	 1CJ4ul9/55ICMiMtRRCcL4Dwm9m/PQYlsMSxbbeg=
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
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 5.4 135/154] test_firmware: return ENOMEM instead of ENOSPC on failed memory allocation
Date: Wed,  9 Aug 2023 12:42:46 +0200
Message-ID: <20230809103641.353309222@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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

commit 7dae593cd226a0bca61201cf85ceb9335cf63682 upstream.

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
---
 lib/test_firmware.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -173,7 +173,7 @@ static int __kstrncpy(char **dst, const
 {
 	*dst = kstrndup(name, count, gfp);
 	if (!*dst)
-		return -ENOSPC;
+		return -ENOMEM;
 	return count;
 }
 
@@ -509,7 +509,7 @@ static ssize_t trigger_request_store(str
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s'\n", name);
 
@@ -552,7 +552,7 @@ static ssize_t trigger_async_request_sto
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s'\n", name);
 
@@ -597,7 +597,7 @@ static ssize_t trigger_custom_fallback_s
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s' using custom fallback mechanism\n", name);
 
@@ -648,7 +648,7 @@ static int test_fw_run_batch_request(voi
 
 		test_buf = kzalloc(TEST_FIRMWARE_BUF_SIZE, GFP_KERNEL);
 		if (!test_buf)
-			return -ENOSPC;
+			return -ENOMEM;
 
 		req->rc = request_firmware_into_buf(&req->fw,
 						    req->name,


