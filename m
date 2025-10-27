Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1D122A4DB;
	Mon, 27 Oct 2025 19:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593490; cv=none; b=juMXesHIgnUb56JleHjcw4d5VNYW9SoqzH762c83QUyt+WXUOaso/nWQWgMOjbCfPjtgvxzPMLQ4k3onLviDgfomI53PSTkMbUDGu4gAZ+yU5MJu1ZZsQfJ6XV2OB0azehlmrFEfa5oF8I6fhekHFEr+fPQsQDlWqX57QqiWogg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593490; c=relaxed/simple;
	bh=/iSkV3TvS8bjZJgJ0q+KXfOD1RP3NiwAwaK7ChUyWuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIxuLReXvNeBl8QuOipw+CNxhPPhCzoIhmpkbdxZO+64wBEAUJDFkELPbI9Q0Tg3ELGHDUv5nsRLvhWzNTRiDNIBfrtV8uLiXKjqqGSFP6HelCfaEYZQBrQzfPgDVxR+tDToLwr/TV60h04zpdVTnlMsMQjohsU2eRIRpNPEA5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgz1zYuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgz1zYuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F68C4CEF1;
	Mon, 27 Oct 2025 19:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593490;
	bh=/iSkV3TvS8bjZJgJ0q+KXfOD1RP3NiwAwaK7ChUyWuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vgz1zYuD26LDBlcdJBMDevfyhtGLsoRHzoO/3cteoaivSMALJwzY0fyslDFQUfSJl
	 LV6cFFyVmgkxjb/OUnJ/1Wdz6uvGQjvl1cusPGtJLHUjKKxs649MH488iD9ugdOJGj
	 KjcGh7CRX79r9IUais32XnF/z53znBSDDE9ryhPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 113/184] mm/damon/sysfs: dealloc commit test ctx always
Date: Mon, 27 Oct 2025 19:36:35 +0100
Message-ID: <20251027183517.975133914@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 139e7a572af0b45f558b5e502121a768dc328ba8 upstream.

The damon_ctx for testing online DAMON parameters commit inputs is
deallocated only when the test fails.  This means memory is leaked for
every successful online DAMON parameters commit.  Fix the leak by always
deallocating it.

Link: https://lkml.kernel.org/r/20251003201455.41448-3-sj@kernel.org
Fixes: 4c9ea539ad59 ("mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.15+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1438,12 +1438,11 @@ static int damon_sysfs_commit_input(void
 	if (!test_ctx)
 		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
-	if (err) {
-		damon_destroy_ctx(test_ctx);
+	if (err)
 		goto out;
-	}
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
 out:
+	damon_destroy_ctx(test_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
 }


