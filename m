Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8611E1A16;
	Wed, 19 Feb 2025 09:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957112; cv=none; b=aH2RYjJ5aGbpJ5GDOw1DvfBJzpNrN9CBUQJaDOFo7XvYDCWluITHEs6HN93WOOBs9hm+909hkjOUIno1IA6tYvsYltQc6AvxzeCpBQqdzC9HbuTDe0Wlu3iP0K6Lf4ajDP0n00TK+njr5NTDHMYSRrnVoJ5Cyu+vkb5VFB2xbCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957112; c=relaxed/simple;
	bh=PZ5o6HyWm0aYxRllVinhemGsRjRXMaZVAORj8hv8+dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJdtvDFl1eaRVMOcitwSSr1WvsrwBYWVopNmi80XAj/b6AOtB1T1GZMcplodPmwpG5ZyYCOwBIdO2gS9z/+GRhPRhrFlbEMQpctlYPJ9jABkL0mWrqOHC4ASXWBzdjBuZw1e+gLcGvJ/WwkYqCtM3zWT5Mam+Tna1joZdKnx9zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojaop3pp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojaop3pp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1FBC4CED1;
	Wed, 19 Feb 2025 09:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957112;
	bh=PZ5o6HyWm0aYxRllVinhemGsRjRXMaZVAORj8hv8+dY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojaop3ppZNA6S57aFraC0tWEMObV9d/p/4dxskwU9BINqgu/ThTVMbW+Uf8yFz8eJ
	 dJdUtZqHJNi/WScRlmJffP7v2iWe71d/TLXcy5C1LDhjWjowGiwwDqtk/dIqD02MyK
	 ZvxElAOtk+ZZ+4Ule1b/cJaMK+lwCtyCuecAZ0A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 385/578] block: dont revert iter for -EIOCBQUEUED
Date: Wed, 19 Feb 2025 09:26:29 +0100
Message-ID: <20250219082708.170281186@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit b13ee668e8280ca5b07f8ce2846b9957a8a10853 upstream.

blkdev_read_iter() has a few odd checks, like gating the position and
count adjustment on whether or not the result is bigger-than-or-equal to
zero (where bigger than makes more sense), and not checking the return
value of blkdev_direct_IO() before doing an iov_iter_revert(). The
latter can lead to attempting to revert with a negative value, which
when passed to iov_iter_revert() as an unsigned value will lead to
throwing a WARN_ON() because unroll is bigger than MAX_RW_COUNT.

Be sane and don't revert for -EIOCBQUEUED, like what is done in other
spots.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/fops.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/block/fops.c
+++ b/block/fops.c
@@ -601,11 +601,12 @@ static ssize_t blkdev_read_iter(struct k
 		file_accessed(iocb->ki_filp);
 
 		ret = blkdev_direct_IO(iocb, to);
-		if (ret >= 0) {
+		if (ret > 0) {
 			iocb->ki_pos += ret;
 			count -= ret;
 		}
-		iov_iter_revert(to, count - iov_iter_count(to));
+		if (ret != -EIOCBQUEUED)
+			iov_iter_revert(to, count - iov_iter_count(to));
 		if (ret < 0 || !count)
 			goto reexpand;
 	}


