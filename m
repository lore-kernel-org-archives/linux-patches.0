Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61342258F
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97F9C4339E;
	Thu, 23 Feb 2023 13:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157943;
	bh=V+zYl9zkS5oAYAWCkniidp1NAxsc0BaVZSBroS7AqSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5men+KfVSEo9jRt+vvNY+mqLZiOvn8R/KBYC18d1TS3jt7apUEH710t4dMBHr6P/
	 L36FDPYOcMEfRGJESbWXK3DepJQfKuyWBHsU66OVjejwY2RWiL/fxQSeVI6uhm+oYN
	 a8ha29PqTrOYmcMrV4PD83Pj76remoBYRDWWdzfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	lee@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Carlos Llamas <cmllamas@google.com>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 5.15 25/36] binder: fix pointer cast warning
Date: Thu, 23 Feb 2023 14:07:01 +0100
Message-Id: <20230223130430.224723961@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit 9a0a930fe2535a76ad70d3f43caeccf0d86a3009 upstream.

binder_uintptr_t is not the same as uintptr_t, so converting it into a
pointer requires a second cast:

drivers/android/binder.c: In function 'binder_translate_fd_array':
drivers/android/binder.c:2511:28: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
 2511 |         sender_ufda_base = (void __user *)sender_uparent->buffer + fda->parent_offset;
      |                            ^

Fixes: 656e01f3ab54 ("binder: read pre-translated fds from sender buffer")
Acked-by: Todd Kjos <tkjos@google.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20211207122448.1185769-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -2544,7 +2544,8 @@ static int binder_translate_fd_array(str
 	 */
 	fda_offset = (parent->buffer - (uintptr_t)t->buffer->user_data) +
 		fda->parent_offset;
-	sender_ufda_base = (void __user *)sender_uparent->buffer + fda->parent_offset;
+	sender_ufda_base = (void __user *)(uintptr_t)sender_uparent->buffer +
+				fda->parent_offset;
 
 	if (!IS_ALIGNED((unsigned long)fda_offset, sizeof(u32)) ||
 	    !IS_ALIGNED((unsigned long)sender_ufda_base, sizeof(u32))) {


