Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F282EBB84;
	Tue, 12 May 2026 17:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607996; cv=none; b=CSmN9wEqj/prYleNP578OWdNszxLS5V6VGDWkIyrKss0odvvlqz40BBz6xzdqkVvRvtRLq6pZiE7s9mAxxpPMNVd0CMlbNJHSIC6hfyZnPIhqxbgbQbCZKh09QoSvqq+BHHcXGDC5HDNiWy11nDOcq+PQuaE1e/QYbiz31wqoxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607996; c=relaxed/simple;
	bh=FRWgVSyFu22mYRw3sK9ANFN9Fhb30CDEAXdKZ0mE+MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPVLMGqhJxtJeIK8Y9aDzBSEKYO+HFm8wTaw3A5pK/WMEp8xPmwJQT5M2saCCKjUB79/8eBKyXqrm2qvjn9n3KxcRadlYTxIwJinl82MLy2og6AFNOETrharOTT5SFxOpXTCd+Pi9klItDwubo1Q559vx3J0uz6cTLb3kMnwdn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YnudEPZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnudEPZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71852C2BCB0;
	Tue, 12 May 2026 17:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607995;
	bh=FRWgVSyFu22mYRw3sK9ANFN9Fhb30CDEAXdKZ0mE+MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnudEPZjtT+jvBtBB59/l/Bbe5UeqDCLBe8W1fZNx6ywJPVM6ZHoW6Xn3PWPBa/jb
	 ygELzL9Mh+rjOel5jhNLQQXKO82MEgklWRaFDXns5HSJ2eZMjUE8JnMphvNaBZyaYu
	 nCU7aoBp182fALr+snUjQhbe6KeHYFmUf6yQwLTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Asleson <tasleson@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Bryn M. Reeves" <bmr@redhat.com>
Subject: [PATCH 6.12 117/206] dm: fix a buffer overflow in ioctl processing
Date: Tue, 12 May 2026 19:39:29 +0200
Message-ID: <20260512173935.334591654@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 2fa49cc884f6496a915c35621ba4da35649bf159 upstream.

Tony Asleson (using Claude) found a buffer overflow in dm-ioctl in the
function retrieve_status:

1. The code in retrieve_status checks that the output string fits into
   the output buffer and writes the output string there
2. Then, the code aligns the "outptr" variable to the next 8-byte
   boundary:
	outptr = align_ptr(outptr);
3. The alignment doesn't check overflow, so outptr could point past the
   buffer end
4. The "for" loop is iterated again, it executes:
	remaining = len - (outptr - outbuf);
5. If "outptr" points past "outbuf + len", the arithmetics wraps around
   and the variable "remaining" contains unusually high number
6. With "remaining" being high, the code writes more data past the end of
   the buffer

Luckily, this bug has no security implications because:
1. Only root can issue device mapper ioctls
2. The commonly used libraries that communicate with device mapper
   (libdevmapper and devicemapper-rs) use buffer size that is aligned to
   8 bytes - thus, "outptr = align_ptr(outptr)" can't overshoot the input
   buffer and the bug can't happen accidentally

Reported-by: Tony Asleson <tasleson@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Bryn M. Reeves <bmr@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1341,6 +1341,10 @@ static void retrieve_status(struct dm_ta
 		used = param->data_start + (outptr - outbuf);
 
 		outptr = align_ptr(outptr);
+		if (!outptr || outptr > outbuf + len) {
+			param->flags |= DM_BUFFER_FULL_FLAG;
+			break;
+		}
 		spec->next = outptr - outbuf;
 	}
 


