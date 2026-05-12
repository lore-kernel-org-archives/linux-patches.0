Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22B023E356;
	Tue, 12 May 2026 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609329; cv=none; b=Ii4o0yfpogTLXJfuBf/DN3ndUxVS4dY3jAKezqM/BH/GNi9Ixkl8gEOxSPKkXvycOYpnAYw2bSFYF49gcpxTYOF22/7SSUZN0YZ6lqsqNV+Q06U4dstjTWed/WvC5wiO/hQ2K39RvQ64GI5XnIr0lWztsXihaFtVQVuW1MqiRF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609329; c=relaxed/simple;
	bh=3PkyPpF7UZIrWh551sgJK+lNxYJ+I95I/NQMvkBmYvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUAB3cPpeApemn9b7KUaDHPZtTonZrZP89J86tdY+xYKKTbvsRFh2tmmWfnK+e3u6wAL6Qk9z4dgiiK2fvfvPcipZ/PQk2a+mV1fR+xDudpgCTjbzp66EZRz+kU3Y/rtHwgjpR4csRetfV87pXwS0Poa5dSxsruuNecwSvyqng0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OBI0xjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OBI0xjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D26C2BCB0;
	Tue, 12 May 2026 18:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609328;
	bh=3PkyPpF7UZIrWh551sgJK+lNxYJ+I95I/NQMvkBmYvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OBI0xjomJXGOlW9ygVGaCU6LqJXe5dsekqlyVfDxSRDzaSfEc1vYkorh5zTe8jQ9
	 spuzYf1uO3KvHtHwNucH8rzCWbGc9ybklRfezGxT0fb81Rm3dMfh0IhgYT/jpoxq+F
	 UKvFvUl+5g/682D7wPlQjhVALedNRTNhnZw4qnO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.0 116/307] pseries/papr-hvpipe: Fix the usage of copy_to_user()
Date: Tue, 12 May 2026 19:38:31 +0200
Message-ID: <20260512173942.574080232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 arch/powerpc/platforms/pseries/papr-hvpipe.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/arch/powerpc/platforms/pseries/papr-hvpipe.c
+++ b/arch/powerpc/platforms/pseries/papr-hvpipe.c
@@ -206,10 +206,11 @@ static int hvpipe_rtas_recv_msg(char __u
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
@@ -328,7 +329,7 @@ static ssize_t papr_hvpipe_handle_read(s
 
 	struct hvpipe_source_info *src_info = file->private_data;
 	struct papr_hvpipe_hdr hdr = {};
-	long ret;
+	ssize_t ret = 0;
 
 	/*
 	 * Return -ENXIO during migration
@@ -376,7 +377,7 @@ static ssize_t papr_hvpipe_handle_read(s
 
 	ret = copy_to_user(buf, &hdr, HVPIPE_HDR_LEN);
 	if (ret)
-		return ret;
+		return -EFAULT;
 
 	/*
 	 * Message event has payload, so get the payload with
@@ -385,19 +386,23 @@ static ssize_t papr_hvpipe_handle_read(s
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
 


