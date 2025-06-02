Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D422236F0;
	Mon,  2 Jun 2025 14:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875044; cv=none; b=IRAStSQ8KxIdPQQZs7DE4eTmmA2uxZXxZVZwAzAwUpFC3kGBUFrPsBtwFCBxJxR2/BfAi1BCsdZkALkI32FxZWWmbc83hTwvIm/ud5BuW+qwIZkZaUXE7BReeW9fqhYgJK5iCa8TF715hd1yF7Yy/F2UdCxe8Ht3ksRrql09c3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875044; c=relaxed/simple;
	bh=YfEht2HhuGDYMrnp8lwO5KnMLHcVGJIpBc+c4tg5HQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cle6j5WlK5JXKR7UEqpbpKNUmroAgzyXsLZPbv+bibgv1jgCY4lxzeU+fLUd8LFLB822jb+ssrxi0XI5QbSCao1T1lxBTTOTO6TFVZ+/wDE1Umwn5sdi/bI6fPHwaQb4qQoQQ4W8yMUIYNfNkb1bqkPdFhPDnODHtkhCr1JZJQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBDEYN15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBDEYN15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26982C4CEEB;
	Mon,  2 Jun 2025 14:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875044;
	bh=YfEht2HhuGDYMrnp8lwO5KnMLHcVGJIpBc+c4tg5HQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBDEYN150SZOTV8qMVV0vv+ztzDI65pLr0X7dAQmWlVAeyUWPPjMfsqTnq8HmYBKj
	 N4YuJlwsZnT4HNCaKrpDYW0a4y55inAYm0Tt7XOQ/ETaTKt3KhG+GE00fuu69WHwUf
	 HgEHaIyM8T4dtBx4Wjy3yWIC+DW1mYpk04YyYifc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 011/270] dm: always update the array size in realloc_argv on success
Date: Mon,  2 Jun 2025 15:44:56 +0200
Message-ID: <20250602134307.659184592@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Benjamin Marzinski <bmarzins@redhat.com>

commit 5a2a6c428190f945c5cbf5791f72dbea83e97f66 upstream.

realloc_argv() was only updating the array size if it was called with
old_argv already allocated. The first time it was called to create an
argv array, it would allocate the array but return the array size as
zero. dm_split_args() would think that it couldn't store any arguments
in the array and would call realloc_argv() again, causing it to
reallocate the initial slots (this time using GPF_KERNEL) and finally
return a size. Aside from being wasteful, this could cause deadlocks on
targets that need to process messages without starting new IO. Instead,
realloc_argv should always update the allocated array size on success.

Fixes: a0651926553c ("dm table: don't copy from a NULL pointer in realloc_argv()")
Cc: stable@vger.kernel.org
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -513,9 +513,10 @@ static char **realloc_argv(unsigned *siz
 		gfp = GFP_NOIO;
 	}
 	argv = kmalloc_array(new_size, sizeof(*argv), gfp);
-	if (argv && old_argv) {
-		memcpy(argv, old_argv, *size * sizeof(*argv));
+	if (argv) {
 		*size = new_size;
+		if (old_argv)
+			memcpy(argv, old_argv, *size * sizeof(*argv));
 	}
 
 	kfree(old_argv);


