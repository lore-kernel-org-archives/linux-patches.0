Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F2E1FB3;
	Tue, 27 May 2025 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367978; cv=none; b=i/B+QUo4Bn2OnlCYY131vD+PZ89fi2CMHhZAT7uV8Xklvv9+ur/V1BoenQBasQXB3uV+hUfZdULFzvmV6+nt7KB7JQwR1cr7agG9hKMvxuorOjoXzAtTGX+o8aAeq+n5FpCfViRzKLej/BDZwEPdMOjnmciIbkroqviRrTTSw4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367978; c=relaxed/simple;
	bh=xQMgtNBLk9t9iQ9D+sLCBSUzYlTgsPa8uuC40nc3OXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+9Tlk3ULuZK64a8Uy44DR9QkfzyBUco6+Pn5etSMCzVkbAPqwFO1crWOAF348H5ArJHa6Z3qmfvFjN/u3/8rTEk5HNUZrpcKGhxpjSHBZ16/vhdjf9Bwd6bmBvXdbEidilmHTSWYVR2eUnh1LkPZ14Hm4OhioLwAiR9hyz6Isw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJkL43Ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJkL43Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9117AC4CEE9;
	Tue, 27 May 2025 17:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367978;
	bh=xQMgtNBLk9t9iQ9D+sLCBSUzYlTgsPa8uuC40nc3OXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJkL43Ubkgr3o/jnL870rYGiiHp/3laGOOkGVGIIWUbuXIIVoRuFi32iGYRBdiQGy
	 HSZinxN0u/J8B0KFiYhwE7Fq4nM1aC//I/MtRVNsv22dXx4t6OgTU7nKXP8hqW2Qco
	 gfZ0frR2YJqR9uWCVl3r+fuMLxzvsu6IygZf0RUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 560/783] tools: ynl-gen: dont output external constants
Date: Tue, 27 May 2025 18:25:57 +0200
Message-ID: <20250527162535.952262026@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7e8b24e24ac46038e48c9a042e7d9b31855cbca5 ]

A definition with a "header" property is an "external" definition
for C code, as in it is defined already in another C header file.
Other languages will need the exact value but C codegen should
not recreate it. So don't output those definitions in the uAPI
header.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20250203215510.1288728-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/pyynl/ynl_gen_c.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/net/ynl/pyynl/ynl_gen_c.py b/tools/net/ynl/pyynl/ynl_gen_c.py
index c2eabc90dce8c..aa08b8b1463d0 100755
--- a/tools/net/ynl/pyynl/ynl_gen_c.py
+++ b/tools/net/ynl/pyynl/ynl_gen_c.py
@@ -2549,6 +2549,9 @@ def render_uapi(family, cw):
 
     defines = []
     for const in family['definitions']:
+        if const.get('header'):
+            continue
+
         if const['type'] != 'const':
             cw.writes_defines(defines)
             defines = []
-- 
2.39.5



