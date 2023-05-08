Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B870168C4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BDAC433EF;
	Mon,  8 May 2023 11:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545469;
	bh=ovHfEM0fyjLv6XsaWbJU/Bs5Arfg6u26HFvANVF/FWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+8RAE3NLe2vckAdOXfBS9UpDxhf2uPwtDwJE78Rv/QC2sZvqAYzjyIzzgskdqyfo
	 uI7gB+Vf7k5bR1gYBCEKPTDobaNLHtbqNMBP7fB5SQ2y13RBlCAsul5fnMr9opNNzQ
	 5ZLOF8NeY5fJRWva9RvBSDC7sWm3tpmuQWwqLbQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 032/371] kheaders: Use array declaration instead of char
Date: Mon,  8 May 2023 11:43:53 +0200
Message-Id: <20230508094813.383869397@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

commit b69edab47f1da8edd8e7bfdf8c70f51a2a5d89fb upstream.

Under CONFIG_FORTIFY_SOURCE, memcpy() will check the size of destination
and source buffers. Defining kernel_headers_data as "char" would trip
this check. Since these addresses are treated as byte arrays, define
them as arrays (as done everywhere else).

This was seen with:

  $ cat /sys/kernel/kheaders.tar.xz >> /dev/null

  detected buffer overflow in memcpy
  kernel BUG at lib/string_helpers.c:1027!
  ...
  RIP: 0010:fortify_panic+0xf/0x20
  [...]
  Call Trace:
   <TASK>
   ikheaders_read+0x45/0x50 [kheaders]
   kernfs_fop_read_iter+0x1a4/0x2f0
  ...

Reported-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/bpf/20230302112130.6e402a98@kernel.org/
Acked-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Tested-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 43d8ce9d65a5 ("Provide in-kernel headers to make extending kernel easier")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20230302224946.never.243-kees@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kheaders.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/kernel/kheaders.c
+++ b/kernel/kheaders.c
@@ -26,15 +26,15 @@ asm (
 "	.popsection				\n"
 );
 
-extern char kernel_headers_data;
-extern char kernel_headers_data_end;
+extern char kernel_headers_data[];
+extern char kernel_headers_data_end[];
 
 static ssize_t
 ikheaders_read(struct file *file,  struct kobject *kobj,
 	       struct bin_attribute *bin_attr,
 	       char *buf, loff_t off, size_t len)
 {
-	memcpy(buf, &kernel_headers_data + off, len);
+	memcpy(buf, &kernel_headers_data[off], len);
 	return len;
 }
 
@@ -48,8 +48,8 @@ static struct bin_attribute kheaders_att
 
 static int __init ikheaders_init(void)
 {
-	kheaders_attr.size = (&kernel_headers_data_end -
-			      &kernel_headers_data);
+	kheaders_attr.size = (kernel_headers_data_end -
+			      kernel_headers_data);
 	return sysfs_create_bin_file(kernel_kobj, &kheaders_attr);
 }
 


