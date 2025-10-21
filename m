Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C384B134AC;
	Tue, 21 Oct 2025 20:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077015; cv=none; b=tXrfNHBYmjHf/dy8KcY8e0Tvu5msjJG1rJvbmLfVb4WjWaivV6qo7V54e0Hg1/j65i0AHe7lsSxY+02Ad3+SM5PlsSqIcvUXp2d7+jn13x1E2QTj7WcyfbrPDbWcSg0Ap4nbWctnmIQZ7RQjg4X2vvq38YzDF6kSNK3acEJPk/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077015; c=relaxed/simple;
	bh=pTVfSLxQyJj6MKM0ZKEX2Bj9kopSSx92QHZzVTb3vHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOnkwa6yt3+LNJPtfpA9e+4LyWvwIQBSKhlfxi6OOTtb/PazAc++aiaTREYY97fwVAHPb6Th1uXDzWhnvwwMU0k6hLwrvWM2HTDBEiex5wEWyTpeGyLhv86VPA4tGl8ZcgGNJv/MmZVELhkxmiIffPZ5/rtfV76RCCvefvZaElo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLlY2we/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLlY2we/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F434C4CEF1;
	Tue, 21 Oct 2025 20:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077015;
	bh=pTVfSLxQyJj6MKM0ZKEX2Bj9kopSSx92QHZzVTb3vHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLlY2we/JbW0XuF5GH1lLrfFk2JkxmGOaTPn2sNx9AoA66f6Wd4re7mAUwo94cwKk
	 QuqOTxAAaZBjuRi6zY7utmx22Rou+fTaSS6mD5I4sXOetK5LZkfz7OGQhL5c4scv4n
	 WzQF9gHvW5xrak1bAZABEymoKqXriB2geaMSuMq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/136] padata: Reset next CPU when reorder sequence wraps around
Date: Tue, 21 Oct 2025 21:51:38 +0200
Message-ID: <20251021195038.610513580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit 501302d5cee0d8e8ec2c4a5919c37e0df9abc99b ]

When seq_nr wraps around, the next reorder job with seq 0 is hashed to
the first CPU in padata_do_serial(). Correspondingly, need reset pd->cpu
to the first one when pd->processed wraps around. Otherwise, if the
number of used CPUs is not a power of 2, padata_find_next() will be
checking a wrong list, hence deadlock.

Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
Cc: <stable@vger.kernel.org>
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ relocated fix to padata_find_next() using pd->processed and pd->cpu structure fields ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -290,7 +290,11 @@ static struct padata_priv *padata_find_n
 	if (remove_object) {
 		list_del_init(&padata->list);
 		++pd->processed;
-		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
+		/* When sequence wraps around, reset to the first CPU. */
+		if (unlikely(pd->processed == 0))
+			pd->cpu = cpumask_first(pd->cpumask.pcpu);
+		else
+			pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
 	}
 
 	spin_unlock(&reorder->lock);


