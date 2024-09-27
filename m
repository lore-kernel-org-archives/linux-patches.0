Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48333C3C;
	Fri, 27 Sep 2024 12:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440339; cv=none; b=HAw+Ovg1s2AGL7GrFu5fKUH8Wa4q6MPyd4SDQUHd05CgVBcI5WqljQF3mCi6aLkGzpeYeAUr8KlGctpgU+Tbd0QMMKXCvBEVQJqwkpBERsDRZjCdfG0GhGGPedzD9VeMDKMrZZuSS228KbRowgHFz12JsoqTf51X404RDDzOKks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440339; c=relaxed/simple;
	bh=rLD/HSO18IcWUIIbn095wMzf0bG0E8U5Eg5dX9I2aV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ua6HDaAsAU+2uqHbmSUKCtsjtLqD9bjJZt1eAB7i674WR6JixOLFbx/1n1ojB52KlTAQmM0Mv4La/SMhyaa+W5v5kbLNOMInC0XPIHYm/ix2YWl9pYGTAWEDZRUFlJKfkDoWKjvRYQiTm6BQ2CB9Qi6r1UdDQ+14YcpaIRFLT+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsQpIJVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsQpIJVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316A6C4CEC4;
	Fri, 27 Sep 2024 12:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440339;
	bh=rLD/HSO18IcWUIIbn095wMzf0bG0E8U5Eg5dX9I2aV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsQpIJVFniG2X+4oBRIVThUOcUfErRs1cniIew6Axf7Wkpnk1KyvbJ+qWveDJEv05
	 h5cNpccIkOuteSv2cmcxePsbdqDrDSc34jFAttA/TW+dIO2KF2kcKK4zZ2xMzd/89c
	 jwREPaAE46pq+csT9WZYC6d7VgkFPN3wcO39kyJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 47/73] xfs: remove WARN when dquot cache insertion fails
Date: Fri, 27 Sep 2024 14:23:58 +0200
Message-ID: <20240927121721.819701206@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 4b827b3f305d1fcf837265f1e12acc22ee84327c ]

It just creates unnecessary bot noise these days.

Reported-by: syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_dquot.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -798,7 +798,6 @@ xfs_qm_dqget_cache_insert(
 	error = radix_tree_insert(tree, id, dqp);
 	if (unlikely(error)) {
 		/* Duplicate found!  Caller must try again. */
-		WARN_ON(error != -EEXIST);
 		mutex_unlock(&qi->qi_tree_lock);
 		trace_xfs_dqget_dup(dqp);
 		return error;


