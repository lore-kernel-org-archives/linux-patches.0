Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBAD32ABDC;
	Mon, 27 Oct 2025 19:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593624; cv=none; b=jWeANi1EWHlIslqdQIxW4pi2J+zPI/cYC8jqyn2Ek2gCjlAsjC3NjvNj2AdAvMcQpAzP945jm6QNSBS70kXjfBB8XfuAVicrwt45YSSxBNoOcH/64Q4x/MvBD0+4ifSW5VB3LqgVvwBI//zjWHa2M/Rev+ej6tJEIodJwmexSkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593624; c=relaxed/simple;
	bh=dLYGA+t/HJIYRPZLrJVUxizRvu/D5GxICCp1Jrqmf5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txzmEDNbFaysk33Ihf5o30NU05TMGtZGYfPzRzfxv6JmM72GAoJHD58fjz3Sn8neFzPdQOpncp0PNrpAHJxCNCp0S1XWP+tIxR3eZo4lGjr163JUbFySD5/fzZV+9B3MzS135BJgOObb6a75q9tV9ktX314nz/9nlAOFPlLF7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1rIxJtVd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rIxJtVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD1FC4CEF1;
	Mon, 27 Oct 2025 19:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593624;
	bh=dLYGA+t/HJIYRPZLrJVUxizRvu/D5GxICCp1Jrqmf5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rIxJtVdEb0RsfVpcfUDjGllXQFuMUrrkLM0Q5cqhQXtznza0eWVmRS8vDGCxn1Ju
	 mQhPmOxy6E8boUxgJ/M+PjX75W+SosNqqTSZURRjQqMve4vRdQqJ7+KzFLW5JnjHG6
	 B5c9eep8+5xV2Zwe9XW1lW0ej9N/1Fe9RhsIZb4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: [PATCH 6.17 153/184] usb: raw-gadget: do not limit transfer length
Date: Mon, 27 Oct 2025 19:37:15 +0100
Message-ID: <20251027183519.050138058@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andreyknvl@gmail.com>

commit 37b9dd0d114a0e38c502695e30f55a74fb0c37d0 upstream.

Drop the check on the maximum transfer length in Raw Gadget for both
control and non-control transfers.

Limiting the transfer length causes a problem with emulating USB devices
whose full configuration descriptor exceeds PAGE_SIZE in length.

Overall, there does not appear to be any reason to enforce any kind of
transfer length limit on the Raw Gadget side for either control or
non-control transfers, so let's just drop the related check.

Cc: stable <stable@kernel.org>
Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://patch.msgid.link/a6024e8eab679043e9b8a5defdb41c4bda62f02b.1761085528.git.andreyknvl@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -667,8 +667,6 @@ static void *raw_alloc_io_data(struct us
 		return ERR_PTR(-EINVAL);
 	if (!usb_raw_io_flags_valid(io->flags))
 		return ERR_PTR(-EINVAL);
-	if (io->length > PAGE_SIZE)
-		return ERR_PTR(-EINVAL);
 	if (get_from_user)
 		data = memdup_user(ptr + sizeof(*io), io->length);
 	else {


