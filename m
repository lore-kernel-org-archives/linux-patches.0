Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F16E28505E;
	Mon, 13 Apr 2026 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097461; cv=none; b=NU8ZXwMv3a042BtjMhNiKmDZ96Re+Su5YculAmlTz5M/FKZf7zCWpuKbuLbz0D5FW7zI/q02UZDbXP4lL88mQjTS88uImwrdx1lJ68ZUrEHYeCMN9Bzv+wGk+yHje72NbuVSUnMjoDVmT6cQASBXhwebahAqmxCiUVKl6NLNyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097461; c=relaxed/simple;
	bh=acvar/reN8CNEgsd6R36m8cmGFXFI/i5/6+pt78Dx10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVCeEN1hebpii1X5D6J/Rxbq5KPl6Dop3CFB6IJcoPQnTw3loh0v46pgLDIH1LJOLefUuVviw3Ae5sOiaq7pNOFDDzi50Ia+3iHJntGcepHUbP4hmHxK4C6/iId1QLNsmquG4SFbPNid5du3znIICNIyyASe0R9uRxdv4MzDETw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISmHHpGS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISmHHpGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85FAC2BCAF;
	Mon, 13 Apr 2026 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097461;
	bh=acvar/reN8CNEgsd6R36m8cmGFXFI/i5/6+pt78Dx10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISmHHpGSmkUrJUgVBsVIhQYhxcKJ4DboYUR6S/RKlTUvgmfwx2HsJuL//wR9vIrZA
	 5djJV1Lr+dY+KtZqhqzw4KpwDfYD7nkLYwXvM6QK5YA4yXUqmJL2lWCbftUfcl4u8U
	 xYMnXuE8kjqHESh1dDgUNoGDR1cekFsfU0BC2rlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 145/570] usb: mdc800: handle signal and read racing
Date: Mon, 13 Apr 2026 17:54:36 +0200
Message-ID: <20260413155835.875040984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 2d6d260e9a3576256fe9ef6d1f7930c9ec348723 upstream.

If a signal arrives after a read has partially completed,
we need to return the number of bytes read. -EINTR is correct
only if that number is zero.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260209142048.1503791-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/image/mdc800.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -708,7 +708,7 @@ static ssize_t mdc800_device_read (struc
 		if (signal_pending (current)) 
 		{
 			mutex_unlock(&mdc800->io_lock);
-			return -EINTR;
+			return len == left ? -EINTR : len-left;
 		}
 
 		sts=left > (mdc800->out_count-mdc800->out_ptr)?mdc800->out_count-mdc800->out_ptr:left;


