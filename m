Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADED16727B;
	Mon, 27 May 2024 19:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836531; cv=none; b=DZxVFn4bSlhlWTK4aj9M+ihf4a5fOlShnTerwZTPhWWRwqOPimsiHEx46zAfaR8i8+RDzSygYvlVWpFgRN/rLMoHdwn5hVqDCc3OpPLVJR5s7JNnlb+QJMCPHpu/k/3CkohUZrevfOT19P1+sTfFifsU6OTuXd/xn1Ce4fXlpR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836531; c=relaxed/simple;
	bh=U4GNHw+1R6HhVsyEZU1o3/I0m4rYsI7DO7sthNTzu00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlNNn9HkYUvf4ueVN/zWckA4ivjOiIwy0nmS7VoYvbEb5p0jYNB47aOPPDerW/T8bgdJ1xFj0WKwvjZnE9wDd4KQjKcMNsZ9OI5FqGYsb16MXubq9eypfn5DbkEfr4sx3xSfr4yF+BUGyfpn2RqCrbWFfo0MSv8kLXco1tT7vvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kc92TQnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kc92TQnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0429EC2BBFC;
	Mon, 27 May 2024 19:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836531;
	bh=U4GNHw+1R6HhVsyEZU1o3/I0m4rYsI7DO7sthNTzu00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kc92TQnUOz/4VxzYlfC/UWNRou61FIAg1GPb4sf2hd9DOCRdyIi2B4NpuBv42BuQH
	 Wc0UTRvE6fl30QduRYCqSvznVVPVrGihQxg15ZIgYZWTmSWTpbpBBFfSgaXiVaXTY9
	 00xTt+UmFGh/gkpw+9jEnxRtcYYVvZgIOGAx77X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naota@elisp.net>,
	INAGAKI Hiroshi <musashino.open@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 088/427] block: fix and simplify blkdevparts= cmdline parsing
Date: Mon, 27 May 2024 20:52:15 +0200
Message-ID: <20240527185609.958855548@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: INAGAKI Hiroshi <musashino.open@gmail.com>

[ Upstream commit bc2e07dfd2c49aaa4b52302cf7b55cf94e025f79 ]

Fix the cmdline parsing of the "blkdevparts=" parameter using strsep(),
which makes the code simpler.

Before commit 146afeb235cc ("block: use strscpy() to instead of
strncpy()"), we used a strncpy() to copy a block device name and partition
names. The commit simply replaced a strncpy() and NULL termination with
a strscpy(). It did not update calculations of length passed to strscpy().
While the length passed to strncpy() is just a length of valid characters
without NULL termination ('\0'), strscpy() takes it as a length of the
destination buffer, including a NULL termination.

Since the source buffer is not necessarily NULL terminated, the current
code copies "length - 1" characters and puts a NULL character in the
destination buffer. It replaces the last character with NULL and breaks
the parsing.

As an example, that buffer will be passed to parse_parts() and breaks
parsing sub-partitions due to the missing ')' at the end, like the
following.

example (Check Point V-80 & OpenWrt):

- Linux Kernel 6.6

  [    0.000000] Kernel command line: console=ttyS0,115200 earlycon=uart8250,mmio32,0xf0512000 crashkernel=30M mvpp2x.queue_mode=1 blkdevparts=mmcblk1:48M@10M(kernel-1),1M(dtb-1),720M(rootfs-1),48M(kernel-2),1M(dtb-2),720M(rootfs-2),300M(default_sw),650M(logs),1M(preset_cfg),1M(adsl),-(storage) maxcpus=4
  ...
  [    0.884016] mmc1: new HS200 MMC card at address 0001
  [    0.889951] mmcblk1: mmc1:0001 004GA0 3.69 GiB
  [    0.895043] cmdline partition format is invalid.
  [    0.895704]  mmcblk1: p1
  [    0.903447] mmcblk1boot0: mmc1:0001 004GA0 2.00 MiB
  [    0.908667] mmcblk1boot1: mmc1:0001 004GA0 2.00 MiB
  [    0.913765] mmcblk1rpmb: mmc1:0001 004GA0 512 KiB, chardev (248:0)

  1. "48M@10M(kernel-1),..." is passed to strscpy() with length=17
     from parse_parts()
  2. strscpy() returns -E2BIG and the destination buffer has
     "48M@10M(kernel-1\0"
  3. "48M@10M(kernel-1\0" is passed to parse_subpart()
  4. parse_subpart() fails to find ')' when parsing a partition name,
     and returns error

- Linux Kernel 6.1

  [    0.000000] Kernel command line: console=ttyS0,115200 earlycon=uart8250,mmio32,0xf0512000 crashkernel=30M mvpp2x.queue_mode=1 blkdevparts=mmcblk1:48M@10M(kernel-1),1M(dtb-1),720M(rootfs-1),48M(kernel-2),1M(dtb-2),720M(rootfs-2),300M(default_sw),650M(logs),1M(preset_cfg),1M(adsl),-(storage) maxcpus=4
  ...
  [    0.953142] mmc1: new HS200 MMC card at address 0001
  [    0.959114] mmcblk1: mmc1:0001 004GA0 3.69 GiB
  [    0.964259]  mmcblk1: p1(kernel-1) p2(dtb-1) p3(rootfs-1) p4(kernel-2) p5(dtb-2) 6(rootfs-2) p7(default_sw) p8(logs) p9(preset_cfg) p10(adsl) p11(storage)
  [    0.979174] mmcblk1boot0: mmc1:0001 004GA0 2.00 MiB
  [    0.984674] mmcblk1boot1: mmc1:0001 004GA0 2.00 MiB
  [    0.989926] mmcblk1rpmb: mmc1:0001 004GA0 512 KiB, chardev (248:0

By the way, strscpy() takes a length of destination buffer and it is
often confusing when copying characters with a specified length. Using
strsep() helps to separate the string by the specified character. Then,
we can use strscpy() naturally with the size of the destination buffer.

Separating the string on the fly is also useful to omit the redundant
string copy, reducing memory usage and improve the code readability.

Fixes: 146afeb235cc ("block: use strscpy() to instead of strncpy()")
Suggested-by: Naohiro Aota <naota@elisp.net>
Signed-off-by: INAGAKI Hiroshi <musashino.open@gmail.com>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/20240421074005.565-1-musashino.open@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/cmdline.c | 49 ++++++++++----------------------------
 1 file changed, 12 insertions(+), 37 deletions(-)

diff --git a/block/partitions/cmdline.c b/block/partitions/cmdline.c
index c03bc105e5753..152c85df92b20 100644
--- a/block/partitions/cmdline.c
+++ b/block/partitions/cmdline.c
@@ -70,8 +70,8 @@ static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
 	}
 
 	if (*partdef == '(') {
-		int length;
-		char *next = strchr(++partdef, ')');
+		partdef++;
+		char *next = strsep(&partdef, ")");
 
 		if (!next) {
 			pr_warn("cmdline partition format is invalid.");
@@ -79,11 +79,7 @@ static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
 			goto fail;
 		}
 
-		length = min_t(int, next - partdef,
-			       sizeof(new_subpart->name) - 1);
-		strscpy(new_subpart->name, partdef, length);
-
-		partdef = ++next;
+		strscpy(new_subpart->name, next, sizeof(new_subpart->name));
 	} else
 		new_subpart->name[0] = '\0';
 
@@ -117,14 +113,12 @@ static void free_subpart(struct cmdline_parts *parts)
 	}
 }
 
