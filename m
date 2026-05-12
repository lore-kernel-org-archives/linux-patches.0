Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E183C0A1A;
	Tue, 12 May 2026 17:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608487; cv=none; b=c8KQtuL1xvThTlleoaKYjRHBgeLtbuvl0B4wCvCIeJwo66BG40bbGefU0omBKnucpeWG3PE0j6ZihqkAKe4w7Uc3yyN5bcwpDo85Zk62+skp4iGyeR/+/Q7DBuxDVcnczXNtaZwEsnjykJG8s8mJm7JKRjVwakc98+NnFv3stz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608487; c=relaxed/simple;
	bh=b/Ib7usvQ9SkhPO2h4atVdNilaEtaw/QguPlt8z7U4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKgIw07xuuns4AiQsq0NC0C77ojCkPjBTv3+c5sRdACUbUiCC2fymUMsPS2gbdjzvHJBvpP4amooJssjBowsLV1kfBKSIDX2kCnrjg4WkyrjJSo8dTVEppzytOQ7YpFIhrFPJhBFy/RK//G/2AYOz4UNXJmJzojpJm9QfCt1fGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZwThPK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZwThPK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886BEC2BCC7;
	Tue, 12 May 2026 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608486;
	bh=b/Ib7usvQ9SkhPO2h4atVdNilaEtaw/QguPlt8z7U4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZwThPK7aQOrYwTKrnA0riqZlAAQPUNJo+VN6jD42nqa/OOoI6dY/uNT7RzBn0Lye
	 aGoN+2ueTVOITOR/NQnw1oliAz5VoUVlW/BBHlluEjyhbC7BfETh9RD2yWWDmulWsB
	 gXJn2OvrakijYafhotTpexyD5W+CqKTcwPg9jcPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 098/270] pseries/papr-hvpipe: Fix the usage of copy_to_user()
Date: Tue, 12 May 2026 19:38:19 +0200
Message-ID: <20260512173940.522184814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

commit d48654bd8b1a75f662e224d257db54de475120dc upstream.

copy_to_user() return bytes_not_copied to the user buffer. If there was
an error writing bytes into the user buffer, i.e. if copy_to_user
returns a non-zero value, then we should simply return -EFAULT from the
->read() call.

Otherwise, in the non-patched version, we may end up mixing
"bytes_not_copied + bytes_copied (HVPIPE_HDR_LEN)" as the return value
to the user in ->read() call

Also let's make sure we clear the hvpipe_status flag, if we have
consumed the hvpipe msg by making the rtas call. ret = -EFAULT means
copy_to_user has failed but that still means that the msg was read from
the hvpipe, hence for both cases, success & -EFAULT, we should clear the
HVPIPE_MSG_AVAILABLE flag in hvpipe_status.

Cc: stable@vger.kernel.org
Fixes: cebdb522fd3edd1 ("powerpc/pseries: Receive payload with ibm,receive-hvpipe-msg RTAS")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/8fda3212a1ad48879c174e92f67472d9b9f1c3b7.1777606826.git.ritesh.list@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/papr-hvpipe.c | 23 ++++++++++++--------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr-hvpipe.c b/arch/powerpc/platforms/pseries/papr-hvpipe.c
index 800649f309a5..c007560d2d8c 100644
--- a/arch/powerpc/platforms/pseries/papr-hvpipe.c
+++ b/arch/powerpc/platforms/pseries/papr-hvpipe.c
@@ -206,10 +206,11 @@ static int hvpipe_rtas_recv_msg(char __user *buf, int size)
 					bytes_written, size);
 				bytes_written = size;
 			}
-			ret = copy_to_user(buf,
+			if (copy_to_user(buf,
 					rtas_work_area_raw_buf(work_area),
-					bytes_written);
-			if (!ret)
+					bytes_written))
+				ret = -EFAULT;
+			else
 				ret = bytes_written;
 		}
 	} else {
@@ -328,7 +329,7 @@ static ssize_t papr_hvpipe_handle_read(struct file *file,
 
 	struct hvpipe_source_info *src_info = file->private_data;
 	struct papr_hvpipe_hdr hdr = {};
-	long ret;
+	ssize_t ret = 0;
 
 	/*
 	 * Return -ENXIO during migration
@@ -376,7 +377,7 @@ static ssize_t papr_hvpipe_handle_read(struct file *file,
 
 	ret = copy_to_user(buf, &hdr, HVPIPE_HDR_LEN);
 	if (ret)
-		return ret;
+		return -EFAULT;
 
 	/*
 	 * Message event has payload, so get the payload with
@@ -385,19 +386,23 @@ static ssize_t papr_hvpipe_handle_read(struct file *file,
 	if (hdr.flags & HVPIPE_MSG_AVAILABLE) {
 		ret = hvpipe_rtas_recv_msg(buf + HVPIPE_HDR_LEN,
 				size - HVPIPE_HDR_LEN);
-		if (ret > 0) {
+		/*
+		 * Always clear MSG_AVAILABLE once the RTAS call has drained
+		 * the message, regardless of whether copy_to_user succeeded.
+		 */
+		if (ret >= 0 || ret == -EFAULT)
 			src_info->hvpipe_status &= ~HVPIPE_MSG_AVAILABLE;
-			ret += HVPIPE_HDR_LEN;
-		}
 	} else if (hdr.flags & HVPIPE_LOST_CONNECTION) {
 		/*
 		 * Hypervisor is closing the pipe for the specific
 		 * source. So notify user space.
 		 */
 		src_info->hvpipe_status &= ~HVPIPE_LOST_CONNECTION;
-		ret = HVPIPE_HDR_LEN;
 	}
 
+	if (ret >= 0)
+		ret += HVPIPE_HDR_LEN;
+
 	return ret;
 }
 
-- 
2.54.0



