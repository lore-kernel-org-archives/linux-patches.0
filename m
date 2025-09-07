Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB5D4315A;
	Sun,  7 Sep 2025 20:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277646; cv=none; b=jeGDMX1zS+Nh3bPUY9Za06WTBarKTDtF57yCENj3yRSdP1Gfpzb9E3IB2LF9qnvI5VURa5q9kG0EqtsTJ4Hc1amWNwvQ7i+fFtjrQkp/IIWhWSHN9PKmZcePbCaS+4cWGopJZgAxbtfXwwf8i9TgfmZdjGOTPJPQol7cU9v6yzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277646; c=relaxed/simple;
	bh=cN76D8Blb+6+MZHGn8z80NWyf2qq767np+8n57Retqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJPUOMK90FsBrxwvi2y2z+ALpQZmlubbgKMCEs27zJobzeM1WiLAy/7yX0MbAVU9O4kjbxLLGRbFaBtJuj9aApLwI1t/JDA1Bc6F/Zeb8OSU8PQxGKyo2TcbHkEvOm7BugP3oUb5dweagAgQ2hXv3jVO5+l4vDzVddpSjGFP05U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCZKwSgE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCZKwSgE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778A3C4CEF0;
	Sun,  7 Sep 2025 20:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277646;
	bh=cN76D8Blb+6+MZHGn8z80NWyf2qq767np+8n57Retqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCZKwSgEGNt5UWYm9eIyjh8v28OUeR8v8XkbV6B+8vnFNInPjhXNqNmbTR0vxmnAK
	 ZWRD8f+WRcjT3tG5q6smZX/T43OnjoV3KDY7+sUxFgGevPjZaGAUWzx1p+cJtuLEOI
	 8fMN7LArQ4b+viWDr8WV+E3hndT/lF8VSmZ7YXME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 080/183] tools: ynl-gen: fix nested array counting
Date: Sun,  7 Sep 2025 21:58:27 +0200
Message-ID: <20250907195617.697597240@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit b4ada0618eed0fbd1b1630f73deb048c592b06a1 ]

The blamed commit introduced the concept of split attribute
counting, and later allocating an array to hold them, however
TypeArrayNest wasn't updated to use the new counting variable.

Abbreviated example from tools/net/ynl/generated/nl80211-user.c:
nl80211_if_combination_attributes_parse(...):
  unsigned int n_limits = 0;
  [...]
  ynl_attr_for_each(attr, nlh, yarg->ys->family->hdr_len)
	if (type == NL80211_IFACE_COMB_LIMITS)
		ynl_attr_for_each_nested(attr2, attr)
			dst->_count.limits++;
  if (n_limits) {
	dst->_count.limits = n_limits;
	/* allocate and parse attributes */
  }

In the above example n_limits is guaranteed to always be 0,
hence the conditional is unsatisfiable and is optimized out.

This patch changes the attribute counting to use n_limits++ in the
attribute counting loop in the above example.

Fixes: 58da455b31ba ("tools: ynl-gen: improve unwind on parsing errors")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Link: https://patch.msgid.link/20250902160001.760953-1-ast@fiberby.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/pyynl/ynl_gen_c.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/net/ynl/pyynl/ynl_gen_c.py b/tools/net/ynl/pyynl/ynl_gen_c.py
index 76032e01c2e75..0725a52b6ad7b 100755
--- a/tools/net/ynl/pyynl/ynl_gen_c.py
+++ b/tools/net/ynl/pyynl/ynl_gen_c.py
@@ -830,7 +830,7 @@ class TypeArrayNest(Type):
                      'ynl_attr_for_each_nested(attr2, attr) {',
                      '\tif (ynl_attr_validate(yarg, attr2))',
                      '\t\treturn YNL_PARSE_CB_ERROR;',
-                     f'\t{var}->_count.{self.c_name}++;',
+                     f'\tn_{self.c_name}++;',
                      '}']
         return get_lines, None, local_vars
 
-- 
2.50.1



