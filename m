Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24430126BFF;
	Thu,  3 Jul 2025 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554103; cv=none; b=JY+q6grfvf10cmNm57atray8aUgUJHa83S3DjXANAcL14fU0tycZQm/m4M+WxrEgnEfu622PlQYy0GqxnhEDV3BOPkxvCXEhoYNNlKqGv780aq88T+vai6/Mt5BPPxTUVMChQNJIU3TDLfSg0IDizw1ogtxXcMQzDYLpjVmxL4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554103; c=relaxed/simple;
	bh=0VSxlXCaAJqlAnTg7z44lAvqQmVGdWjsMHmio2vFeOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j133KDG1Mf6as1oUrbK/kDnyyUth4jR4XF8OswolKC6SJapVpnokp1+tMWUSe5EfyS4pOIJ4bQg2jwvbXXrwJc9aUw121e6/xrb5LHUMWm+naOUnZqB2FuJe2lzxQwRl1I38Io3V1dt6g+bnmISjJ3qP/UKts/NIs1zW34daf/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9JhnyIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9JhnyIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892E4C4CEE3;
	Thu,  3 Jul 2025 14:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554103;
	bh=0VSxlXCaAJqlAnTg7z44lAvqQmVGdWjsMHmio2vFeOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9JhnyIvPt9YKNQlu+27SPferjTdsQMq8TceYb/GoU809cK8pG4QVOw86sP/lziV+
	 QGKZ+DJivm4mITqoj7cTlVkxY25fzlQSd2n7QUZ5KHFWBWIMrciU7Tg1wvfk9aI9yW
	 j6dHpD2lBAVNkG147YRt3EkeLv+E3DupJz0pTHBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 081/218] mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write
Date: Thu,  3 Jul 2025 16:40:29 +0200
Message-ID: <20250703143959.182375827@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -423,6 +423,7 @@ static ssize_t memcg_path_store(struct k
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	kfree(filter->memcg_path);
 	filter->memcg_path = path;
 	return count;
 }


