Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A5F2AE8D;
	Tue, 11 Nov 2025 00:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822281; cv=none; b=FHBIOcrJpxr4SE7Vtjf8OseajlH4DAhY92FHVMOtPf00LsmUlz6hFv4GsmmF+L/sX/fuALur0XV6g2JhctxQrPgYQGw7T0hUN5DS/HC6ONV2K8vlyt5bhanCf2Fy+s7KBG80jOmn4ieiiDiegpnEKunDtOwzGZxE7LYrWclklUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822281; c=relaxed/simple;
	bh=i2Nx3nqJDnBrgRUCsNFk6F6e08Pavyxwiql55jpyk0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgO7u4VEzmftT99zqEyRL+NsmrQ1UyDmjs/qKFaLMaeRiwCUzrjVJfxdlMhKf6+Q6A3hBpzYof3A4LjFEMMnp1DsJnnru5cNLTuMEdWGiefYZ1HNx9u9VtZZ/E0+L8/wC0k7lOJm04BwyP1ziZNmrSVWTFDWHFVbvx5R71ibefk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RaqAAkpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RaqAAkpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE1EC19421;
	Tue, 11 Nov 2025 00:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822280;
	bh=i2Nx3nqJDnBrgRUCsNFk6F6e08Pavyxwiql55jpyk0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RaqAAkpRCjFUcoVHET1y4dIa2pxIDv51drU9+/XsJ2RnO9WwVUnJ6pbLSzvMtdjXT
	 z0TPKSWGX1tTNODRGi2ex1LDOb8UIQf85kdaelGa1LXBMrjaLDX+dKP6PKYhXhDI30
	 9l4fMgFW4B2P3wuzpt79MMxwXd5eoEIVIZS8XZY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 072/849] tools: ynl: fix string attribute length to include null terminator
Date: Tue, 11 Nov 2025 09:34:02 +0900
Message-ID: <20251111004538.165431249@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 824777d7e05ea..fca519d7ec9a7 100644
--- a/tools/net/ynl/lib/ynl-priv.h
+++ b/tools/net/ynl/lib/ynl-priv.h
@@ -314,7 +314,7 @@ ynl_attr_put_str(struct nlmsghdr *nlh, unsigned int attr_type, const char *str)
 	struct nlattr *attr;
 	size_t len;
 
-	len = strlen(str);
+	len = strlen(str) + 1;
 	if (__ynl_attr_put_overflow(nlh, len))
 		return;
 
@@ -322,7 +322,7 @@ ynl_attr_put_str(struct nlmsghdr *nlh, unsigned int attr_type, const char *str)
 	attr->nla_type = attr_type;
 
 	strcpy((char *)ynl_attr_data(attr), str);
-	attr->nla_len = NLA_HDRLEN + NLA_ALIGN(len);
+	attr->nla_len = NLA_HDRLEN + len;
 
 	nlh->nlmsg_len += NLMSG_ALIGN(attr->nla_len);
 }
-- 
2.51.0



