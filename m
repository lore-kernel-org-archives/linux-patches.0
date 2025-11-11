Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3D74C97;
	Tue, 11 Nov 2025 00:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822433; cv=none; b=Il7DwnD12rB66gyK55+38vGZFa1tema+eQhmo7Sxnt3GgLIYzspbySDsYsEWExY9WI3pUS0YQfr7+r6YRqcMFgqCet4GJcB1s+YnKIOQQlS16wxHSl2kZQfizHMiaGjMrse3CN6uHAOFVgTpcVdDZOjPk2L/JjYdR1DqB5Xxpgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822433; c=relaxed/simple;
	bh=nNVIjYDWwSDJG7bZNlCGvQOILZgpdWTkEKde+57AVjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z72cV8u0WSEql/7aaAYWYciqLZVHUC0fO9/qL8xS44dfTAcWERxsnOiP6Sf34ctk+gNdfKqFKQhXxSduuYKrqMa2m+sO5zxX1ncCQCY38tPLjzQPgTWphQ7iKFuM9rji3sze0/7nW02Sgd/evXfCZ3NUsFY+E40kx88ky7/GyeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r77kiOxO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r77kiOxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6D0C4CEFB;
	Tue, 11 Nov 2025 00:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822433;
	bh=nNVIjYDWwSDJG7bZNlCGvQOILZgpdWTkEKde+57AVjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r77kiOxO8vck+Nb1OdKYmhcrysxUZUx45eaWO2DCbXyJmq4R42A84secAvD9NA5oc
	 Kh96yf4cfGuqNRe5X0LnE9Q5jk4gRxxXLS+g7dl0TQBB+zMdB2enfPOUmsKzD39rSD
	 yi5OXydjViGEjuKr3Gz7jM0/PbGG03g0kPNCFI+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/565] tools: ynl: fix string attribute length to include null terminator
Date: Tue, 11 Nov 2025 09:38:25 +0900
Message-ID: <20251111004528.011682907@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Petr Oros <poros@redhat.com>

[ Upstream commit 65f9c4c5888913c2cf5d2fc9454c83f9930d537d ]

The ynl_attr_put_str() function was not including the null terminator
in the attribute length calculation. This caused kernel to reject
CTRL_CMD_GETFAMILY requests with EINVAL:
"Attribute failed policy validation".

For a 4-character family name like "dpll":
- Sent: nla_len=8 (4 byte header + 4 byte string without null)
- Expected: nla_len=9 (4 byte header + 5 byte string with null)

The bug was introduced in commit 15d2540e0d62 ("tools: ynl: check for
overflow of constructed messages") when refactoring from stpcpy() to
strlen(). The original code correctly included the null terminator:

  end = stpcpy(ynl_attr_data(attr), str);
  attr->nla_len = NLA_HDRLEN + NLA_ALIGN(end -
                                (char *)ynl_attr_data(attr));

Since stpcpy() returns a pointer past the null terminator, the length
included it. The refactored version using strlen() omitted the +1.

The fix also removes NLA_ALIGN() from nla_len calculation, since
nla_len should contain actual attribute length, not aligned length.
Alignment is only for calculating next attribute position. This makes
the code consistent with ynl_attr_put().

CTRL_ATTR_FAMILY_NAME uses NLA_NUL_STRING policy which requires
null terminator. Kernel validates with memchr() and rejects if not
found.

Fixes: 15d2540e0d62 ("tools: ynl: check for overflow of constructed messages")
Signed-off-by: Petr Oros <poros@redhat.com>
Tested-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Link: https://lore.kernel.org/20251018151737.365485-3-zahari.doychev@linux.com
Link: https://patch.msgid.link/20251024132438.351290-1-poros@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/lib/ynl-priv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/lib/ynl-priv.h b/tools/net/ynl/lib/ynl-priv.h
index 3c09a7bbfba59..baafc66a61855 100644
--- a/tools/net/ynl/lib/ynl-priv.h
+++ b/tools/net/ynl/lib/ynl-priv.h
@@ -301,7 +301,7 @@ ynl_attr_put_str(struct nlmsghdr *nlh, unsigned int attr_type, const char *str)
 	struct nlattr *attr;
 	size_t len;
 
-	len = strlen(str);
+	len = strlen(str) + 1;
 	if (__ynl_attr_put_overflow(nlh, len))
 		return;
 
@@ -309,7 +309,7 @@ ynl_attr_put_str(struct nlmsghdr *nlh, unsigned int attr_type, const char *str)
 	attr->nla_type = attr_type;
 
 	strcpy((char *)ynl_attr_data(attr), str);
-	attr->nla_len = NLA_HDRLEN + NLA_ALIGN(len);
+	attr->nla_len = NLA_HDRLEN + len;
 
 	nlh->nlmsg_len += NLMSG_ALIGN(attr->nla_len);
 }
-- 
2.51.0



