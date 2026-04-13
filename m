Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE6F23E342;
	Mon, 13 Apr 2026 16:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098828; cv=none; b=qNF9LKRXqOZ/RrkZWJTgz2hGWTA44Yg3U1aZuD+MZpt4MF6eAqz+/CK0Nh6CO1glVy/3+nQ+qiObku/KhhTEYOR9MiP24GgaAHNw4ewZVbu0G62W7TEwQ4b8Re9T7J8qZf5z7lY9MUab2OV6ZBloXQQ3UAZwUa8iiOVV1LRQqpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098828; c=relaxed/simple;
	bh=YsHf7BSK5KRJctTL4JkuKUF1hbtpvEGj3tMvlEzZ/ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJKf/ENK5w8+1eb/nrTozGPqZqnhmsWO9PUMIHhc2v33KVgsiL9V2dR11jLBb2vhy1kYECe2vkJvgF5gP3qhFEeEKxDQUUqwYgaoMG6LtJIecFupb41dsgsXtHsLAt/O0cGe1WTCAo7rhk4aiAJFk1RpjuoU3R3RVLUNL/eF2Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIIor0IQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIIor0IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF07C2BCAF;
	Mon, 13 Apr 2026 16:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098828;
	bh=YsHf7BSK5KRJctTL4JkuKUF1hbtpvEGj3tMvlEzZ/ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIIor0IQNdZRZIt+stroaWZbn7BveqPkLicutWiddk993+iJM+Nx2T9ZkAB1xGfQX
	 eGSJ1t404aRP594alq2Gy2jYreAzOc/di3bMDb4FKxeNm7IYWSE9EtDBLqXJrKRFQj
	 14Gh3yz7a2QRU5vfQNJGJxV3jtxu1OiHH/TbYFL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 103/491] usb: mdc800: handle signal and read racing
Date: Mon, 13 Apr 2026 17:55:48 +0200
Message-ID: <20260413155822.899565616@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


