Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CE49446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E562C433C7;
	Sun, 13 Aug 2023 21:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691963167;
	bh=UH7wEnHk7hQoO3akTHWQnd5FSTxsSIvk/TIjwNixMws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6X3v0GkUeKQZNW5YWp69KXteZShvKWZuwdMmn0ijzK1lwESSBysAvK4ygnpw4QlT
	 4Mew26aPD6fMxYNrH3hQemVvN1BC9QS7E8iJp/43T+3DVujRu2UBBCqNtE342xTT9+
	 Y0CGltl5DD0aqswzXU1n/FuEhYqttxuD7sotYStE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Martin K Petersen <martin.petersen@oracle.com>,
	James Bottomley <jejb@linux.ibm.com>,
	Willy Tarreau <w@1wt.eu>,
	stable@kernel.org,
	Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 5.15 77/89] scsi: core: Fix legacy /proc parsing buffer overflow
Date: Sun, 13 Aug 2023 23:20:08 +0200
Message-ID: <20230813211713.082575221@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
References: <20230813211710.787645394@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Battersby <tonyb@cybernetics.com>

commit 9426d3cef5000824e5f24f80ed5f42fb935f2488 upstream.

(lightly modified commit message mostly by Linus Torvalds)

The parsing code for /proc/scsi/scsi is disgusting and broken.  We should
have just used 'sscanf()' or something simple like that, but the logic may
actually predate our kernel sscanf library routine for all I know.  It
certainly predates both git and BK histories.

And we can't change it to be something sane like that now, because the
string matching at the start is done case-insensitively, and the separator
parsing between numbers isn't done at all, so *any* separator will work,
including a possible terminating NUL character.

This interface is root-only, and entirely for legacy use, so there is
absolutely no point in trying to tighten up the parsing.  Because any
separator has traditionally worked, it's entirely possible that people have
used random characters rather than the suggested space.

So don't bother to try to pretty it up, and let's just make a minimal patch
that can be back-ported and we can forget about this whole sorry thing for
another two decades.

Just make it at least not read past the end of the supplied data.

Link: https://lore.kernel.org/linux-scsi/b570f5fe-cb7c-863a-6ed9-f6774c219b88@cybernetics.com/
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin K Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: stable@kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Signed-off-by: Martin K Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_proc.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -311,7 +311,7 @@ static ssize_t proc_scsi_write(struct fi
 			       size_t length, loff_t *ppos)
 {
 	int host, channel, id, lun;
-	char *buffer, *p;
+	char *buffer, *end, *p;
 	int err;
 
 	if (!buf || length > PAGE_SIZE)
@@ -326,10 +326,14 @@ static ssize_t proc_scsi_write(struct fi
 		goto out;
 
 	err = -EINVAL;
-	if (length < PAGE_SIZE)
-		buffer[length] = '\0';
-	else if (buffer[PAGE_SIZE-1])
-		goto out;
+	if (length < PAGE_SIZE) {
+		end = buffer + length;
+		*end = '\0';
+	} else {
+		end = buffer + PAGE_SIZE - 1;
+		if (*end)
+			goto out;
+	}
 
 	/*
 	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
@@ -338,10 +342,10 @@ static ssize_t proc_scsi_write(struct fi
 	if (!strncmp("scsi add-single-device", buffer, 22)) {
 		p = buffer + 23;
 
-		host = simple_strtoul(p, &p, 0);
-		channel = simple_strtoul(p + 1, &p, 0);
-		id = simple_strtoul(p + 1, &p, 0);
-		lun = simple_strtoul(p + 1, &p, 0);
+		host    = (p     < end) ? simple_strtoul(p, &p, 0) : 0;
+		channel = (p + 1 < end) ? simple_strtoul(p + 1, &p, 0) : 0;
+		id      = (p + 1 < end) ? simple_strtoul(p + 1, &p, 0) : 0;
+		lun     = (p + 1 < end) ? simple_strtoul(p + 1, &p, 0) : 0;
 
 		err = scsi_add_single_device(host, channel, id, lun);
 
@@ -352,10 +356,10 @@ static ssize_t proc_scsi_write(struct fi
 	} else if (!strncmp("scsi remove-single-device", buffer, 25)) {
 		p = buffer + 26;
 
-		host = simple_strtoul(p, &p, 0);
-		channel = simple_strtoul(p + 1, &p, 0);
-		id = simple_strtoul(p + 1, &p, 0);
-		lun = simple_strtoul(p + 1, &p, 0);
+		host    = (p     < end) ? simple_strtoul(p, &p, 0) : 0;
+		channel = (p + 1 < end) ? simple_strtoul(p + 1, &p, 0) : 0;
+		id      = (p + 1 < end) ? simple_strtoul(p + 1, &p, 0) : 0;
+		lun     = (p + 1 < end) ? simple_strtoul(p + 1, &p, 0) : 0;
 
 		err = scsi_remove_single_device(host, channel, id, lun);
 	}