-static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
+static int parse_parts(struct cmdline_parts **parts, char *bdevdef)
 {
 	int ret = -EINVAL;
 	char *next;
-	int length;
 	struct cmdline_subpart **next_subpart;
 	struct cmdline_parts *newparts;
-	char buf[BDEVNAME_SIZE + 32 + 4];
 
 	*parts = NULL;
 
@@ -132,28 +126,19 @@ static int parse_parts(struct cmdline_parts **parts, const char *bdevdef)
 	if (!newparts)
 		return -ENOMEM;
 
-	next = strchr(bdevdef, ':');
+	next = strsep(&bdevdef, ":");
 	if (!next) {
 		pr_warn("cmdline partition has no block device.");
 		goto fail;
 	}
 
-	length = min_t(int, next - bdevdef, sizeof(newparts->name) - 1);
-	strscpy(newparts->name, bdevdef, length);
+	strscpy(newparts->name, next, sizeof(newparts->name));
 	newparts->nr_subparts = 0;
 
 	next_subpart = &newparts->subpart;
 
-	while (next && *(++next)) {
-		bdevdef = next;
-		next = strchr(bdevdef, ',');
-
-		length = (!next) ? (sizeof(buf) - 1) :
-			min_t(int, next - bdevdef, sizeof(buf) - 1);
-
-		strscpy(buf, bdevdef, length);
-
-		ret = parse_subpart(next_subpart, buf);
+	while ((next = strsep(&bdevdef, ","))) {
+		ret = parse_subpart(next_subpart, next);
 		if (ret)
 			goto fail;
 
@@ -199,24 +184,17 @@ static int cmdline_parts_parse(struct cmdline_parts **parts,
 
 	*parts = NULL;
 
-	next = pbuf = buf = kstrdup(cmdline, GFP_KERNEL);
+	pbuf = buf = kstrdup(cmdline, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
 	next_parts = parts;
 
-	while (next && *pbuf) {
-		next = strchr(pbuf, ';');
-		if (next)
-			*next = '\0';
-
-		ret = parse_parts(next_parts, pbuf);
+	while ((next = strsep(&pbuf, ";"))) {
+		ret = parse_parts(next_parts, next);
 		if (ret)
 			goto fail;
 
-		if (next)
-			pbuf = ++next;
-
 		next_parts = &(*next_parts)->next_parts;
 	}
 
@@ -250,7 +228,6 @@ static struct cmdline_parts *bdev_parts;
 static int add_part(int slot, struct cmdline_subpart *subpart,
 		struct parsed_partitions *state)
 {
-	int label_min;
 	struct partition_meta_info *info;
 	char tmp[sizeof(info->volname) + 4];
 
@@ -262,9 +239,7 @@ static int add_part(int slot, struct cmdline_subpart *subpart,
 
 	info = &state->parts[slot].info;
 
-	label_min = min_t(int, sizeof(info->volname) - 1,
-			  sizeof(subpart->name));
-	strscpy(info->volname, subpart->name, label_min);
+	strscpy(info->volname, subpart->name, sizeof(info->volname));
 
 	snprintf(tmp, sizeof(tmp), "(%s)", info->volname);
 	strlcat(state->pp_buf, tmp, PAGE_SIZE);
-- 
2.43.0



