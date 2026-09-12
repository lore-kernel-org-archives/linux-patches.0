Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9D7380FF3;
	Sat, 12 Sep 2026 07:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199377; cv=none; b=tskl7nwD0WjBXX8HYkx+CJ7iS8k8raFEH12zGETiq9sAo7Q6shDSTNPQftO+3wf40Ko+9p+BD05TArr0OM8waf7Hq1vjNwm6uY4Akkc1BOnJFJD0cJeP/+KTy8D3ul4/4gbsL0/pafPwzXT/AbEDCqwz+YLw5q6M7fC6cUdei48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199377; c=relaxed/simple;
	bh=aFERo7cGtyw+3GTvp9+w211P0AvOKmngCVE4Kx3pECE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoqNjwHs2ri44a7nKi1fd1RSHI/Knemz0THjYwqth+9gm/nKWTjJ4kug1TbHQDhT59XP+atuQUduL1NGkryZ5MJswADQHbscN52d1L6wV01TvYGjawSJSeXPEjJschUWqNyFZFykYPatDIA67fP1ZhJwXbMmTOortVIbre7+1E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STMYoDve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STMYoDve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2E11F000FF;
	Sat, 12 Sep 2026 07:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199375;
	bh=cMPSKsmnv9lvj36gV3YAE5OpdVoj7ojJ8zmKuulj49s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STMYoDveMwg2CMKfipJPKmIkW2CKpOAPRGTVzI2mtcBk+0tVFz/B6OZG/ly3ACTYC
	 han1l4kMroPvdhEtjNjWHHH+n2C6pReoom3ch6VPAUu2lZKvmdABrG1W4UNgDKZkVj
	 smACvgMnLwA2msaZx9uvpzjPF41n1c8gnZiYhUqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0572/1815] bpf: Fix offset warn check for bpf_res_spin_lock
Date: Sat, 12 Sep 2026 08:38:42 +0200
Message-ID: <20260912065702.311069259@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 04e19012efaec2bfd8c3b37fd8a6c3f1fe731ffc ]

Sashiko pointed out correctly that the case statement for
BPF_RES_SPIN_LOCK incorrectly checks offset for BPF_SPIN_LOCK.
Fix it by checking res_spin_lock_off instead.

Fixes: 0de2046137f9 ("bpf: Implement verifier support for rqspinlock")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://patch.msgid.link/20260719153634.2908692-2-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index e904f6086d2e1..fc1fb7659e1b1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4168,7 +4168,7 @@ struct btf_record *btf_parse_fields(const struct btf *btf, const struct btf_type
 			rec->spin_lock_off = rec->fields[i].offset;
 			break;
 		case BPF_RES_SPIN_LOCK:
-			WARN_ON_ONCE(rec->spin_lock_off >= 0);
+			WARN_ON_ONCE(rec->res_spin_lock_off >= 0);
 			/* Cache offset for faster lookup at runtime */
 			rec->res_spin_lock_off = rec->fields[i].offset;
 			break;
-- 
2.53.0



