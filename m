Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D4F238D3A;
	Tue, 30 Sep 2025 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243774; cv=none; b=P+aeaCEUFb5wly29Rac1Xtr2B042bTSo2bJqrpaHlEB9D0JmuLW8PFI77gFIPzVk1TER9xW0Jairh56l8qg4Q9IpFiU+r8uK0lDLJU8EwbLpo+ZQQKU+eJ5aNGsppCZfSz6hyO4IvkllqZtwDJqORJaOtyCXgQHh00q6YQa7NhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243774; c=relaxed/simple;
	bh=mGIo1iVK1MX+RDtK5R70pxESSEAHwlZTL3ghZacO0Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+tgtU1vp75G81ePom/6YmRL039yUBGjxO0nsryKsuugHhVb2JwE1Q2W37g4ycSt+a4y5NN9U1OR2Qlj0/RucX+KUgT0eEoQ0EUZpMQR2yK0kdf9q083+K7k80wU1tUUJkCwiFmgilWxS6X9phVqYGT5wFYtusQqzsHrmr9YIp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYqc6QnK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYqc6QnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02294C4CEF0;
	Tue, 30 Sep 2025 14:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243774;
	bh=mGIo1iVK1MX+RDtK5R70pxESSEAHwlZTL3ghZacO0Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYqc6QnK1yI2FwXATgsw6apUwij0CvlccirK3ThLbQZ4Yeo/KW/BELDQmoYlefQyb
	 VoeT78iK+xAiLArLdtxREoGX5VjrbkVWoI8hxS6HEWgPeiIS85/+4lzOoEHX0QpxO3
	 QRo0h7PbRF41Wjym3CA+rBWnb5vMu8cJh8181itA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabian Vogt <fvogt@suse.de>
Subject: [PATCH 5.4 14/81] tty: hvc_console: Call hvc_kick in hvc_write unconditionally
Date: Tue, 30 Sep 2025 16:46:16 +0200
Message-ID: <20250930143820.267002859@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Vogt <fvogt@suse.de>

commit cfd956dcb101aa3d25bac321fae923323a47c607 upstream.

After hvc_write completes, call hvc_kick also in the case the output
buffer has been drained, to ensure tty_wakeup gets called.

This fixes that functions which wait for a drained buffer got stuck
occasionally.

Cc: stable <stable@kernel.org>
Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230062
Signed-off-by: Fabian Vogt <fvogt@suse.de>
Link: https://lore.kernel.org/r/2011735.PYKUYFuaPT@fvogt-thinkpad
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_console.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -543,10 +543,10 @@ static int hvc_write(struct tty_struct *
 	}
 
 	/*
-	 * Racy, but harmless, kick thread if there is still pending data.
+	 * Kick thread to flush if there's still pending data
+	 * or to wakeup the write queue.
 	 */
-	if (hp->n_outbuf)
-		hvc_kick();
+	hvc_kick();
 
 	return written;
 }


