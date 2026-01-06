Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C40366DA5;
	Tue,  6 Jan 2026 18:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722465; cv=none; b=QYNdDNq1jnohk8jA+/AVSuAJLTWKNsE6VwEDmyXjPoT62DzxaCobEWv95gT89jOyoQAyjjKwwNY/IAqhscwy/z9qAqndhedgW1nx1Y6aTanxYurImE05buEBjNK9s36rdmouKuTqCxCijN/joiTm/xuidBgMN6ShWEkMnk8pAfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722465; c=relaxed/simple;
	bh=jKeszfPuwpU6XzhYXckzDXCyeYl0EaFDg4xYSdAYhnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orc3fQYEOcFjWrlKv7mL1O92K/tblnc47NyHABlRneX9AiIpZoNiggTb/4Hig6sJ1HrqU0bsSx1Q2fM3qvjZTQEudbP5ltUTqiWop2zukEo6ScDTJWOq/mrZOw8Oh8X1vaWKVd0NB9JJgxWtPyhWDX5BZXLJRvP0UhM8p074TZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=La4pMcb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="La4pMcb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F77C116C6;
	Tue,  6 Jan 2026 18:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722464;
	bh=jKeszfPuwpU6XzhYXckzDXCyeYl0EaFDg4xYSdAYhnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=La4pMcb8cJbsPCAjhomTzaoZpF9jpACC2upW8hWkr5422e9g4ENI50mzKHXGWYqxz
	 Cf3VJ6hBH+UVBlsVunZye91UdhCcSmjyuz8otfwGaMFEsMB8KOPQ7qhyMMfUkwSB7+
	 PSPGhMB0f1VTZbFqTQ3ASjMkM2Fh/svY3lyNF4Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Marco Elver <elver@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 230/312] mm/page_owner: fix memory leak in page_owner_stack_fops->release()
Date: Tue,  6 Jan 2026 18:05:04 +0100
Message-ID: <20260106170556.173097317@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

commit a76a5ae2c6c645005672c2caf2d49361c6f2500f upstream.

The page_owner_stack_fops->open() callback invokes seq_open_private(),
therefore its corresponding ->release() callback must call
seq_release_private().  Otherwise it will cause a memory leak of struct
stack_print_ctx.

Link: https://lkml.kernel.org/r/20251219074232.136482-1-ranxiaokai627@163.com
Fixes: 765973a09803 ("mm,page_owner: display all stacks and their count")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Marco Elver <elver@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -936,7 +936,7 @@ static const struct file_operations page
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_private,
 };
 
 static int page_owner_threshold_get(void *data, u64 *val)


