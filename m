Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C134735C6AB;
	Tue, 21 Jul 2026 21:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668639; cv=none; b=HP542RE9zOgLaqqK0Vy+jnn0zsUxPFFZDAqKMoR+svQXiUms61pingwUPWBNu25Mh+AqQMEkIQbryjhkiuTsu6eCYnmRDk8TdjRGJH67QsmX4V4rIT/4CbaU9v4T8Un7z1DJ1HTyrtkppWCvSlfFu+aLhdp8jPIO1vjkFi37AwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668639; c=relaxed/simple;
	bh=A3pDUxQ9i0Fnvv+YtYaM4bkyEdyUrS3yb/pv83rrKbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/BWuK8NcPkkZg7g4pi8VI8En3vtuzHEiAw2qzBhByXAFI+z1NoEpPpQZbJRKVSvY1M95D8HSWeTbRG1YhrL1krPKLeVDvJ0tIt0qVqhtkOyeZynANCD507gqvCii0HzFyHMl9XHJhOHv0hsvfkoPWFGDWGUb5rrSxoIj5dUPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOpqXGqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOpqXGqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675AA1F00A3A;
	Tue, 21 Jul 2026 21:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668633;
	bh=Zj5c10Kwg4ZwxwDqKq590U3bb9J5i3GZijmfbGoErrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOpqXGqo61EbNTSzG/87NWyEnACh+XaI8MPgrpLWDRVDET0lQCBVjvHBcG97uUgtB
	 oMqcqrnvAwrRXN6AbVIjaOimd75P0gUnWHQgo2CvConSv7UnMN9ocy/v43NMzwHua5
	 tW3LjEOVZRunLYXGqqI1hYDulNZjcLg77dlwvFRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0251/1067] smb: client: reject overlapping data areas in SMB2 responses
Date: Tue, 21 Jul 2026 17:14:12 +0200
Message-ID: <20260721152430.212870856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>

commit 8986c932905ea508d66da421eb2eb6e676ace1fe upstream.

Commit 53b7c271f06b ("smb: client: restrict implied bcc[0] exemption to
responses without data area") restricted the implied bcc[0] length
exception to responses without a data area. However, the overlap
handling in __smb2_calc_size() clears data_length, which can make an
invalid response appear to have no data area and so qualify for the
exception.

Track data area overlap separately and reject such responses before
applying the length compatibility exceptions.

Fixes: 53b7c271f06b ("smb: client: restrict implied bcc[0] exemption to responses without data area")
Cc: stable@vger.kernel.org
Signed-off-by: Shoichiro Miyamoto <shoichiro.miyamoto@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2misc.c |   34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -18,7 +18,8 @@
 #include "nterr.h"
 #include "cached_dir.h"
 
-static unsigned int __smb2_calc_size(void *buf, bool *have_data);
+static unsigned int __smb2_calc_size(void *buf, bool *have_data,
+				     bool *data_area_overlap);
 
 static int
 check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
@@ -146,6 +147,7 @@ smb2_check_message(char *buf, unsigned i
 	__u32 calc_len; /* calculated length */
 	__u64 mid;
 	bool have_data;
+	bool data_area_overlap;
 
 	/* If server is a channel, select the primary channel */
 	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
@@ -230,7 +232,12 @@ smb2_check_message(char *buf, unsigned i
 	}
 
 	have_data = false;
-	calc_len = __smb2_calc_size(buf, &have_data);
+	data_area_overlap = false;
+	calc_len = __smb2_calc_size(buf, &have_data, &data_area_overlap);
+
+	/* Reject responses whose data area overlaps the fixed area. */
+	if (data_area_overlap)
+		return 1;
 
 	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
 	 * be 0, and not a real miscalculation */
@@ -414,14 +421,15 @@ smb2_get_data_area_len(int *off, int *le
 }
 
 /*
- * Calculate the size of the SMB message based on the fixed header
- * portion, the number of word parameters and the data portion of the message.
- * If have_data is non-NULL, it is set to true when a non-empty data area was
- * found (data_length > 0), allowing callers to distinguish the implied bcc[0]
- * case (no data area) from an overreported data length.
+ * Calculate the size of the SMB message based on the fixed header, fixed
+ * parameter area, and variable data area.
+ *
+ * If have_data is not NULL, it is set when a non-empty data area is found.
+ * If data_area_overlap is not NULL, it is set when the data area overlaps
+ * the fixed area.
  */
 static unsigned int
-__smb2_calc_size(void *buf, bool *have_data)
+__smb2_calc_size(void *buf, bool *have_data, bool *data_area_overlap)
 {
 	struct smb2_pdu *pdu = buf;
 	struct smb2_hdr *shdr = &pdu->hdr;
@@ -430,6 +438,11 @@ __smb2_calc_size(void *buf, bool *have_d
 	/* Structure Size has already been checked to make sure it is 64 */
 	int len = le16_to_cpu(shdr->StructureSize);
 
+	if (have_data)
+		*have_data = false;
+	if (data_area_overlap)
+		*data_area_overlap = false;
+
 	/*
 	 * StructureSize2, ie length of fixed parameter area has already
 	 * been checked to make sure it is the correct length.
@@ -452,7 +465,10 @@ __smb2_calc_size(void *buf, bool *have_d
 		if (offset + 1 < len) {
 			cifs_dbg(VFS, "data area offset %d overlaps SMB2 header %d\n",
 				 offset + 1, len);
+			if (data_area_overlap)
+				*data_area_overlap = true;
 			data_length = 0;
+			goto calc_size_exit;
 		} else {
 			len = offset + data_length;
 		}
@@ -467,7 +483,7 @@ calc_size_exit:
 unsigned int
 smb2_calc_size(void *buf)
 {
-	return __smb2_calc_size(buf, NULL);
+	return __smb2_calc_size(buf, NULL, NULL);
 }
 
 /* Note: caller must free return buffer */


