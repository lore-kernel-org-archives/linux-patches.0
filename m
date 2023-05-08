Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E58171AE
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05F0C433EF;
	Mon,  8 May 2023 11:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546457;
	bh=3gPY6mgdbqwYvtS6J5cD9ALHeONzHHLbq2YO+VLUE7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaDxfeyw6fW5PcM5B1QsatiP5dnzmt9iDjDayicWL45ZejI04WTkH31GOUjZOOa+0
	 ypu94h1W5vCfyQRoFQldi3F5fkioPkZ2+Z0+NroPt01Cv0ty+qQ+H5+sM9JFBO46F3
	 OWQuQ/wutPqM2QdAL7Hp/Q7K19W5Xlqus7LSpn2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng17@lenovo.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 357/371] scripts/gdb: fix lx-timerlist for Python3
Date: Mon,  8 May 2023 11:49:18 +0200
Message-Id: <20230508094826.285938646@linuxfoundation.org>
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

From: Peng Liu <liupeng17@lenovo.com>

commit 7362042f3556528e9e9b1eb5ce8d7a3a6331476b upstream.

Below incompatibilities between Python2 and Python3 made lx-timerlist fail
to run under Python3.

o xrange() is replaced by range() in Python3
o bytes and str are different types in Python3
o the return value of Inferior.read_memory() is memoryview object in
  Python3

akpm: cc stable so that older kernels are properly debuggable under newer
Python.

Link: https://lkml.kernel.org/r/TYCP286MB2146EE1180A4D5176CBA8AB2C6819@TYCP286MB2146.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Peng Liu <liupeng17@lenovo.com>
Reviewed-by: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/timerlist.py |    4 +++-
 scripts/gdb/linux/utils.py     |    5 ++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/timerlist.py
+++ b/scripts/gdb/linux/timerlist.py
@@ -73,7 +73,7 @@ def print_cpu(hrtimer_bases, cpu, max_cl
     ts = cpus.per_cpu(tick_sched_ptr, cpu)
 
     text = "cpu: {}\n".format(cpu)
-    for i in xrange(max_clock_bases):
+    for i in range(max_clock_bases):
         text += " clock {}:\n".format(i)
         text += print_base(cpu_base['clock_base'][i])
 
@@ -158,6 +158,8 @@ def pr_cpumask(mask):
     num_bytes = (nr_cpu_ids + 7) / 8
     buf = utils.read_memoryview(inf, bits, num_bytes).tobytes()
     buf = binascii.b2a_hex(buf)
+    if type(buf) is not str:
+        buf=buf.decode()
 
     chunks = []
     i = num_bytes
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -88,7 +88,10 @@ def get_target_endianness():
 
 
 def read_memoryview(inf, start, length):
-    return memoryview(inf.read_memory(start, length))
+    m = inf.read_memory(start, length)
+    if type(m) is memoryview:
+        return m
+    return memoryview(m)
 
 
 def read_u16(buffer, offset):


