Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A2E14EC4D;
	Tue,  9 Jul 2024 11:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523912; cv=none; b=Jc/UqlPVstUnWfGV5QJBdwFScE3LJuuEgSZMEKtwMjHtj0VN00woe5ZXtUvA52lylGUeRq3WlCD1wZnpCIIyIu77Cy4ReSxtZ8EIwYGaYeecBfaxm7cR9t2Y/xn+39BmWJP8LhSvGqVcgbkDZSy+/jj+E39M/E1xvgvF3Rb/7pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523912; c=relaxed/simple;
	bh=YsaLGY1SfL5Xk5gc/O8yRhvKEioymerrU6eoJqZ/CKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffzfYHhHdt/TlMmjTzI+plUCAHNSvhUNue17x8mW9wW2nClFDgTFF1XM9i1ukM2ysGH5kN4g6ABpBBcY90sJIBcbMLBOUxjgusWe/oodlbkx2h4mvmTTOJoi8KbpXoqUDFcwQcBf1qSK1gsgAtz2v0byMYkpJJ+qz+gBAW/pMK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K283UuJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K283UuJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E409CC3277B;
	Tue,  9 Jul 2024 11:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523912;
	bh=YsaLGY1SfL5Xk5gc/O8yRhvKEioymerrU6eoJqZ/CKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K283UuJZGy6PVq3fMdkG9WbnkumXWxBjFVrILXd9/ggrDXsX4RXZjA/Arn56G3xPa
	 QWFAZ+jZZHsp70BTwviyaxAyeNwDGQi+pMtEoz5lXCQx4z8I13ii80bJDFUdx87aPf
	 hcmMba/5EROr1TbBfELE6S742OinruK+hFOlu07I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 010/197] net: dql: Avoid calling BUG() when WARN() is enough
Date: Tue,  9 Jul 2024 13:07:44 +0200
Message-ID: <20240709110709.310913746@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4854b463c4b27c94a7de86d16ad84f235f4c1a72 ]

If the dql_queued() function receives an invalid argument, WARN about it
and continue, instead of crashing the kernel.

This was raised by checkpatch, when I am refactoring this code (see
following patch/commit)

	WARNING: Do not crash the kernel unless it is absolutely unavoidable--use WARN_ON_ONCE() plus recovery code (if feasible) instead of BUG() or variants

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20240411192241.2498631-2-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dynamic_queue_limits.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dynamic_queue_limits.h b/include/linux/dynamic_queue_limits.h
index 5693a4be0d9a9..ff9c65841ae8d 100644
--- a/include/linux/dynamic_queue_limits.h
+++ b/include/linux/dynamic_queue_limits.h
@@ -91,7 +91,8 @@ static inline void dql_queued(struct dql *dql, unsigned int count)
 {
 	unsigned long map, now, now_hi, i;
 
-	BUG_ON(count > DQL_MAX_OBJECT);
+	if (WARN_ON_ONCE(count > DQL_MAX_OBJECT))
+		return;
 
 	dql->last_obj_cnt = count;
 
-- 
2.43.0



