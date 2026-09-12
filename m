Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211C1246BCD;
	Sat, 12 Sep 2026 10:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207922; cv=none; b=rUbfti81g5dtd0AO+OHn5MshpJVjvdqbkZIPodL3j9ghJvHzar0QvfEymdbu52bgR0kLy/hyFrQChwO3yAkdYfZ2/dkeAncpwGuxmA8at6PEFlAtbJEys+wEFYl3bJMGKlVEFQxIsJMzB8eofv8ff35CaMfSu1D19UPVprmMIDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207922; c=relaxed/simple;
	bh=glq2o6o+vupWtjoGw2/NidQgwZIbUnoN/hdogEWfJUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnRRodamJjsSs8pDXhhUx51FUkKiqE4+GsK0h35UgTP8m6R3wO3fn5+tGa0rqvu7wtAFPv2GQ2HA/UsiSsrEa4w4hLfKqvDLD9tIsh4nuUdJRaAY+ZT7aR4r8MX89LCD02XnldIBCtycXXF7EnhTRJh8LdK0mOkOPbogF+IaIPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQpOsTM6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQpOsTM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A8A1F000FF;
	Sat, 12 Sep 2026 10:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207921;
	bh=1Zl6aYLQiQNxx+96WEHYKdgyxCloYfvBUUDlPvO7pQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQpOsTM67K/8BEXjszcyv9XLuH1cBq2sr3JNSHVL5JINPzEr+w9OZT9qqfbRcxYsr
	 npL59vRI8WwY/xGPO2ReTUIaMlBfrzT4ouJAR4Yf61PaImPamBH4f5MEfcsm0ig33y
	 mjYRLDZPDvZG7PUGZZYj7nd0HMLnvDL7Nfztmf6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0505/1518] bpf: Fix offset warn check for bpf_res_spin_lock
Date: Sat, 12 Sep 2026 08:44:34 +0200
Message-ID: <20260912065634.869420251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 7a4618c054075..e576b3eda5ea7 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4003,7 +4003,7 @@ struct btf_record *btf_parse_fields(const struct btf *btf, const struct btf_type
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



