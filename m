Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0375C35965;
	Tue, 16 Dec 2025 12:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887208; cv=none; b=cSJiD+kUvu/B5bF1sfudpNik6gK7STPnWeq1/PNKBnDgH3qBXLG57HZgDjYE5HiAz6cPQyBD4YqxktVAwUUUdwTJICRQ3VwpK+3xDNwRj8Qc2umrKiWl8l8IOPEc3Dei/e4XoTb9VEkn2w/xdgY9Z4CdGwPdKg0s83gdDDHrSnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887208; c=relaxed/simple;
	bh=UzzlsXLRbk41nNzXr/W6yVGbmeYUu1LRUCdaiZvoJU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9CJnQfxTYO/t17Qpy5CYpnkkBeqq3qA2DJJzUI71+Pu60R0YI6O/punDh9zzx430gYF8ZCpkvE7/jMURXBRi+WhnUIzCw6qFGSgho+yM+OvwiZxH+HbNdkjKgZFvjRTF4DF8VhIOw9vxTVdoICGpPZE3Y9Y8QqoIUr+W18fbmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fyrp1bMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fyrp1bMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67956C4CEF1;
	Tue, 16 Dec 2025 12:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887207;
	bh=UzzlsXLRbk41nNzXr/W6yVGbmeYUu1LRUCdaiZvoJU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fyrp1bMBF5plvHOGH/X83yB5YFCoIvujt4RlPGosSwW3Zmk8bu1CCyfNCaldxdZhJ
	 4tCNBRoued1wVJB2wItYQfuMVWhuEoZJS35aBKrvv6BQ7iyhkpdsPF4ndZZ1IEIcus
	 Jjup7EK/ekKaOFz8csDVnV61snqenH6Tsfcaq1xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/614] docs: kdoc: fix duplicate section warning message
Date: Tue, 16 Dec 2025 12:08:46 +0100
Message-ID: <20251216111407.097805254@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit e5e7ca66a7fc6b8073c30a048e1157b88d427980 ]

The python version of the kernel-doc parser emits some strange warnings
with just a line number in certain cases:

$ ./scripts/kernel-doc -Wall -none 'include/linux/virtio_config.h'
Warning: 174
Warning: 184
Warning: 190
Warning: include/linux/virtio_config.h:226 No description found for return value of '__virtio_test_bit'
Warning: include/linux/virtio_config.h:259 No description found for return value of 'virtio_has_feature'
Warning: include/linux/virtio_config.h:283 No description found for return value of 'virtio_has_dma_quirk'
Warning: include/linux/virtio_config.h:392 No description found for return value of 'virtqueue_set_affinity'

I eventually tracked this down to the lone call of emit_msg() in the
KernelEntry class, which looks like:

  self.emit_msg(self.new_start_line, f"duplicate section name '{name}'\n")

This looks like all the other emit_msg calls. Unfortunately, the definition
within the KernelEntry class takes only a message parameter and not a line
number. The intended message is passed as the warning!

Pass the filename to the KernelEntry class, and use this to build the log
message in the same way as the KernelDoc class does.

To avoid future errors, mark the warning parameter for both emit_msg
definitions as a keyword-only argument. This will prevent accidentally
passing a string as the warning parameter in the future.

Also fix the call in dump_section to avoid an unnecessary additional
newline.

Fixes: e3b42e94cf10 ("scripts/lib/kdoc/kdoc_parser.py: move kernel entry to a class")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Message-ID: <20251030-jk-fix-kernel-doc-duplicate-return-warning-v2-1-ec4b5c662881@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/lib/kdoc/kdoc_parser.py | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/scripts/lib/kdoc/kdoc_parser.py b/scripts/lib/kdoc/kdoc_parser.py
index 2376f180b1fa9..ccbc1fe4b7ccd 100644
--- a/scripts/lib/kdoc/kdoc_parser.py
+++ b/scripts/lib/kdoc/kdoc_parser.py
@@ -274,6 +274,8 @@ class KernelEntry:
 
         self.leading_space = None
 
+        self.fname = fname
+
         # State flags
         self.brcount = 0
         self.declaration_start_line = ln + 1
@@ -288,9 +290,11 @@ class KernelEntry:
         return '\n'.join(self._contents) + '\n'
 
     # TODO: rename to emit_message after removal of kernel-doc.pl
-    def emit_msg(self, log_msg, warning=True):
+    def emit_msg(self, ln, msg, *, warning=True):
         """Emit a message"""
 
+        log_msg = f"{self.fname}:{ln} {msg}"
+
         if not warning:
             self.config.log.info(log_msg)
             return
@@ -336,7 +340,7 @@ class KernelEntry:
                 # Only warn on user-specified duplicate section names
                 if name != SECTION_DEFAULT:
                     self.emit_msg(self.new_start_line,
-                                  f"duplicate section name '{name}'\n")
+                                  f"duplicate section name '{name}'")
                 # Treat as a new paragraph - add a blank line
                 self.sections[name] += '\n' + contents
             else:
@@ -387,15 +391,15 @@ class KernelDoc:
             self.emit_msg(0,
                           'Python 3.7 or later is required for correct results')
 
-    def emit_msg(self, ln, msg, warning=True):
+    def emit_msg(self, ln, msg, *, warning=True):
         """Emit a message"""
 
-        log_msg = f"{self.fname}:{ln} {msg}"
-
         if self.entry:
-            self.entry.emit_msg(log_msg, warning)
+            self.entry.emit_msg(ln, msg, warning=warning)
             return
 
+        log_msg = f"{self.fname}:{ln} {msg}"
+
         if warning:
             self.config.log.warning(log_msg)
         else:
-- 
2.51.0



