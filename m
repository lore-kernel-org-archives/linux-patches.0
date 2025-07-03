Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782722EF9C3;
	Thu,  3 Jul 2025 15:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554892; cv=none; b=A/fj8y0GX7quUi2EqlgRaEMxGv7IgNX6nPNLFmPYhMAe+/oYTuo+yDL7DS/k/DNfUNtTXulAiIifT8O/jrjFm95Y4vyNNz3l5wtvFlVWajFeXhLfWpVG8Pt3y1X9a47HI1NycVJaPSReIcFDw6oXEt2+wTmvz2/yJsyzVG4wJZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554892; c=relaxed/simple;
	bh=2bRsIEZSBCYiLPJZv1ZVojiSec5M+GR+g84Vd+pcpQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmmmALK/fvo0CTNRT9d75xfda0YvpvLRttfnVRr1cjiwUqEvQBgWfFrphQLJsqfS5PcoyiYrdUO9tQM1CoisX6LXyH7y/N96TyN6izBkiRfyjrYvfV+2LxmjuhwYcFuhkHXtZ1T3TMKczP0+sfFVVopab7kJsKGT3qdceDDfWhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBKsiDQ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBKsiDQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6D3C4CEED;
	Thu,  3 Jul 2025 15:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554892;
	bh=2bRsIEZSBCYiLPJZv1ZVojiSec5M+GR+g84Vd+pcpQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBKsiDQ4h5fgY/wULDLhR3RQ+dJju8GSSFkyFx9xRWLMFlgsUVY+oPRZ7GnGg6SzT
	 uw1KK/wyUEe6yxDAyvl2PtSzbYZ0qJo6YV43iZNUZST37JHmNRVAPCuxPCfvfxIc+i
	 vdclNVuG6IhXht6ADeRuI1bzClXOlH9NqtGXFW1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 111/263] mm/damon/sysfs-schemes: free old damon_sysfs_scheme_filter->memcg_path on write
Date: Thu,  3 Jul 2025 16:40:31 +0200
Message-ID: <20250703144008.792675096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -471,6 +471,7 @@ static ssize_t memcg_path_store(struct k
 		return -ENOMEM;
 
 	strscpy(path, buf, count + 1);
+	kfree(filter->memcg_path);
 	filter->memcg_path = path;
 	return count;
 }


