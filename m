Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E6422B8AB;
	Thu,  3 Jul 2025 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555730; cv=none; b=B+0GlnuQZHcYq9xbIvwLivP4mKNM2jZ63q7z5ZBf33YLa9/4qnWLrwLi7Sg9Q6jQnOgDCTC6F/nPFLTe66Immh5QL2H6rqqhaymoxcDuVdMiK32d/nDmp9FobbclGGPagRoyejMhMxQRs3Y/xZmPxOBszOw2JFUPXOReMs+Rokc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555730; c=relaxed/simple;
	bh=Z200mtckfcIF36U6e8NviYi9YuN3f398ZmA2HdkP05I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YY9yzRln/6W52uC8rvfbQgCg8l9/MxK99UmiueYRekmmCiVZk5hFmUWM8Mc2aNI6RrpYs2gzIwrP5TFqRkxcila+7NbbRPVM734bJT72VxAK8/0j9fXSqiTZH3X1eK7g41GNb/giUoJ0aW2Tb3eoeqeJiTxpAwTR1U91keB7im8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTpW/uZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTpW/uZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1152C4CEE3;
	Thu,  3 Jul 2025 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555730;
	bh=Z200mtckfcIF36U6e8NviYi9YuN3f398ZmA2HdkP05I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTpW/uZzW5/dZ1COaPHGdjmzHCfXSQBz2OW1mCFmYR+Ow2zB8DIxK0h7utTIas7N4
	 y5YTOlG06aPK6KJCR9q5ZPJ1SOokvAV6tqACc/R3npsHwhAmk7q6RhxZA23e1HfCQv
	 Xk9GxY4M74+nrkQF3Mps0AyIACdDLNYKkp3VZF54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 073/139] mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write
Date: Thu,  3 Jul 2025 16:42:16 +0200
Message-ID: <20250703143944.027583857@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 4f489fe6afb395dbc79840efa3c05440b760d883 upstream.

memcg_path_store() assigns a newly allocated memory buffer to
filter->memcg_path, without deallocating the previously allocated and
assigned memory buffer.  As a result, users can leak kernel memory by
continuously writing a data to memcg_path DAMOS sysfs file.  Fix the leak
by deallocating the previously set memory buffer.

Link: https://lkml.kernel.org/r/20250619183608.6647-2-sj@kernel.org
Fixes: 7ee161f18b5d ("mm/damon/sysfs-schemes: implement filter directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>		[6.3.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -376,6 +376,7 @@ static ssize_t memcg_path_store(struct k
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	kfree(filter->memcg_path);
 	filter->memcg_path = path;
 	return count;
 }


