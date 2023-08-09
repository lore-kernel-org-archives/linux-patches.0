Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D4F17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADF0C433C8;
	Wed,  9 Aug 2023 11:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580337;
	bh=8YUW6AFXjo412kZxzPY+R84ofg7OfwgpLaGsGghoCMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LQ1RUAtyacK6BhicCJXrQSe3lEzCOxJanTYfDs/m3eqi0v0gfCuHVMUNUZvd+IOn
	 PDd9VxL6DkA+KwnnotYDILm+QoFfOiVyr9lmWlDsGUDd8d2FBCaRBFvN26H3W1w6ay
	 Flq5bhHwB4krM5HX9gyMHfisauv5YLPVgiDdXFbg=
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
Subject: [PATCH 4.19 313/323] test_firmware: return ENOMEM instead of ENOSPC on failed memory allocation
Date: Wed,  9 Aug 2023 12:42:31 +0200
Message-ID: <20230809103712.400540577@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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
 lib/test_firmware.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/lib/test_firmware.c
+++ b/lib/test_firmware.c
@@ -160,7 +160,7 @@ static int __kstrncpy(char **dst, const
 {
 	*dst = kstrndup(name, count, gfp);
 	if (!*dst)
-		return -ENOSPC;
+		return -ENOMEM;
 	return count;
 }
 
@@ -456,7 +456,7 @@ static ssize_t trigger_request_store(str
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s'\n", name);
 
@@ -497,7 +497,7 @@ static ssize_t trigger_async_request_sto
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s'\n", name);
 
@@ -540,7 +540,7 @@ static ssize_t trigger_custom_fallback_s
 
 	name = kstrndup(buf, count, GFP_KERNEL);
 	if (!name)
-		return -ENOSPC;
+		return -ENOMEM;
 
 	pr_info("loading '%s' using custom fallback mechanism\n", name);
 


