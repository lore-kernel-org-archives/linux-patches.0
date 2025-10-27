Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036FE32C331;
	Mon, 27 Oct 2025 18:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590913; cv=none; b=QSu5CqE67pO53WftY7G48dJfZbrYCuinR9w9X+mxmdJroBJ1ndIo1q54dOmoW2AFj2yPJJCZlBmCQxzvPDIuMdHo++hNsIhR8xSbom/c32SC9xNOnt3J55yl5p+c4pGKf3F1JkwLXMGv7xW0JLLX/ow/WjefTdcAF2f3N7bzCAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590913; c=relaxed/simple;
	bh=/HvLZnFLqyw6TXvzmvtaTkMsjnC34wMI5BjWwV+6ZFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0Tk7+qzaeD0Wy6HS/rcNGy0XzaRLsJlc/lGFMYDgQASgNm68wAfw5kYFvmLmteRlejbyR+mXbDqR98Ok/3RdVEA0Xqf38EVchOxZH+OFql+8q7lNKaX7AEispzcLO1O9+nbd37V2MbpNhuJs3/MV2kag0f8Z05MatKXqLLjqWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hx8ClISe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hx8ClISe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F51EC4CEFD;
	Mon, 27 Oct 2025 18:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590912;
	bh=/HvLZnFLqyw6TXvzmvtaTkMsjnC34wMI5BjWwV+6ZFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hx8ClISeQi0yk6ARX+BjNpybsm0vvYLkR0tiEM3H23V5K+Bj1Oxwpt48rILR0hJgc
	 jp2TXa2Ax0/I+Hl5JBLqh9VT4FUOs48nvhG/DwKU9lEvwef0HW9JG52QAeSjiKNJvh
	 4BJBzTTR+e/6XV1KSofw/ehpY8ZBZa61y+FLiKf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 220/224] padata: Reset next CPU when reorder sequence wraps around
Date: Mon, 27 Oct 2025 19:36:06 +0100
Message-ID: <20251027183514.619459561@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[ moved from padata_reorder() to padata_find_next() function ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/padata.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -204,7 +204,11 @@ static struct padata_priv *padata_find_n
 		list_del_init(&padata->list);
 		atomic_dec(&pd->reorder_objects);
 		++pd->processed;
-		pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
+		/* When sequence wraps around, reset to the first CPU. */
+		if (unlikely(pd->processed == 0))
+			pd->cpu = cpumask_first(pd->cpumask.pcpu);
+		else
+			pd->cpu = cpumask_next_wrap(cpu, pd->cpumask.pcpu, -1, false);
 	}
 
 	spin_unlock(&reorder->lock);


