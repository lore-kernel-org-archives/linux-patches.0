Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA51A372B4B;
	Fri,  4 Sep 2026 05:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500468; cv=none; b=fUw22ocAUOshILZpQA+tXzBkKeyn2kIxOqtzP9HN5DxUAHzNtf0adEThggV7uSmVGmT9khEQqO/4qfuIstybN+ltQIRlGZ6yXTlIHX2Ya+iPIgaYRii/FfOg5yuPorw6XMJ1jRbl1C6zg5JeHbBuC/AyhqGReC3U7zXgvIUZE9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500468; c=relaxed/simple;
	bh=P/YayWLAujiFNkF6rUc3NnsEws0CUkLVWdPNpydiswo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bc6GAe6fI9EzoFeKYwh+R9mcGGldY3g7CkJY1cPBYxrL5U4v7eanftZgnAXa3uhnNjF99WoEKVqgA6avEyQ0hUOPC1D6LhZSIszW0VWMuPlyaCRnKU4MVvL45akmvTi+lr79ofv0kxPZJfFm21jaHrJESS7Jf7exOdaUbQshYPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mg+YjjJv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mg+YjjJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C2D1F00A3D;
	Fri,  4 Sep 2026 05:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500467;
	bh=KFh86wxnbEqKFLVeL0sZ3/fhEaxF6+VTVHWL8mHhmhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mg+YjjJvSys+3KQeEGPxHn2+0V82sktzVNDbaUI8F2t7dSDI7hRmqKBkK321g88YT
	 JEYyMq1BGPolq1B6CdOnlgVYBcKdFSVV7M3xW+NvrX0kiKa9wnAP8Ada2zV9nzw0zV
	 4jf6W8hXGt0njfh6zTHHQfRrQKmp26SaBh2rE5wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 6.18 065/552] misc: nsm: bound the device-reported response length
Date: Fri,  4 Sep 2026 06:53:42 +0200
Message-ID: <20260904045749.322255315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 808e530654a5354e6df78863a5d61e4d44e67235 upstream.

nsm_sendrecv_msg_locked() stores the virtqueue used-ring length reported
by the NSM device into msg->resp.len without bounding it to the response
buffer. A malicious or buggy backend can report a length larger than the
response buffer; parse_resp_raw() then copies that many bytes out of the
fixed buffer to user space, disclosing adjacent kernel heap (an
out-of-bounds read). The request path already floors its length in
fill_req_raw(); the response path lacks the symmetric check.

Clamp the stored length to the size of the response buffer. Well-behaved
devices report no more than the posted buffer size, so conforming traffic
is unaffected.

Fixes: b9873755a6c8 ("misc: Add Nitro Secure Module driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Alexander Graf <graf@amazon.com>
Link: https://patch.msgid.link/20260620-b4-disp-a54b7dd6-v1-1-79d1f236a854@proton.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/nsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/nsm.c
+++ b/drivers/misc/nsm.c
@@ -243,7 +243,7 @@ static int nsm_sendrecv_msg_locked(struc
 		goto cleanup;
 	}
 
-	msg->resp.len = len;
+	msg->resp.len = min_t(unsigned int, len, sizeof(msg->resp.data));
 
 	rc = 0;
 


