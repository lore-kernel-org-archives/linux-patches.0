Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C835B255F2C;
	Tue, 17 Mar 2026 17:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767870; cv=none; b=WbhvkbPCY98R5rayTFpVh9S86UPHABKyYPVzQj6+bU5lVEG8Ol7MoCHk7OqkRE+j2ZgUmJDV5vgpcl9we3CB05Y9KBZ0f13B9j8PnGBcmva9dzeYPZ9+LYIWUM8o2vYY2K3KvxxCynVR/CVH+4ncpOOU5JUia8Ijo1GZEIJfZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767870; c=relaxed/simple;
	bh=bMe1kEpP65MVaMlzxl4o7ayd+jYaV2owLLBlhw7guWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5AQi7LzMyoB8KpOgqP/eNyCsWM9dfQvVrRRFnFbpgUKvE6QE6wqbfGn4PmIF+XWzlfBjnLfGnKmVPfzUr83+ZlqSHSOncDVOJjBr3mAfQSCu0294r6ZN1OXTRk1Udu5X/8V5owGv8CrWwDiHHOi2XTXQ7H02Gav3zy7qcn6RmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOm3YaMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOm3YaMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53874C4CEF7;
	Tue, 17 Mar 2026 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767870;
	bh=bMe1kEpP65MVaMlzxl4o7ayd+jYaV2owLLBlhw7guWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOm3YaMa4MrAxrztb5Ib5FgUoziyE9/e/ZBVQiu9TIcyCgdINKByoWlVGxUJzysec
	 2fEVKffBDN0jGCSCrWD1JAmN1w1bQOeFveO2njpjomeC1t/w/OOTkZCYNR3Hd1nkOD
	 fYQPVqt8HbqOdIPDd5uJ47DUT7w94NuizjBoIc6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 144/333] usb: mdc800: handle signal and read racing
Date: Tue, 17 Mar 2026 17:32:53 +0100
Message-ID: <20260317163004.699594146@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
@@ -707,7 +707,7 @@ static ssize_t mdc800_device_read (struc
 		if (signal_pending (current)) 
 		{
 			mutex_unlock(&mdc800->io_lock);
-			return -EINTR;
+			return len == left ? -EINTR : len-left;
 		}
 
 		sts=left > (mdc800->out_count-mdc800->out_ptr)?mdc800->out_count-mdc800->out_ptr:left;


