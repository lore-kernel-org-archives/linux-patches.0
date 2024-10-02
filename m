Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E855429CE7;
	Wed,  2 Oct 2024 13:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877139; cv=none; b=rFhmmrMCeTo0X6Z6WT6ScTC/SFnYjPTFq9wj5nlILrYciUjud6OU0VSaD1wFhz+31DW4gwCxAeSO0jL4utyjPX6TGDKRKMEKlTvC1/46r41aGb529O6wtYl5iIeRGYk2fTZ2HxXAJD23m8VGjd3K7QKrBzNzT1+2MdxYl2YgB+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877139; c=relaxed/simple;
	bh=zcPcPilnXLMxMSAhfErT8EVwGuyjGjxFj2NFG5aLdRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMiAlNifxMU03A+mKVPY7fQIZI3rbrVwpWPwF/uld20SzguuNBV+SXoiAFWwskHRnL7h790vG19imsDxaMTJypZvEY1H5EgP868EYteVogH3ROQ+G/mBvNEESkBiR+OLP8BV6fOKPfDH+XYOYG3hnQRYLFOGSBI3TvZjhNIblAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Qia9HYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Qia9HYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71559C4CEC2;
	Wed,  2 Oct 2024 13:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877138;
	bh=zcPcPilnXLMxMSAhfErT8EVwGuyjGjxFj2NFG5aLdRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Qia9HYJDw3nvJBIMsfLBWhDgb6cg3bD4j46cMzUEXw6S+mgnOPdBDbAXZxwY8k5Q
	 hSxtleZVT+YU2/CSvMGWHZhupRzIykAOF1hQXY706Q8rp6E80Ze3b8L11kL/0eJE+I
	 G3hhH6vStI2qmPVWu+k22RzI06rKKEOmHcot1WKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e1c69cadec0f1a078e3d@syzkaller.appspotmail.com,
	Daniel Yang <danielyangkang@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.11 678/695] exfat: resolve memory leak from exfat_create_upcase_table()
Date: Wed,  2 Oct 2024 15:01:16 +0200
Message-ID: <20241002125849.580106533@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Yang <danielyangkang@gmail.com>

commit c290fe508eee36df1640c3cb35dc8f89e073c8a8 upstream.

If exfat_load_upcase_table reaches end and returns -EINVAL,
allocated memory doesn't get freed and while
exfat_load_default_upcase_table allocates more memory, leading to a
memory leak.

Here's link to syzkaller crash report illustrating this issue:
https://syzkaller.appspot.com/text?tag=CrashReport&x=1406c201980000

Reported-by: syzbot+e1c69cadec0f1a078e3d@syzkaller.appspotmail.com
Fixes: a13d1a4de3b0 ("exfat: move freeing sbi, upcase table and dropping nls into rcu-delayed helper")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Yang <danielyangkang@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/nls.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/exfat/nls.c
+++ b/fs/exfat/nls.c
@@ -779,8 +779,11 @@ int exfat_create_upcase_table(struct sup
 				le32_to_cpu(ep->dentry.upcase.checksum));
 
 			brelse(bh);
-			if (ret && ret != -EIO)
+			if (ret && ret != -EIO) {
+				/* free memory from exfat_load_upcase_table call */
+				exfat_free_upcase_table(sbi);
 				goto load_default;
+			}
 
 			/* load successfully */
 			return ret;


